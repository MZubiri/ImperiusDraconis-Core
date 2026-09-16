using System.Data;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Data;
using ImperiusDraconisAPI.Models.Game.Missions;
using Microsoft.AspNetCore.Http;
using MySqlConnector;

namespace ImperiusDraconisAPI.Services.Game;

public sealed class GameMissionService
{
    private static readonly JsonSerializerOptions JsonOptions = new(JsonSerializerDefaults.Web);
    private readonly MySqlConnectionFactory _connectionFactory;
    private readonly GameIdempotencyService _idempotencyService;
    private readonly DracoinGameService _dracoinGameService;

    public GameMissionService(MySqlConnectionFactory connectionFactory, GameIdempotencyService idempotencyService, DracoinGameService dracoinGameService)
    {
        _connectionFactory = connectionFactory;
        _idempotencyService = idempotencyService;
        _dracoinGameService = dracoinGameService;
    }

    public async Task<IReadOnlyCollection<GamePlayerMission>> GetDailyAsync(long robloxUserId, CancellationToken cancellationToken)
    {
        await using var connection = _connectionFactory.CreateConnection();
        await connection.OpenAsync(cancellationToken);
        var idAlumno = await GetPlayerIdAsync(connection, null, robloxUserId, cancellationToken);
        await using (var assign = new MySqlCommand(
            """
            INSERT IGNORE INTO GamePlayerMissions (IdAlumno, MissionDefinitionId, AssignedDate)
            SELECT @IdAlumno, Id, UTC_DATE() FROM GameMissionDefinitions
            WHERE Active = 1 ORDER BY SortOrder, Id LIMIT 3;
            """, connection))
        {
            assign.Parameters.AddWithValue("@IdAlumno", idAlumno);
            await assign.ExecuteNonQueryAsync(cancellationToken);
        }

        await using var command = new MySqlCommand(
            """
            SELECT PM.Id, D.Code, D.DisplayName, D.Description, D.MissionType, PM.ProgressAmount,
                   D.TargetAmount, D.RewardDracoins, D.RewardExperience, PM.Status, PM.AssignedDate
            FROM GamePlayerMissions PM INNER JOIN GameMissionDefinitions D ON D.Id=PM.MissionDefinitionId
            WHERE PM.IdAlumno=@IdAlumno AND PM.AssignedDate=UTC_DATE() ORDER BY D.SortOrder, PM.Id;
            """, connection);
        command.Parameters.AddWithValue("@IdAlumno", idAlumno);
        var missions = new List<GamePlayerMission>();
        await using var reader = await command.ExecuteReaderAsync(cancellationToken);
        while (await reader.ReadAsync(cancellationToken))
        {
            missions.Add(new GamePlayerMission
            {
                Id=reader.GetInt64(0), Code=reader.GetString(1), DisplayName=reader.GetString(2), Description=reader.GetString(3),
                MissionType=reader.GetString(4), ProgressAmount=reader.GetInt32(5), TargetAmount=reader.GetInt32(6),
                RewardDracoins=reader.GetInt32(7), RewardExperience=reader.GetInt32(8), Status=reader.GetString(9),
                AssignedDate=DateOnly.FromDateTime(reader.GetDateTime(10))
            });
        }
        return missions;
    }

    public async Task<ClaimGameMissionResponse> ClaimAsync(long missionId, ClaimGameMissionRequest request, string idempotencyKey, CancellationToken cancellationToken)
    {
        if (missionId <= 0 || request.RobloxUserId <= 0) throw Rule("BUSINESS_RULE_ERROR", "MissionId y RobloxUserId deben ser mayores a cero.", 400);
        var key=idempotencyKey.Trim(); if (key.Length is 0 or >100) throw Rule("BUSINESS_RULE_ERROR", "X-Idempotency-Key invalida.", 400);
        var hash=SHA256.HashData(Encoding.UTF8.GetBytes($"{missionId}:{request.RobloxUserId}"));
        await using var connection=_connectionFactory.CreateConnection(); await connection.OpenAsync(cancellationToken);
        await using var transaction=(MySqlTransaction)await connection.BeginTransactionAsync(IsolationLevel.Serializable,cancellationToken);
        try
        {
            var reservation=await _idempotencyService.ReserveAsync(connection,transaction,"GAME_MISSION_CLAIM",key,hash,cancellationToken);
            if(reservation.CompletedResponseJson is not null)
            {
                var replay=JsonSerializer.Deserialize<ClaimGameMissionResponse>(reservation.CompletedResponseJson,JsonOptions)!;
                await transaction.CommitAsync(cancellationToken); return replay;
            }
            var idAlumno=await GetPlayerIdAsync(connection,transaction,request.RobloxUserId,cancellationToken);
            await using var command=new MySqlCommand(
                """
                SELECT PM.Status,D.RewardDracoins,D.RewardExperience
                FROM GamePlayerMissions PM INNER JOIN GameMissionDefinitions D ON D.Id=PM.MissionDefinitionId
                WHERE PM.Id=@Id AND PM.IdAlumno=@IdAlumno FOR UPDATE;
                """,connection,transaction);
            command.Parameters.AddWithValue("@Id",missionId); command.Parameters.AddWithValue("@IdAlumno",idAlumno);
            string status; int dracoins; int experience;
            await using(var reader=await command.ExecuteReaderAsync(cancellationToken))
            {
                if(!await reader.ReadAsync(cancellationToken)) throw Rule("MISSION_NOT_FOUND","La mision no existe.",404);
                status=reader.GetString(0); dracoins=reader.GetInt32(1); experience=reader.GetInt32(2);
            }
            if(status!="COMPLETED") throw Rule("MISSION_NOT_COMPLETED","La mision aun no se puede reclamar.",409);
            decimal balance;
            if(dracoins>0) balance=await _dracoinGameService.UpdateBalanceAsync(connection,transaction,idAlumno,dracoins,"MISSION_REWARD","GAME_MISSION",missionId.ToString(),cancellationToken);
            else
            {
                await using var balanceCommand=new MySqlCommand("SELECT COALESCE(Dracoins,0) FROM Alumnos WHERE IdAlumno=@Id;",connection,transaction);
                balanceCommand.Parameters.AddWithValue("@Id",idAlumno); balance=Convert.ToDecimal(await balanceCommand.ExecuteScalarAsync(cancellationToken));
            }
            if(experience>0)
            {
                await using var xp=new MySqlCommand("UPDATE GameDragons SET Experience=Experience+@Xp WHERE IdAlumno=@IdAlumno AND Selected=1 AND Status='ACTIVE';",connection,transaction);
                xp.Parameters.AddWithValue("@Xp",experience); xp.Parameters.AddWithValue("@IdAlumno",idAlumno); await xp.ExecuteNonQueryAsync(cancellationToken);
            }
            await using(var update=new MySqlCommand("UPDATE GamePlayerMissions SET Status='CLAIMED',ClaimedAt=UTC_TIMESTAMP(3) WHERE Id=@Id;",connection,transaction))
            { update.Parameters.AddWithValue("@Id",missionId); await update.ExecuteNonQueryAsync(cancellationToken); }
            var response=new ClaimGameMissionResponse{MissionId=missionId,Status="CLAIMED",DracoinsAwarded=dracoins,ExperienceAwarded=experience,BalanceAfter=balance};
            await _idempotencyService.CompleteAsync(connection,transaction,reservation.Id,JsonSerializer.Serialize(response,JsonOptions),cancellationToken);
            await transaction.CommitAsync(cancellationToken); return response;
        }
        catch { await transaction.RollbackAsync(cancellationToken); throw; }
    }

    public static async Task AddProgressAsync(MySqlConnection connection, MySqlTransaction transaction, int idAlumno, string missionType, int amount, CancellationToken cancellationToken)
    {
        await using var command=new MySqlCommand(
            """
            UPDATE GamePlayerMissions PM INNER JOIN GameMissionDefinitions D ON D.Id=PM.MissionDefinitionId
            SET PM.ProgressAmount=LEAST(D.TargetAmount,PM.ProgressAmount+@Amount),
                PM.Status=CASE WHEN PM.ProgressAmount+@Amount>=D.TargetAmount THEN 'COMPLETED' ELSE PM.Status END
            WHERE PM.IdAlumno=@IdAlumno AND PM.AssignedDate=UTC_DATE() AND PM.Status='ACTIVE' AND D.MissionType=@MissionType;
            """,connection,transaction);
        command.Parameters.AddWithValue("@Amount",amount); command.Parameters.AddWithValue("@IdAlumno",idAlumno); command.Parameters.AddWithValue("@MissionType",missionType);
        await command.ExecuteNonQueryAsync(cancellationToken);
    }

    private static async Task<int> GetPlayerIdAsync(MySqlConnection connection, MySqlTransaction? transaction, long robloxUserId, CancellationToken cancellationToken)
    {
        if(robloxUserId<=0) throw Rule("BUSINESS_RULE_ERROR","RobloxUserId debe ser mayor a cero.",400);
        await using var command=new MySqlCommand("SELECT L.IdAlumno FROM GameRobloxLinks L INNER JOIN Alumnos A ON A.IdAlumno=L.IdAlumno WHERE L.RobloxUserId=@Id AND L.Active=1 AND A.Activo=1;",connection,transaction);
        command.Parameters.AddWithValue("@Id",robloxUserId); var value=await command.ExecuteScalarAsync(cancellationToken);
        if(value is null) throw Rule("NOT_LINKED","La cuenta Roblox no se encuentra vinculada.",404); return Convert.ToInt32(value);
    }
    private static GameBusinessRuleException Rule(string code,string message,int status)=>new(code,message,status);
}
