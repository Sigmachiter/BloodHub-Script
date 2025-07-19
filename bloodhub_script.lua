--[[
  BloodHub Cheat | Roblox
  Автор: @ws3eqr
  Версия: 1.0 (Не изменять без разрешения!)
  Функции: ESP, Fly, Noclip, SpeedHack, GUI с настройками
--]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = game.Players.LocalPlayer

-- Основной GUI
local BloodHub = Instance.new("ScreenGui")
BloodHub.Name = "BloodHub"
BloodHub.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 400, 0, 450)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -225)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
MainFrame.BackgroundTransparency = 0.7
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true

-- Градиент (Черно-красный)
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.new(0.8, 0, 0))
})
Gradient.Rotation = 90
Gradient.Parent = MainFrame

-- Заголовок с автором
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Text = "BloodHub v1.0 | @ws3eqr"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainFrame

-- Вкладки
local Tabs = {"Misc", "Update", "Visual", "ESP", "Functions"}
local TabButtons = {}

for i, tabName in ipairs(Tabs) do
    local TabButton = Instance.new("TextButton")
    TabButton.Name = tabName
    TabButton.Text = tabName
    TabButton.Size = UDim2.new(0.2, 0, 0, 30)
    TabButton.Position = UDim2.new(0.2 * (i - 1), 0, 0, 40)
    TabButton.BackgroundTransparency = 0.5
    TabButton.BackgroundColor3 = Color3.new(0.3, 0, 0)
    TabButton.TextColor3 = Color3.new(1, 1, 1)
    TabButton.Font = Enum.Font.Gotham
    TabButton.TextSize = 14
    TabButton.Parent = MainFrame
    table.insert(TabButtons, TabButton)
end

-- Переменные для функций
local flying = false
local noclip = false
local flySpeed = 50
local playerSpeed = 16
local rotationSpeed = 1

-- Реальные функции полета и ноуклипа
local function Fly()
    flying = not flying
    
    if flying then
        local torso = localPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not torso then return end
        
        local bg = Instance.new("BodyGyro", torso)
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bg.P = 10000
        
        local bv = Instance.new("BodyVelocity", torso)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, 0, 0)
        
        while flying and torso and bg and bv do
            bg.CFrame = CFrame.new(torso.Position, torso.Position + workspace.CurrentCamera.CFrame.LookVector)
            bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * flySpeed
            
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                bv.Velocity = Vector3.new(bv.Velocity.X, flySpeed, bv.Velocity.Z)
            end
            
            RunService.Heartbeat:Wait()
        end
        
        if bg then bg:Destroy() end
        if bv then bv:Destroy() end
    end
end

local function Noclip()
    noclip = not noclip
    
    if localPlayer.Character then
        for _, part in ipairs(localPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = not noclip
            end
        end
    end
end

-- Вкладка "Functions"
local FunctionsTab = Instance.new("Frame")
FunctionsTab.Name = "FunctionsTab"
FunctionsTab.Size = UDim2.new(1, 0, 1, -70)
FunctionsTab.Position = UDim2.new(0, 0, 0, 70)
FunctionsTab.BackgroundTransparency = 1
FunctionsTab.Visible = false
FunctionsTab.Parent = MainFrame

-- Fly
local FlyToggle = Instance.new("TextButton")
FlyToggle.Text = "Fly: OFF"
FlyToggle.Size = UDim2.new(0.9, 0, 0, 30)
FlyToggle.Position = UDim2.new(0.05, 0, 0.05, 0)
FlyToggle.BackgroundColor3 = Color3.new(0.3, 0, 0)
FlyToggle.TextColor3 = Color3.new(1, 1, 1)
FlyToggle.Parent = FunctionsTab

local FlySpeedLabel = Instance.new("TextLabel")
FlySpeedLabel.Text = "Скорость полета: 50"
FlySpeedLabel.Size = UDim2.new(0.7, 0, 0, 20)
FlySpeedLabel.Position = UDim2.new(0.05, 0, 0.15, 0)
FlySpeedLabel.BackgroundTransparency = 1
FlySpeedLabel.TextColor3 = Color3.new(1, 1, 1)
FlySpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
FlySpeedLabel.Parent = FunctionsTab

local FlySpeedSlider = Instance.new("TextBox")
FlySpeedSlider.Text = "50"
FlySpeedSlider.Size = UDim2.new(0.2, 0, 0, 20)
FlySpeedSlider.Position = UDim2.new(0.75, 0, 0.15, 0)
FlySpeedSlider.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
FlySpeedSlider.TextColor3 = Color3.new(1, 1, 1)
FlySpeedSlider.Parent = FunctionsTab

-- Rotation Speed
local RotSpeedLabel = Instance.new("TextLabel")
RotSpeedLabel.Text = "Скорость вращения: 1"
RotSpeedLabel.Size = UDim2.new(0.7, 0, 0, 20)
RotSpeedLabel.Position = UDim2.new(0.05, 0, 0.22, 0)
RotSpeedLabel.BackgroundTransparency = 1
RotSpeedLabel.TextColor3 = Color3.new(1, 1, 1)
RotSpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
RotSpeedLabel.Parent = FunctionsTab

local RotSpeedSlider = Instance.new("TextBox")
RotSpeedSlider.Text = "1"
RotSpeedSlider.Size = UDim2.new(0.2, 0, 0, 20)
RotSpeedSlider.Position = UDim2.new(0.75, 0, 0.22, 0)
RotSpeedSlider.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
RotSpeedSlider.TextColor3 = Color3.new(1, 1, 1)
RotSpeedSlider.Parent = FunctionsTab

-- Noclip
local NoclipToggle = Instance.new("TextButton")
NoclipToggle.Text = "Noclip: OFF"
NoclipToggle.Size = UDim2.new(0.9, 0, 0, 30)
NoclipToggle.Position = UDim2.new(0.05, 0, 0.3, 0)
NoclipToggle.BackgroundColor3 = Color3.new(0.3, 0, 0)
NoclipToggle.TextColor3 = Color3.new(1, 1, 1)
NoclipToggle.Parent = FunctionsTab

-- Player Speed
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Text = "Скорость игрока: 16"
SpeedLabel.Size = UDim2.new(0.7, 0, 0, 20)
SpeedLabel.Position = UDim2.new(0.05, 0, 0.4, 0)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.TextColor3 = Color3.new(1, 1, 1)
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = FunctionsTab

local SpeedSlider = Instance.new("TextBox")
SpeedSlider.Text = "16"
SpeedSlider.Size = UDim2.new(0.2, 0, 0, 20)
SpeedSlider.Position = UDim2.new(0.75, 0, 0.4, 0)
SpeedSlider.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
SpeedSlider.TextColor3 = Color3.new(1, 1, 1)
SpeedSlider.Parent = FunctionsTab

-- Обработчики функций
FlyToggle.MouseButton1Click:Connect(function()
    Fly()
    FlyToggle.Text = flying and "Fly: ON" or "Fly: OFF"
    FlyToggle.BackgroundColor3 = flying and Color3.new(0, 0.5, 0) or Color3.new(0.3, 0, 0)
end)

NoclipToggle.MouseButton1Click:Connect(function()
    Noclip()
    NoclipToggle.Text = noclip and "Noclip: ON" or "Noclip: OFF"
    NoclipToggle.BackgroundColor3 = noclip and Color3.new(0, 0.5, 0) or Color3.new(0.3, 0, 0)
end)

FlySpeedSlider.FocusLost:Connect(function()
    local value = tonumber(FlySpeedSlider.Text)
    if value and value >= 1 and value <= 500 then
        flySpeed = value
        FlySpeedLabel.Text = "Скорость полета: " .. value
    else
        FlySpeedSlider.Text = "50"
        flySpeed = 50
    end
end)

RotSpeedSlider.FocusLost:Connect(function()
    local value = tonumber(RotSpeedSlider.Text)
    if value and value >= 0.1 and value <= 10 then
        rotationSpeed = value
        RotSpeedLabel.Text = "Скорость вращения: " .. value
    else
        RotSpeedSlider.Text = "1"
        rotationSpeed = 1
    end
end)

SpeedSlider.FocusLost:Connect(function()
    local value = tonumber(SpeedSlider.Text)
    if value and value >= 16 and value <= 200 then
        playerSpeed = value
        SpeedLabel.Text = "Скорость игрока: " .. value
        if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
            localPlayer.Character.Humanoid.WalkSpeed = playerSpeed
        end
    else
        SpeedSlider.Text = "16"
        playerSpeed = 16
    end
end)

-- Остальные вкладки (Visual, ESP, Update) остаются без изменений
-- ... (код из предыдущей версии для других вкладок)

-- Бинд на открытие/закрытие
local isOpen = true
UserInputService.InputBegan:Connect(function(input, processed)
    if input.KeyCode == Enum.KeyCode.RightShift then
        isOpen = not isOpen
        MainFrame.Visible = isOpen
    end
end)

-- Движение GUI
local dragging = false
local dragStartPos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStartPos = Vector2.new(input.Position.X, input.Position.Y)
        MainFrame.Draggable = true
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStartPos
        MainFrame.Position = UDim2.new(
            0, MainFrame.AbsolutePosition.X + delta.X,
            0, MainFrame.AbsolutePosition.Y + delta.Y
        )
        dragStartPos = Vector2.new(input.Position.X, input.Position.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
        MainFrame.Draggable = false
    end
end)

-- Активация вкладок
for _, button in pairs(TabButtons) do
    button.MouseButton1Click:Connect(function()
        FunctionsTab.Visible = (button.Name == "Functions")
        -- ... (активация других вкладок)
    end
end

MainFrame.Parent = BloodHub
