using System.Data;
using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Data;
using ImperiusDraconisAPI.Models.Game.Admin;
using Microsoft.AspNetCore.Http;
using MySqlConnector;

namespace ImperiusDraconisAPI.Services.Game;

public sealed class GameAdminService
{
    private readonly MySqlConnectionFactory _factory;
    private readonly GameEggService _eggs;
    private readonly GameDragonService _dragons;
    private readonly DracoinGameService _dracoins;

    public GameAdminService(MySqlConnectionFactory factory, GameEggService eggs, GameDragonService dragons, DracoinGameService dracoins)
    {
        _factory = factory;
        _eggs = eggs;
        _dragons = dragons;
        _dracoins = dracoins;
    }

    public async Task<GameAdminPlayer> GetPlayerAsync(int? idAlumno, long? robloxUserId, CancellationToken ct)
    {
        if (idAlumno is null && robloxUserId is null)
            throw Rule("BUSINESS_RULE_ERROR", "Indica IdAlumno o RobloxUserId.", 400);
        await using var connection = _factory.CreateConnection(); await connection.OpenAsync(ct);
        await using var command = new MySqlCommand(
            """
            SELECT A.IdAlumno, L.RobloxUserId, COALESCE(A.Nombre,''), COALESCE(A.Dracoins,0)
            FROM Alumnos A LEFT JOIN GameRobloxLinks L ON L.IdAlumno=A.IdAlumno AND L.Active=1
            WHERE (@IdAlumno IS NOT NULL AND A.IdAlumno=@IdAlumno)
               OR (@RobloxUserId IS NOT NULL AND L.RobloxUserId=@RobloxUserId)
            LIMIT 1;
            """, connection);
        command.Parameters.Add("@IdAlumno", MySqlDbType.Int32).Value = (object?)idAlumno ?? DBNull.Value;
        command.Parameters.Add("@RobloxUserId", MySqlDbType.Int64).Value = (object?)robloxUserId ?? DBNull.Value;
        int playerId; long? roblox; string name; decimal balance;
        await using (var reader = await command.ExecuteReaderAsync(ct))
        {
            if (!await reader.ReadAsync(ct)) throw Rule("PLAYER_NOT_FOUND", "No se encontro el jugador.", 404);
            playerId=reader.GetInt32(0); roblox=reader.IsDBNull(1)?null:reader.GetInt64(1); name=reader.GetString(2); balance=reader.GetDecimal(3);
        }
        var eggs=await _eggs.ListByPlayerAsync(playerId,ct); var dragons=await _dragons.ListByPlayerAsync(playerId,ct);
        await using var ledgerCommand=new MySqlCommand("SELECT Id,Amount,BalanceAfter,Reason,ReferenceType,ReferenceId,CreatedAt FROM GameDracoinLedger WHERE IdAlumno=@Id ORDER BY CreatedAt DESC,Id DESC LIMIT 100;",connection);
        ledgerCommand.Parameters.AddWithValue("@Id",playerId);var ledger=new List<GameAdminLedgerEntry>();
        await using var ledgerReader=await ledgerCommand.ExecuteReaderAsync(ct);
        while(await ledgerReader.ReadAsync(ct))ledger.Add(new GameAdminLedgerEntry{Id=ledgerReader.GetInt64(0),Amount=ledgerReader.GetDecimal(1),BalanceAfter=ledgerReader.GetDecimal(2),Reason=ledgerReader.GetString(3),ReferenceType=ledgerReader.GetString(4),ReferenceId=ledgerReader.IsDBNull(5)?null:ledgerReader.GetString(5),CreatedAt=DateTime.SpecifyKind(ledgerReader.GetDateTime(6),DateTimeKind.Utc)});
        return new GameAdminPlayer{IdAlumno=playerId,RobloxUserId=roblox,DisplayName=name,Dracoins=balance,Eggs=eggs,Dragons=dragons,Ledger=ledger};
    }

    public async Task<GameAdminDracoinAdjustmentResponse> AdjustDracoinsAsync(GameAdminDracoinAdjustmentRequest request,int administratorId,CancellationToken ct)
    {
        if(request.IdAlumno<=0||request.Amount==0)throw Rule("BUSINESS_RULE_ERROR","El jugador y el monto son obligatorios.",400);
        var justification=request.Justification.Trim();if(justification.Length is <5 or >200)throw Rule("BUSINESS_RULE_ERROR","La justificacion debe contener entre 5 y 200 caracteres.",400);
        await using var connection=_factory.CreateConnection();await connection.OpenAsync(ct);await using var tx=(MySqlTransaction)await connection.BeginTransactionAsync(IsolationLevel.Serializable,ct);
        try
        {
            var balance=await _dracoins.UpdateBalanceAsync(connection,tx,request.IdAlumno,request.Amount,"ADMIN_ADJUSTMENT","GAME_ADMIN",$"admin:{administratorId}; {justification}",ct);
            await tx.CommitAsync(ct);return new GameAdminDracoinAdjustmentResponse{IdAlumno=request.IdAlumno,Amount=request.Amount,BalanceAfter=balance};
        }catch{await tx.RollbackAsync(ct);throw;}
    }

    public async Task RestoreDragonAsync(long dragonId,CancellationToken ct)
    {
        await using var connection=_factory.CreateConnection();await connection.OpenAsync(ct);
        await using var command=new MySqlCommand("UPDATE GameDragons SET Status='ACTIVE',Life=GREATEST(Life,50),Happiness=GREATEST(Happiness,30),Hunger=GREATEST(Hunger,30),LastNeedsUpdateAt=UTC_TIMESTAMP(3) WHERE Id=@Id AND Status='FLED';",connection);
        command.Parameters.AddWithValue("@Id",dragonId);if(await command.ExecuteNonQueryAsync(ct)!=1)throw Rule("DRAGON_NOT_RESTORABLE","El dragon no existe o no esta huido.",409);
    }

    public async Task<GameAdminCatalogs> GetCatalogsAsync(CancellationToken ct)
    {
        await using var connection=_factory.CreateConnection();await connection.OpenAsync(ct);
        var eggs=await ReadPriceCatalogAsync(connection,"GameEggDefinitions",ct);
        var foods=await ReadPriceCatalogAsync(connection,"GameFoodDefinitions",ct);
        await using var command=new MySqlCommand("SELECT Code,DisplayName,TargetAmount,RewardDracoins,RewardExperience,Active FROM GameMissionDefinitions ORDER BY SortOrder,Code;",connection);
        var missions=new List<GameAdminMissionCatalogItem>();await using var reader=await command.ExecuteReaderAsync(ct);
        while(await reader.ReadAsync(ct))missions.Add(new GameAdminMissionCatalogItem{Code=reader.GetString(0),DisplayName=reader.GetString(1),TargetAmount=reader.GetInt32(2),RewardDracoins=reader.GetInt32(3),RewardExperience=reader.GetInt32(4),Active=reader.GetBoolean(5)});
        return new GameAdminCatalogs{Eggs=eggs,Foods=foods,Missions=missions};
    }

    public async Task UpdateEggDefinitionAsync(string code,GameAdminCatalogUpdateRequest request,CancellationToken ct)=>await UpdateCatalogAsync("GameEggDefinitions",code,request,ct);
    public async Task UpdateFoodDefinitionAsync(string code,GameAdminCatalogUpdateRequest request,CancellationToken ct)=>await UpdateCatalogAsync("GameFoodDefinitions",code,request,ct);
    public async Task UpdateMissionDefinitionAsync(string code,GameAdminMissionUpdateRequest request,CancellationToken ct)
    {
        if(request.TargetAmount is <1 or >1000||request.RewardDracoins is <0 or >100000||request.RewardExperience is <0 or >100000)
            throw Rule("BUSINESS_RULE_ERROR","Los valores de la mision no son validos.",400);
        var normalized=NormalizeCode(code);await using var connection=_factory.CreateConnection();await connection.OpenAsync(ct);
        await using var command=new MySqlCommand("UPDATE GameMissionDefinitions SET TargetAmount=@Target,RewardDracoins=@Dracoins,RewardExperience=@Experience,Active=@Active WHERE Code=@Code;",connection);
        command.Parameters.AddWithValue("@Target",request.TargetAmount);command.Parameters.AddWithValue("@Dracoins",request.RewardDracoins);command.Parameters.AddWithValue("@Experience",request.RewardExperience);command.Parameters.AddWithValue("@Active",request.Active);command.Parameters.AddWithValue("@Code",normalized);
        if(await command.ExecuteNonQueryAsync(ct)!=1)throw Rule("CATALOG_ITEM_NOT_FOUND","No se encontro la mision.",404);
    }
    private async Task UpdateCatalogAsync(string table,string code,GameAdminCatalogUpdateRequest request,CancellationToken ct)
    {
        if(request.PriceDracoins<0||request.PriceDracoins>100000)throw Rule("BUSINESS_RULE_ERROR","El precio no es valido.",400);
        var normalized=NormalizeCode(code);
        await using var connection=_factory.CreateConnection();await connection.OpenAsync(ct);
        await using var command=new MySqlCommand($"UPDATE {table} SET PriceDracoins=@Price,Active=@Active WHERE Code=@Code;",connection);
        command.Parameters.AddWithValue("@Price",request.PriceDracoins);command.Parameters.AddWithValue("@Active",request.Active);command.Parameters.AddWithValue("@Code",normalized);
        if(await command.ExecuteNonQueryAsync(ct)!=1)throw Rule("CATALOG_ITEM_NOT_FOUND","No se encontro el elemento del catalogo.",404);
    }
    private static async Task<List<GameAdminPriceCatalogItem>> ReadPriceCatalogAsync(MySqlConnection connection,string table,CancellationToken ct)
    {
        await using var command=new MySqlCommand($"SELECT Code,DisplayName,PriceDracoins,Active FROM {table} ORDER BY SortOrder,Code;",connection);
        var items=new List<GameAdminPriceCatalogItem>();await using var reader=await command.ExecuteReaderAsync(ct);
        while(await reader.ReadAsync(ct))items.Add(new GameAdminPriceCatalogItem{Code=reader.GetString(0),DisplayName=reader.GetString(1),PriceDracoins=reader.GetInt32(2),Active=reader.GetBoolean(3)});
        return items;
    }
    private static string NormalizeCode(string code)
    {
        var normalized=code.Trim().ToUpperInvariant();
        if(normalized.Length is 0 or >50||normalized.Any(ch=>!(char.IsAsciiLetterOrDigit(ch)||ch=='_')))
            throw Rule("BUSINESS_RULE_ERROR","El codigo no es valido.",400);
        return normalized;
    }
    private static GameBusinessRuleException Rule(string code,string message,int status)=>new(code,message,status);
}
