--!strict
local HttpService = game:GetService("HttpService")
local ServerStorage = game:GetService("ServerStorage")

local ApiClient = {}

local function config(): (string, string)
	local baseUrl = ServerStorage:GetAttribute("IMPERIUS_API_URL")
	local apiKey = ServerStorage:GetAttribute("IMPERIUS_GAME_API_KEY")
	assert(typeof(baseUrl) == "string" and #baseUrl > 0, "Falta ServerStorage.IMPERIUS_API_URL")
	assert(typeof(apiKey) == "string" and #apiKey >= 32, "Falta ServerStorage.IMPERIUS_GAME_API_KEY")
	return baseUrl, apiKey
end

local function decode(body: string): any
	if body == "" then return nil end
	local ok, value = pcall(HttpService.JSONDecode, HttpService, body)
	return if ok then value else { message = "La API devolvio una respuesta invalida." }
end

function ApiClient.request(method: string, path: string, body: any?, idempotencyKey: string?): (boolean, any)
	local baseUrl, apiKey = config()
	local headers: {[string]: string} = {
		["Content-Type"] = "application/json",
		["X-Game-Api-Key"] = apiKey,
	}
	if idempotencyKey then headers["X-Idempotency-Key"] = idempotencyKey end

	local request = {
		Url = baseUrl .. path,
		Method = method,
		Headers = headers,
		Body = if body == nil then nil else HttpService:JSONEncode(body),
	}
	local ok, response = pcall(HttpService.RequestAsync, HttpService, request)
	if not ok then return false, { code = "NETWORK_ERROR", message = "No se pudo contactar a Imperius." } end
	local data = decode(response.Body)
	if response.Success then return true, data end
	return false, data or { code = "HTTP_ERROR", message = `Error HTTP {response.StatusCode}` }
end

function ApiClient.newIdempotencyKey(player: Player, action: string): string
	return `{player.UserId}:{action}:{HttpService:GenerateGUID(false)}`
end

return ApiClient
