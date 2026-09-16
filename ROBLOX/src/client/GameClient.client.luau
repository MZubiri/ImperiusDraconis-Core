--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local requestRemote = ReplicatedStorage:WaitForChild("ImperiusDragons"):WaitForChild("ImperiusGameRequest") :: RemoteFunction

local gui = Instance.new("ScreenGui")
gui.Name = "ImperiusDragonsGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local panel = Instance.new("Frame")
panel.Name = "StatusPanel"
panel.Size = UDim2.fromOffset(380, 240)
panel.Position = UDim2.new(0.5, -190, 0.5, -120)
panel.BackgroundColor3 = Color3.fromRGB(31, 22, 51)
panel.Parent = gui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 18)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -32, 0, 48)
title.Position = UDim2.fromOffset(16, 14)
title.BackgroundTransparency = 1
title.Text = "IMPERIUS DRAGONS"
title.TextColor3 = Color3.fromRGB(233, 216, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = panel

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -32, 0, 72)
status.Position = UDim2.fromOffset(16, 70)
status.BackgroundTransparency = 1
status.TextColor3 = Color3.fromRGB(255, 255, 255)
status.TextWrapped = true
status.Text = "Cargando tu perfil…"
status.Parent = panel

local codeBox = Instance.new("TextBox")
codeBox.Size = UDim2.new(1, -32, 0, 44)
codeBox.Position = UDim2.fromOffset(16, 142)
codeBox.PlaceholderText = "Codigo de Imperius"
codeBox.Text = ""
codeBox.ClearTextOnFocus = false
codeBox.Parent = panel
Instance.new("UICorner", codeBox).CornerRadius = UDim.new(0, 10)

local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -32, 0, 40)
button.Position = UDim2.fromOffset(16, 192)
button.Text = "VINCULAR"
button.BackgroundColor3 = Color3.fromRGB(119, 76, 180)
button.TextColor3 = Color3.new(1, 1, 1)
button.Parent = panel
Instance.new("UICorner", button).CornerRadius = UDim.new(0, 10)

local function invoke(action: string, payload: any?): any
	local ok, result = pcall(requestRemote.InvokeServer, requestRemote, action, payload or {})
	if not ok then return { ok = false, error = { message = "No se pudo comunicar con el servidor." } } end
	return result
end

local function showBootstrap(data: any)
	status.Text = `{data.player.displayName} · {data.economy.dracoins} Dracoins\nHuevos: #{data.eggs} · Dragones: #{data.dragons} · Espacios: {data.capacity.availableSlots}`
	codeBox.Visible = false
	button.Visible = false
	task.delay(5, function() panel.Visible = false end)
end

button.Activated:Connect(function()
	button.Active = false
	status.Text = "Vinculando…"
	local result = invoke("link", { code = codeBox.Text })
	button.Active = true
	if not result.ok then status.Text = result.error.message or "No se pudo vincular." return end
	local bootstrap = invoke("bootstrap")
	if bootstrap.ok then showBootstrap(bootstrap.data) else status.Text = bootstrap.error.message end
end)

local initial = invoke("bootstrap")
if initial.ok then
	showBootstrap(initial.data)
else
	status.Text = "Tu cuenta aún no está vinculada. Genera un código en imperiusdraconis.online."
end
