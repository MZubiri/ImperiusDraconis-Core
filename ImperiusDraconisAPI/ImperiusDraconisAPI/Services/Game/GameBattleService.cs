using System.Data;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using ImperiusDraconisAPI.Common;
using ImperiusDraconisAPI.Data;
using ImperiusDraconisAPI.Models.Game.Battles;
using ImperiusDraconisAPI.Models.Game.Players;
using Microsoft.AspNetCore.Http;
using MySqlConnector;

namespace ImperiusDraconisAPI.Services.Game;

public sealed class GameBattleService
{
    private static readonly JsonSerializerOptions JsonOptions=new(JsonSerializerDefaults.Web);
    private readonly MySqlConnectionFactory _factory; private readonly GameIdempotencyService _idempotency; private readonly DracoinGameService _dracoins;
    public GameBattleService(MySqlConnectionFactory factory,GameIdempotencyService idempotency,DracoinGameService dracoins){_factory=factory;_idempotency=idempotency;_dracoins=dracoins;}

    public async Task<AutomaticBattleResponse> BattleAsync(AutomaticBattleRequest request,string idempotencyKey,CancellationToken ct)
    {
        if(request.RobloxUserId<=0)throw Rule("BUSINESS_RULE_ERROR","RobloxUserId debe ser mayor a cero.",400);
        var key=idempotencyKey.Trim();if(key.Length is 0 or >100)throw Rule("BUSINESS_RULE_ERROR","X-Idempotency-Key invalida.",400);
        var hash=SHA256.HashData(Encoding.UTF8.GetBytes(request.RobloxUserId.ToString()));
        await using var connection=_factory.CreateConnection();await connection.OpenAsync(ct);
        await using var tx=(MySqlTransaction)await connection.BeginTransactionAsync(IsolationLevel.Serializable,ct);
        try
        {
            var reservation=await _idempotency.ReserveAsync(connection,tx,"GAME_BATTLE_AUTOMATIC",key,hash,ct);
            if(reservation.CompletedResponseJson is not null){var replay=JsonSerializer.Deserialize<AutomaticBattleResponse>(reservation.CompletedResponseJson,JsonOptions)!;await tx.CommitAsync(ct);return replay;}
            var player=await ReadPlayerAsync(connection,tx,request.RobloxUserId,ct);
            var playerId=player.Id!.Value;var playerIdAlumno=player.IdAlumno!.Value;
            if(player.Status=="FLED"||player.Life<10)throw Rule("DRAGON_CANNOT_BATTLE","El dragon seleccionado no puede combatir.",409);
            var opponent=await ReadOpponentAsync(connection,tx,player,ct)??await ReadWildAsync(connection,tx,player.Level,ct);
            var playerLife=player.Life;var opponentLife=opponent.Life;var rounds=new List<GameBattleRound>();
            for(var round=1;round<=10&&playerLife>0&&opponentLife>0;round++)
            {
                var playerDamage=Math.Max(1,ApplyElement(player.Attack-opponent.Defense/2+Random.Shared.Next(-2,3),player.Element,opponent.Element));
                var opponentDamage=Math.Max(1,ApplyElement(opponent.Attack-player.Defense/2+Random.Shared.Next(-2,3),opponent.Element,player.Element));
                opponentLife=Math.Max(0,opponentLife-playerDamage);playerLife=Math.Max(0,playerLife-opponentDamage);
                rounds.Add(new GameBattleRound{Round=round,PlayerDamage=playerDamage,OpponentDamage=opponentDamage,PlayerLife=playerLife,OpponentLife=opponentLife});
            }
            var result=playerLife==opponentLife?"DRAW":playerLife>opponentLife?"WIN":"LOSS";
            var rivalValue=Math.Max(1,5+opponent.Level-1+RarityValue(opponent.Rarity));
            var rankingPoints=opponent.IdAlumno is null?0:result=="WIN"?rivalValue:result=="DRAW"?(int)Math.Ceiling(rivalValue*.4m):0;
            await using var countCommand=new MySqlCommand("SELECT COUNT(*) FROM GameBattles WHERE IdAlumno=@Id AND CreatedAt>=UTC_DATE();",connection,tx);
            countCommand.Parameters.AddWithValue("@Id",playerIdAlumno);var dailyCount=Convert.ToInt32(await countCommand.ExecuteScalarAsync(ct));
            var rewardDracoins=dailyCount<5?(result=="WIN"?40:result=="DRAW"?20:10):0;
            var rewardExperience=result=="WIN"?12:result=="DRAW"?8:5;
            if(player.HouseName.Equals("Slytherin",StringComparison.OrdinalIgnoreCase)&&rewardDracoins>0)
            {
                await using var bonusCommand=new MySqlCommand(
                    """
                    SELECT COALESCE(SUM(GREATEST(RewardDracoins-CASE Result WHEN 'WIN' THEN 40 WHEN 'DRAW' THEN 20 ELSE 10 END,0)),0)
                    FROM GameBattles WHERE IdAlumno=@Id AND CreatedAt>=UTC_DATE() AND RewardDracoins>0;
                    """,connection,tx);
                bonusCommand.Parameters.AddWithValue("@Id",playerIdAlumno);
                var awardedToday=Convert.ToInt32(await bonusCommand.ExecuteScalarAsync(ct));
                rewardDracoins+=Math.Min(Math.Max(0,5-awardedToday),(int)Math.Ceiling(rewardDracoins*.05m));
            }
            if(player.HouseName.Equals("Gryffindor",StringComparison.OrdinalIgnoreCase))rewardExperience=(int)Math.Ceiling(rewardExperience*1.05m);
            if(player.Temperament=="CURIOSO")rewardExperience=(int)Math.Ceiling(rewardExperience*1.03m);
            var balance=player.Balance;
            if(rewardDracoins>0)balance=await _dracoins.UpdateBalanceAsync(connection,tx,playerIdAlumno,rewardDracoins,"BATTLE_REWARD","GAME_DRAGON",playerId.ToString(),ct);
            await using(var xp=new MySqlCommand("UPDATE GameDragons SET Experience=Experience+@Xp WHERE Id=@Id;",connection,tx)){xp.Parameters.AddWithValue("@Xp",rewardExperience);xp.Parameters.AddWithValue("@Id",playerId);await xp.ExecuteNonQueryAsync(ct);}
            var snapshot=JsonSerializer.Serialize(new{opponent.Name,opponent.SpeciesCode,opponent.Rarity,opponent.Level,opponent.Life,opponent.Attack,opponent.Defense},JsonOptions);
            var roundsJson=JsonSerializer.Serialize(rounds,JsonOptions);
            await using var insert=new MySqlCommand(
                """
                INSERT INTO GameBattles(IdAlumno,PlayerDragonId,OpponentAlumnoId,OpponentDragonId,WildDragonCode,OpponentSnapshotJson,RoundsJson,Result,RankingPoints,RewardDracoins,RewardExperience)
                VALUES(@IdAlumno,@PlayerDragonId,@OpponentAlumnoId,@OpponentDragonId,@WildCode,@Snapshot,@Rounds,@Result,@Points,@Dracoins,@Experience);SELECT LAST_INSERT_ID();
                """,connection,tx);
            insert.Parameters.AddWithValue("@IdAlumno",playerIdAlumno);insert.Parameters.AddWithValue("@PlayerDragonId",playerId);
            insert.Parameters.AddWithValue("@OpponentAlumnoId",(object?)opponent.IdAlumno??DBNull.Value);insert.Parameters.AddWithValue("@OpponentDragonId",(object?)opponent.Id??DBNull.Value);
            insert.Parameters.AddWithValue("@WildCode",(object?)opponent.WildCode??DBNull.Value);insert.Parameters.AddWithValue("@Snapshot",snapshot);insert.Parameters.AddWithValue("@Rounds",roundsJson);
            insert.Parameters.AddWithValue("@Result",result);insert.Parameters.AddWithValue("@Points",rankingPoints);insert.Parameters.AddWithValue("@Dracoins",rewardDracoins);insert.Parameters.AddWithValue("@Experience",rewardExperience);
            var battleId=Convert.ToInt64(await insert.ExecuteScalarAsync(ct));
            await GameMissionService.AddProgressAsync(connection,tx,playerIdAlumno,"COMPLETE_BATTLE",1,ct);
            var response=new AutomaticBattleResponse{BattleId=battleId,DragonId=playerId,OpponentName=opponent.Name,Result=result,RankingPoints=rankingPoints,RewardDracoins=rewardDracoins,RewardExperience=rewardExperience,BalanceAfter=balance,Rounds=rounds};
            await _idempotency.CompleteAsync(connection,tx,reservation.Id,JsonSerializer.Serialize(response,JsonOptions),ct);await tx.CommitAsync(ct);return response;
        }
        catch{await tx.RollbackAsync(ct);throw;}
    }

    public async Task<IReadOnlyCollection<GameRankingEntry>> GetRankingAsync(int limit,CancellationToken ct)
    {
        limit=Math.Clamp(limit,1,50);await using var connection=_factory.CreateConnection();await connection.OpenAsync(ct);
        await using var command=new MySqlCommand(
            """
            SELECT L.RobloxUserId,COALESCE(A.Nombre,''),COALESCE(C.Nombre,''),SUM(B.RankingPoints),SUM(B.Result='WIN'),COUNT(*)
            FROM GameBattles B INNER JOIN Alumnos A ON A.IdAlumno=B.IdAlumno
            INNER JOIN GameRobloxLinks L ON L.IdAlumno=A.IdAlumno AND L.Active=1 LEFT JOIN Casas C ON C.IdCasa=A.IdCasa
            GROUP BY B.IdAlumno,L.RobloxUserId,A.Nombre,C.Nombre ORDER BY SUM(B.RankingPoints) DESC,SUM(B.Result='WIN') DESC,MIN(B.CreatedAt) LIMIT @Limit;
            """,connection);command.Parameters.AddWithValue("@Limit",limit);
        var result=new List<GameRankingEntry>();await using var reader=await command.ExecuteReaderAsync(ct);var position=1;
        while(await reader.ReadAsync(ct))result.Add(new GameRankingEntry{Position=position++,RobloxUserId=reader.GetInt64(0),DisplayName=reader.GetString(1),HouseName=reader.GetString(2),Points=Convert.ToInt32(reader.GetDecimal(3)),Wins=Convert.ToInt32(reader.GetDecimal(4)),Battles=reader.GetInt32(5)});
        return result;
    }

    public async Task<GameBootstrapRankingDto> GetPlayerRankingAsync(long robloxUserId,CancellationToken ct)
    {
        await using var connection=_factory.CreateConnection();await connection.OpenAsync(ct);
        await using var command=new MySqlCommand(
            """
            WITH Scores AS (
                SELECT B.IdAlumno,SUM(B.RankingPoints) Points,SUM(B.Result='WIN') Wins,COUNT(*) Battles
                FROM GameBattles B GROUP BY B.IdAlumno
            ), Ranked AS (
                SELECT IdAlumno,Points,Wins,Battles,DENSE_RANK() OVER (ORDER BY Points DESC,Wins DESC) RankingPosition FROM Scores
            )
            SELECT COALESCE(R.RankingPosition,0),COALESCE(R.Points,0),COALESCE(R.Wins,0),COALESCE(R.Battles,0)
            FROM GameRobloxLinks L LEFT JOIN Ranked R ON R.IdAlumno=L.IdAlumno
            WHERE L.RobloxUserId=@RobloxUserId AND L.Active=1;
            """,connection);
        command.Parameters.AddWithValue("@RobloxUserId",robloxUserId);
        await using var reader=await command.ExecuteReaderAsync(ct);
        if(!await reader.ReadAsync(ct))return new GameBootstrapRankingDto();
        return new GameBootstrapRankingDto{Position=reader.GetInt32(0),Points=Convert.ToInt32(reader.GetDecimal(1)),Wins=Convert.ToInt32(reader.GetDecimal(2)),Battles=reader.GetInt32(3)};
    }

    private static async Task<Fighter> ReadPlayerAsync(MySqlConnection c,MySqlTransaction t,long roblox,CancellationToken ct)
    {
        await using var cmd=new MySqlCommand(
            """SELECT D.Id,D.IdAlumno,D.Name,D.SpeciesCode,D.Rarity,D.Level,D.Life,D.Status,DD.BaseAttack,DD.BaseDefense,COALESCE(A.Dracoins,0),DD.ElementCode,D.Stage,D.Temperament,COALESCE(C.Nombre,'') FROM GameRobloxLinks L INNER JOIN Alumnos A ON A.IdAlumno=L.IdAlumno INNER JOIN GameDragons D ON D.IdAlumno=A.IdAlumno AND D.Selected=1 INNER JOIN GameDragonDefinitions DD ON DD.Code=D.SpeciesCode LEFT JOIN Casas C ON C.IdCasa=A.IdCasa WHERE L.RobloxUserId=@Roblox AND L.Active=1 AND A.Activo=1 FOR UPDATE;""",c,t);
        cmd.Parameters.AddWithValue("@Roblox",roblox);await using var r=await cmd.ExecuteReaderAsync(ct);if(!await r.ReadAsync(ct))throw Rule("SELECTED_DRAGON_REQUIRED","Selecciona un dragon antes de combatir.",409);
        var level=r.GetInt32(5);var stage=r.GetString(12);var temperament=r.GetString(13);
        return new Fighter(r.GetInt64(0),r.GetInt32(1),null,r.GetString(2),r.GetString(3),r.GetString(4),level,r.GetInt32(6),r.GetString(7),CombatStat(r.GetInt32(8),level,stage,temperament,true),CombatStat(r.GetInt32(9),level,stage,temperament,false),r.GetDecimal(10),r.GetString(11),stage,temperament,r.GetString(14));
    }
    private static async Task<Fighter?> ReadOpponentAsync(MySqlConnection c,MySqlTransaction t,Fighter p,CancellationToken ct)
    {
        await using var cmd=new MySqlCommand(
            """SELECT D.Id,D.IdAlumno,D.Name,D.SpeciesCode,D.Rarity,D.Level,D.Life,D.Status,DD.BaseAttack,DD.BaseDefense,DD.ElementCode,D.Stage,D.Temperament FROM GameDragons D INNER JOIN GameDragonDefinitions DD ON DD.Code=D.SpeciesCode WHERE D.Selected=1 AND D.Status='ACTIVE' AND D.IdAlumno<>@IdAlumno ORDER BY ABS(D.Level-@Level),D.Id LIMIT 1;""",c,t);
        cmd.Parameters.AddWithValue("@IdAlumno",p.IdAlumno);cmd.Parameters.AddWithValue("@Level",p.Level);await using var r=await cmd.ExecuteReaderAsync(ct);if(!await r.ReadAsync(ct))return null;
        var level=r.GetInt32(5);var stage=r.GetString(11);var temperament=r.GetString(12);
        return new Fighter(r.GetInt64(0),r.GetInt32(1),null,r.GetString(2),r.GetString(3),r.GetString(4),level,r.GetInt32(6),r.GetString(7),CombatStat(r.GetInt32(8),level,stage,temperament,true),CombatStat(r.GetInt32(9),level,stage,temperament,false),0,r.GetString(10),stage,temperament,"");
    }
    private static async Task<Fighter> ReadWildAsync(MySqlConnection c,MySqlTransaction t,int level,CancellationToken ct)
    {
        await using var cmd=new MySqlCommand("SELECT W.Code,W.DisplayName,W.SpeciesCode,W.Rarity,LEAST(W.MaxLevel,GREATEST(W.MinLevel,@Level)),W.BaseLife,W.BaseAttack,W.BaseDefense,D.ElementCode FROM GameWildDragonDefinitions W INNER JOIN GameDragonDefinitions D ON D.Code=W.SpeciesCode WHERE W.Active=1 AND @Level BETWEEN W.MinLevel AND W.MaxLevel ORDER BY W.MinLevel DESC LIMIT 1;",c,t);cmd.Parameters.AddWithValue("@Level",level);
        await using var r=await cmd.ExecuteReaderAsync(ct);if(!await r.ReadAsync(ct))throw Rule("OPPONENT_NOT_AVAILABLE","No hay rival disponible para este nivel.",409);var opponentLevel=r.GetInt32(4);
        var stage=opponentLevel>=10?"ADULT":opponentLevel>=4?"YOUNG":"BABY";
        return new Fighter(null,null,r.GetString(0),r.GetString(1),r.GetString(2),r.GetString(3),opponentLevel,r.GetInt32(5),"ACTIVE",CombatStat(r.GetInt32(6),opponentLevel,stage,"",true),CombatStat(r.GetInt32(7),opponentLevel,stage,"",false),0,r.GetString(8),stage,"","");
    }
    private static int Scale(int value,int level)=>(int)Math.Round(value*(1+Math.Max(0,level-1)*.02m));
    private static int CombatStat(int value,int level,string stage,string temperament,bool attack)
    {
        var temperamentPct=attack?temperament switch{"AGRESIVO"=>5,"PEREZOSO"=>-2,_=>0}:temperament switch{"NOBLE"=>3,"AGRESIVO"=>-3,_=>0};
        var stageMultiplier=stage switch{"BABY"=>.75m,"ADULT"=>1.2m,_=>1m};
        return Math.Max(1,(int)Math.Round(Scale(value,level)*(1+temperamentPct/100m)*stageMultiplier));
    }
    private static int ApplyElement(int damage,string attacker,string defender)
    {
        var strong=attacker switch{"FIRE"=>new[]{"EARTH","ICE"},"WATER"=>new[]{"FIRE","POISON"},"EARTH"=>new[]{"AIR","POISON"},"AIR"=>new[]{"WATER","LIGHT"},"ICE"=>new[]{"WATER","AIR"},"LIGHT"=>new[]{"ICE","SHADOW"},"SHADOW"=>new[]{"LIGHT","FIRE"},"POISON"=>new[]{"LIGHT","SHADOW"},_=>[]};
        var weak=attacker switch{"FIRE"=>new[]{"WATER","AIR"},"WATER"=>new[]{"EARTH","ICE"},"EARTH"=>new[]{"FIRE","WATER"},"AIR"=>new[]{"EARTH","ICE"},"ICE"=>new[]{"FIRE","LIGHT"},"LIGHT"=>new[]{"AIR","POISON"},"SHADOW"=>new[]{"LIGHT","POISON"},"POISON"=>new[]{"WATER","EARTH"},_=>[]};
        var multiplier=strong.Contains(defender)?1.15m:weak.Contains(defender)?.85m:1m;return(int)Math.Round(damage*multiplier);
    }
    private static int RarityValue(string rarity)=>rarity switch{"RARE"=>2,"EPIC"=>4,"LEGENDARY"=>7,"MYTHIC"=>10,_=>0};
    private static GameBusinessRuleException Rule(string c,string m,int s)=>new(c,m,s);
    private sealed record Fighter(long? Id,int? IdAlumno,string? WildCode,string Name,string SpeciesCode,string Rarity,int Level,int Life,string Status,int Attack,int Defense,decimal Balance,string Element,string Stage,string Temperament,string HouseName);
}
