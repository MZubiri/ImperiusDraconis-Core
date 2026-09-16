--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ApiClient = require(script.Parent.ApiClient)

local folder = ReplicatedStorage:FindFirstChild("ImperiusDragons") or Instance.new("Folder")
folder.Name = "ImperiusDragons"
folder.Parent = ReplicatedStorage
local requestRemote = folder:FindFirstChild("ImperiusGameRequest") or Instance.new("RemoteFunction")
requestRemote.Name = "ImperiusGameRequest"
requestRemote.Parent = folder

local sessions: {[Player]: any} = {}
local lastRequestAt: {[Player]: number} = {}

local function call(player: Player, action: string, payload: any): (boolean, any)
	local userId = player.UserId
	if action == "bootstrap" then
		return ApiClient.request("GET", `/players/by-roblox/{userId}`, nil, nil)
	elseif action == "link" then
		return ApiClient.request("POST", "/links/consume", { code = payload.code, robloxUserId = userId }, ApiClient.newIdempotencyKey(player, action))
	elseif action == "purchaseEgg" then
		return ApiClient.request("POST", "/eggs/purchase", { robloxUserId = userId, eggDefinitionCode = payload.code }, ApiClient.newIdempotencyKey(player, action))
	elseif action == "incubate" then
		return ApiClient.request("POST", `/eggs/{payload.eggId}/incubate`, { robloxUserId = userId }, ApiClient.newIdempotencyKey(player, action))
	elseif action == "hatch" then
		return ApiClient.request("POST", `/eggs/{payload.eggId}/hatch`, { robloxUserId = userId, name = payload.name }, ApiClient.newIdempotencyKey(player, action))
	elseif action == "selectDragon" then
		return ApiClient.request("POST", `/dragons/{payload.dragonId}/select`, { robloxUserId = userId }, ApiClient.newIdempotencyKey(player, action))
	elseif action == "feed" then
		return ApiClient.request("POST", `/dragons/{payload.dragonId}/feed/{payload.foodCode}`, { robloxUserId = userId }, ApiClient.newIdempotencyKey(player, action))
	elseif action == "pet" then
		return ApiClient.request("POST", `/dragons/{payload.dragonId}/pet`, { robloxUserId = userId }, ApiClient.newIdempotencyKey(player, action))
	elseif action == "buyCapacity" then
		return ApiClient.request("POST", `/players/{userId}/dragon-capacity/purchase`, nil, ApiClient.newIdempotencyKey(player, action))
	elseif action == "eggCatalog" then
		return ApiClient.request("GET", "/eggs/catalog", nil, nil)
	elseif action == "foodCatalog" then
		return ApiClient.request("GET", "/dragons/food-catalog", nil, nil)
	elseif action == "pendingGifts" then
		return ApiClient.request("GET", `/egg-gifts/pending/by-roblox/{userId}`, nil, nil)
	elseif action == "missions" then
		return ApiClient.request("GET", `/missions/by-roblox/{userId}`, nil, nil)
	elseif action == "claimMission" then
		return ApiClient.request("POST", `/missions/{payload.missionId}/claim`, { robloxUserId = userId }, ApiClient.newIdempotencyKey(player, action))
	elseif action == "battle" then
		return ApiClient.request("POST", "/battles/automatic", { robloxUserId = userId }, ApiClient.newIdempotencyKey(player, action))
	elseif action == "ranking" then
		return ApiClient.request("GET", "/ranking?limit=50", nil, nil)
	end
	return false, { code = "UNKNOWN_ACTION", message = "Accion no permitida." }
end

requestRemote.OnServerInvoke = function(player: Player, action: any, payload: any?)
	if typeof(action) ~= "string" or (payload ~= nil and typeof(payload) ~= "table") then
		return { ok = false, error = { code = "INVALID_REQUEST", message = "Solicitud invalida." } }
	end
	local now = os.clock()
	if now - (lastRequestAt[player] or 0) < 0.15 then
		return { ok = false, error = { code = "RATE_LIMITED", message = "Espera un momento antes de intentarlo de nuevo." } }
	end
	lastRequestAt[player] = now
	local ok, result = call(player, action, payload or {})
	if ok and (action == "bootstrap" or action == "link") then sessions[player] = result end
	return if ok then { ok = true, data = result } else { ok = false, error = result }
end

Players.PlayerRemoving:Connect(function(player)
	sessions[player] = nil
	lastRequestAt[player] = nil
end)
