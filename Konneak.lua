-- Konneak | Simple Speed + Jump
-- Intended for a Roblox Studio LocalScript in a place you control.
-- Speed is adjustable from 16 to 100; Jump toggles JumpPower.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local existing = playerGui:FindFirstChild("Konneak")
if existing then existing:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "Konneak"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.Size = UDim2.fromOffset(250, 220)
panel.Position = UDim2.new(0, 18, 0.32, 0)
panel.BackgroundColor3 = Color3.fromRGB(19, 21, 30)
panel.BorderSizePixel = 0
panel.Parent = gui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 12)
local stroke = Instance.new("UIStroke", panel)
stroke.Color = Color3.fromRGB(86, 130, 255)
stroke.Thickness = 1.5

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -48, 0, 38)
title.Position = UDim2.fromOffset(12, 3)
title.BackgroundTransparency = 1
title.Text = "Konneak"
title.TextColor3 = Color3.fromRGB(225, 232, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = panel

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(30, 30)
close.Position = UDim2.new(1, -38, 0, 7)
close.BackgroundColor3 = Color3.fromRGB(48, 52, 69)
close.Text = "×"
close.TextColor3 = Color3.new(1, 1, 1)
close.Font = Enum.Font.GothamBold
close.TextSize = 20
close.Parent = panel
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 8)

local speedLabel = Instance.new("TextLabel")
speedLabel.Position = UDim2.fromOffset(12, 48)
speedLabel.Size = UDim2.new(1, -24, 0, 22)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.fromRGB(224, 228, 242)
speedLabel.Font = Enum.Font.GothamMedium
speedLabel.TextSize = 13
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = panel

local speedBox = Instance.new("TextBox")
speedBox.Position = UDim2.fromOffset(12, 73)
speedBox.Size = UDim2.new(1, -24, 0, 34)
speedBox.BackgroundColor3 = Color3.fromRGB(36, 39, 54)
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.PlaceholderText = "Speed 16-100"
speedBox.Text = "30"
speedBox.ClearTextOnFocus = false
speedBox.Font = Enum.Font.GothamMedium
speedBox.TextSize = 14
speedBox.Parent = panel
Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0, 7)

local applySpeed = Instance.new("TextButton")
applySpeed.Position = UDim2.fromOffset(12, 115)
applySpeed.Size = UDim2.new(1, -24, 0, 34)
applySpeed.BackgroundColor3 = Color3.fromRGB(45, 83, 70)
applySpeed.TextColor3 = Color3.fromRGB(255, 255, 255)
applySpeed.Text = "Apply Speed"
applySpeed.Font = Enum.Font.GothamMedium
applySpeed.TextSize = 13
applySpeed.Parent = panel
Instance.new("UICorner", applySpeed).CornerRadius = UDim.new(0, 7)

local jumpButton = Instance.new("TextButton")
jumpButton.Position = UDim2.fromOffset(12, 157)
jumpButton.Size = UDim2.new(1, -24, 0, 34)
jumpButton.BackgroundColor3 = Color3.fromRGB(36, 39, 54)
jumpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpButton.Text = "Super Jump: OFF"
jumpButton.Font = Enum.Font.GothamMedium
jumpButton.TextSize = 13
jumpButton.Parent = panel
Instance.new("UICorner", jumpButton).CornerRadius = UDim.new(0, 7)

local reopen = Instance.new("TextButton")
reopen.Name = "Reopen"
reopen.Size = UDim2.fromOffset(54, 54)
reopen.Position = UDim2.new(0, 18, 0.32, 0)
reopen.BackgroundColor3 = Color3.fromRGB(22, 24, 32)
reopen.Text = "K"
reopen.TextColor3 = Color3.fromRGB(225, 232, 255)
reopen.Font = Enum.Font.GothamBold
reopen.TextSize = 20
reopen.Visible = false
reopen.Parent = gui
Instance.new("UICorner", reopen).CornerRadius = UDim.new(1, 0)
local reopenStroke = Instance.new("UIStroke", reopen)
reopenStroke.Color = Color3.fromRGB(86, 130, 255)
reopenStroke.Thickness = 2

local speedOn = false
local jumpOn = false
local speedValue = 30
local defaultSpeed = 16
local defaultJump = 50

local function getHumanoid()
    local character = player.Character
    return character and character:FindFirstChildOfClass("Humanoid")
end

local function captureDefaults()
    local h = getHumanoid()
    if h then
        defaultSpeed = h.WalkSpeed
        h.UseJumpPower = true
        defaultJump = h.JumpPower
    end
end

local function apply()
    local h = getHumanoid()
    if not h then return end
    h.UseJumpPower = true
    h.WalkSpeed = speedOn and speedValue or defaultSpeed
    h.JumpPower = jumpOn and 85 or defaultJump
end

captureDefaults()
player.CharacterAdded:Connect(function()
    task.wait(0.5)
    captureDefaults()
    apply()
end)

applySpeed.Activated:Connect(function()
    local n = tonumber(speedBox.Text)
    if not n then
        speedLabel.Text = "Enter a number from 16 to 100"
        return
    end
    speedValue = math.clamp(math.floor(n), 16, 100)
    speedBox.Text = tostring(speedValue)
    speedOn = true
    speedLabel.Text = "Speed: " .. speedValue .. " (ON)"
    apply()
end)

jumpButton.Activated:Connect(function()
    jumpOn = not jumpOn
    jumpButton.Text = "Super Jump: " .. (jumpOn and "ON" or "OFF")
    jumpButton.BackgroundColor3 = jumpOn and Color3.fromRGB(35, 79, 66) or Color3.fromRGB(36, 39, 54)
    apply()
end)

close.Activated:Connect(function()
    panel.Visible = false
    reopen.Visible = true
end)
reopen.Activated:Connect(function()
    panel.Visible = true
    reopen.Visible = false
end)

-- Drag panel using its title; supports mouse and touch.
local dragging, dragInput, dragStart, startPos
 title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging, dragInput = true, input
        dragStart, startPos = input.Position, panel.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        reopen.Position = panel.Position
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input == dragInput then dragging = false end
end)

speedLabel.Text = "Speed: ready (16-100)"
print("Konneak loaded. Game-side restrictions may override local movement values.")
