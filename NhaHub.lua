-- Nha Hub | Steal an Egg
-- Compact UI framework for Roblox Luau

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "NhaHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(280, 330)
main.Position = UDim2.new(0.5, -140, 0.5, -165)
main.BackgroundColor3 = Color3.fromRGB(20, 21, 30)
main.BorderSizePixel = 0
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 44)
title.BackgroundTransparency = 1
title.Text = "NHA HUB  |  V2"
title.TextColor3 = Color3.fromRGB(190, 170, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = main

local list = Instance.new("Frame")
list.Position = UDim2.fromOffset(12, 52)
list.Size = UDim2.new(1, -24, 1, -64)
list.BackgroundTransparency = 1
list.Parent = main
local layout = Instance.new("UIListLayout", list)
layout.Padding = UDim.new(0, 7)

local state = {}
local function toggle(label, key, callback)
    state[key] = false
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 34)
    b.BackgroundColor3 = Color3.fromRGB(36, 38, 52)
    b.TextColor3 = Color3.fromRGB(230, 230, 240)
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 13
    b.Parent = list
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
    local function refresh()
        b.Text = label .. "  [" .. (state[key] and "ON" or "OFF") .. "]"
    end
    b.Activated:Connect(function()
        state[key] = not state[key]
        refresh()
        if callback then callback(state[key]) end
    end)
    refresh()
end

toggle("Auto Steal V2", "AutoSteal", function(v)
    print("Auto Steal V2 toggle:", v, "- connect to your game's supported mechanics")
end)
toggle("Teleport", "Teleport", function(v)
    print("Teleport toggle:", v)
end)
toggle("Anti-Hit", "AntiHit", function(v)
    print("Anti-Hit toggle:", v)
end)
toggle("Auto Race", "AutoRace", function(v)
    print("Auto Race toggle:", v)
end)

local eggPanel = Instance.new("TextLabel")
eggPanel.Size = UDim2.new(1, 0, 0, 48)
eggPanel.BackgroundColor3 = Color3.fromRGB(29, 30, 43)
eggPanel.TextColor3 = Color3.fromRGB(220, 220, 235)
eggPanel.Font = Enum.Font.Gotham
eggPanel.TextSize = 12
eggPanel.Text = "Egg List\nNo game egg data connected"
eggPanel.Visible = false
eggPanel.LayoutOrder = 5
eggPanel.Parent = list
Instance.new("UICorner", eggPanel).CornerRadius = UDim.new(0, 7)
toggle("Egg List", "EggList", function(v)
    eggPanel.Visible = v
end)
toggle("FPS Quality", "FPSBoost", function(v)
    settings().Rendering.QualityLevel = v
        and Enum.QualityLevel.Level01
        or Enum.QualityLevel.Automatic
end)

-- Drag the panel on mouse or touch devices.
local dragging, dragStart, frameStart = false, nil, nil
title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging, dragStart, frameStart = true, input.Position, main.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and dragStart and
        (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragStart
        main.Position = UDim2.new(frameStart.X.Scale, frameStart.X.Offset + d.X,
            frameStart.Y.Scale, frameStart.Y.Offset + d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

print("Nha Hub loaded. Game-specific actions need supported game integrations.")
