-- ============================================================
-- NhaHub | Steal An Egg
-- Keyless, mobile compatible, executor required
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

-- CONFIG
local CONFIG = {
    TOGGLE_KEY = Enum.KeyCode.LeftControl,
    STEAL_INTERVAL = 0.15,
    AUTO_STEAL = false,
    AUTO_HATCH = false,
    ESP_ENABLED = false,
    WALK_SPEED = 16,
}

-- ============================================================
-- UI CONSTRUCTION
-- ============================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NhaHub_StealEgg"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 480, 0, 340)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(16, 18, 26)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(60, 70, 90)
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(22, 26, 38)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -80, 1, 0)
TitleLabel.Position = UDim2.new(0, 16, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "NhaHub | steal an egg"
TitleLabel.TextColor3 = Color3.fromRGB(240, 245, 255)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 28, 0, 28)
CloseButton.Position = UDim2.new(1, -36, 0, 6)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 20
CloseButton.Font = Enum.Font.GothamBold
CloseButton.BorderSizePixel = 0
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

local Content = Instance.new("ScrollingFrame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -20, 1, -50)
Content.Position = UDim2.new(0, 10, 0, 42)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 4
Content.ScrollBarImageColor3 = Color3.fromRGB(80, 100, 130)
Content.CanvasSize = UDim2.new(0, 0, 0, 400)
Content.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = Content

-- ============================================================
-- TOGGLE BUTTON
-- ============================================================

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 100, 0, 36)
ToggleButton.Position = UDim2.new(0, 20, 0.5, -18)
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 90, 140)
ToggleButton.Text = "NhaHub"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 14
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.BorderSizePixel = 0
ToggleButton.Visible = false
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleButton

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(80, 180, 230)
ToggleStroke.Thickness = 1.5
ToggleStroke.Parent = ToggleButton

-- ============================================================
-- UI HELPERS
-- ============================================================

local function createToggle(label, initial, callback)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, -8, 0, 42)
    Row.BackgroundColor3 = Color3.fromRGB(24, 28, 40)
    Row.BorderSizePixel = 0
    Row.Parent = Content

    local RowCorner = Instance.new("UICorner")
    RowCorner.CornerRadius = UDim.new(0, 8)
    RowCorner.Parent = Row

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = label
    Label.TextColor3 = Color3.fromRGB(220, 230, 245)
    Label.TextSize = 14
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(0, 56, 0, 28)
    Toggle.Position = UDim2.new(1, -68, 0.5, -14)
    Toggle.BackgroundColor3 = initial and Color3.fromRGB(40, 160, 90) or Color3.fromRGB(60, 65, 80)
    Toggle.Text = initial and "ON" or "OFF"
    Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    Toggle.TextSize = 12
    Toggle.Font = Enum.Font.GothamBold
    Toggle.BorderSizePixel = 0
    Toggle.Parent = Row

    local ToggleUICorner = Instance.new("UICorner")
    ToggleUICorner.CornerRadius = UDim.new(0, 6)
    ToggleUICorner.Parent = Toggle

    local state = initial

    Toggle.MouseButton1Click:Connect(function()
        state = not state
        Toggle.BackgroundColor3 = state and Color3.fromRGB(40, 160, 90) or Color3.fromRGB(60, 65, 80)
        Toggle.Text = state and "ON" or "OFF"
        if callback then callback(state) end
    end)

    return Toggle
end

local function createSlider(label, min, max, initial, callback)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, -8, 0, 52)
    Row.BackgroundColor3 = Color3.fromRGB(24, 28, 40)
    Row.BorderSizePixel = 0
    Row.Parent = Content

    local RowCorner = Instance.new("UICorner")
    RowCorner.CornerRadius = UDim.new(0, 8)
    RowCorner.Parent = Row

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.5, 0, 0, 20)
    Label.Position = UDim2.new(0, 12, 0, 4)
    Label.BackgroundTransparency = 1
    Label.Text = label
    Label.TextColor3 = Color3.fromRGB(220, 230, 245)
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0.3, 0, 0, 20)
    ValueLabel.Position = UDim2.new(0.7, 0, 0, 4)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(initial)
    ValueLabel.TextColor3 = Color3.fromRGB(100, 180, 240)
    ValueLabel.TextSize = 13
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = Row

    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new(0.9, 0, 0, 8)
    Bar.Position = UDim2.new(0.05, 0, 0, 32)
    Bar.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
    Bar.BorderSizePixel = 0
    Bar.Parent = Row

    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(0, 4)
    BarCorner.Parent = Bar

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((initial - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(60, 180, 240)
    Fill.BorderSizePixel = 0
    Fill.Parent = Bar

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(0, 4)
    FillCorner.Parent = Fill

    local Handle = Instance.new("Frame")
    Handle.Size = UDim2.new(0, 14, 0, 14)
    Handle.Position = UDim2.new((initial - min) / (max - min), -7, 0.5, -7)
    Handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Handle.BorderSizePixel = 0
    Handle.Parent = Bar

    local HandleCorner = Instance.new("UICorner")
    HandleCorner.CornerRadius = UDim.new(1, 0)
    HandleCorner.Parent = Handle

    local dragging = false
    local currentValue = initial

    Bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)

    Bar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local relX = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
            currentValue = math.floor(min + (max - min) * relX + 0.5)
            Fill.Size = UDim2.new(relX, 0, 1, 0)
            Handle.Position = UDim2.new(relX, -7, 0.5, -7)
            ValueLabel.Text = tostring(currentValue)
            if callback then callback(currentValue) end
        end
    end)
end

local function createButton(label, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -8, 0, 38)
    Button.BackgroundColor3 = Color3.fromRGB(30, 60, 100)
    Button.Text = label
    Button.TextColor3 = Color3.fromRGB(220, 235, 250)
    Button.TextSize = 14
    Button.Font = Enum.Font.GothamBold
    Button.BorderSizePixel = 0
    Button.Parent = Content

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Button

    Button.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
end

-- ============================================================
-- GAME LOGIC
-- ============================================================

local function getCharacter()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
        return char, char.HumanoidRootPart, char.Humanoid
    end
    return nil
end

local function findNearestEgg()
    local char, hrp = getCharacter()
    if not char or not hrp then return nil end

    local closest, closestDist = nil, math.huge
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("egg") or obj.Name:lower():find("brainrot")) then
            local dist = (obj.Position - hrp.Position).Magnitude
            if dist < closestDist then
                closest = obj
                closestDist = dist
            end
        end
    end
    return closest
end

local function teleportTo(pos)
    local char, hrp = getCharacter()
    if hrp then
        hrp.CFrame = CFrame.new(pos)
    end
end

local function attemptSteal()
    local egg = findNearestEgg()
    if egg then
        teleportTo(egg.Position + Vector3.new(0, 2, 0))
        task.wait(0.05)
        local prompt = egg:FindFirstChildOfClass("ProximityPrompt")
        if prompt then
            prompt:InputHoldBegin()
            task.wait(prompt.HoldDuration or 0.1)
            prompt:InputHoldEnd()
        else
            local cd = egg:FindFirstChildOfClass("ClickDetector")
            if cd then
                fireclickdetector(cd)
            end
        end
    end
end

local function collectHatchable()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and obj.Parent and obj.Parent.Name:lower():find("hatch") then
            obj:InputHoldBegin()
            task.wait(0.05)
            obj:InputHoldEnd()
            break
        end
    end
end

-- ============================================================
-- MAIN LOOP
-- ============================================================

local stealLoop = false
local hatchLoop = false

RunService.Heartbeat:Connect(function()
    if stealLoop then
        local ok, err = pcall(attemptSteal)
        if not ok then warn("[NhaHub] steal error:", err) end
        task.wait(CONFIG.STEAL_INTERVAL)
    end
    if hatchLoop then
        pcall(collectHatchable)
        task.wait(0.5)
    end
end)

-- ============================================================
-- BUILD UI CONTROLS
-- ============================================================

createToggle("Auto Steal", false, function(state)
    stealLoop = state
end)

createToggle("Auto Hatch", false, function(state)
    hatchLoop = state
end)

createToggle("Egg ESP", false, function(state)
    CONFIG.ESP_ENABLED = state
    if state then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name:lower():find("egg") then
                local hl = obj:FindFirstChild("NhaHub_esp")
                if not hl then
                    hl = Instance.new("Highlight")
                    hl.Name = "NhaHub_esp"
                    hl.FillColor = Color3.fromRGB(0, 255, 120)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.FillTransparency = 0.5
                    hl.Parent = obj
                end
            end
        end
    else
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Highlight") and obj.Name == "NhaHub_esp" then
                obj:Destroy()
            end
        end
    end
end)

createSlider("WalkSpeed", 16, 200, 16, function(val)
    CONFIG.WALK_SPEED = val
    local char, _, hum = getCharacter()
    if hum then hum.WalkSpeed = val end
end)

createButton("Teleport to Nearest Egg", function()
    local egg = findNearestEgg()
    if egg then
        teleportTo(egg.Position + Vector3.new(0, 2, 0))
    end
end)

createButton("Steal Once", function()
    attemptSteal()
end)

-- ============================================================
-- TOGGLE UI VISIBILITY
-- ============================================================

local uiVisible = true

local function setUIVisible(visible)
    uiVisible = visible
    MainFrame.Visible = visible
    ToggleButton.Visible = not visible
end

CloseButton.MouseButton1Click:Connect(function()
    setUIVisible(false)
end)

ToggleButton.MouseButton1Click:Connect(function()
    setUIVisible(true)
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == CONFIG.TOGGLE_KEY then
        setUIVisible(not uiVisible)
    end
end)

-- ============================================================
-- DRAG SUPPORT
-- ============================================================

local dragging = false
local dragStart, startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

TitleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ============================================================
-- RESPAWN HANDLING
-- ============================================================

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    local _, _, hum = getCharacter()
    if hum then hum.WalkSpeed = CONFIG.WALK_SPEED end
end)

-- ============================================================
-- INIT COMPLETE
-- ============================================================

print("[NhaHub] steal an egg loaded. made by @odil9 on discord")