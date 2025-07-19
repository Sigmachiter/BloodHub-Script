--[[
  BloodHub Cheat | Roblox
  Автор: @ws3eqr
  Версия: 1.0 (Официальная)
--]]

-- Сервисы (корректные имена)
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

-- Основной GUI
local BloodHub = Instance.new("ScreenGui")
BloodHub.Name = "BloodHub"
BloodHub.Parent = localPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 400, 0, 450)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -225)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
MainFrame.BackgroundTransparency = 0.3  -- Исправлено: 30% прозрачности
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true

-- Градиент (Черно-красный) - исправлено создание
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.new(0.8, 0, 0))
}
Gradient.Rotation = 90
Gradient.Parent = MainFrame

-- Заголовок (исправлено позиционирование)
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Text = "BloodHub v1.0 | @ws3eqr"
Title.Size = UDim2.new(1, -20, 0, 40)  -- Исправлены отступы
Title.Position = UDim2.new(0, 10, 0, 5)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainFrame

-- Вкладки (исправлен цикл создания)
local Tabs = {"Misc", "Update", "Visual", "ESP", "Functions"}
local TabButtons = {}

for i, tabName in ipairs(Tabs) do
    local TabButton = Instance.new("TextButton")
    TabButton.Name = tabName
    TabButton.Text = tabName
    TabButton.Size = UDim2.new(0.18, 0, 0, 30)  -- Корректный размер
    TabButton.Position = UDim2.new(0.18 * (i-1), 5, 0, 45)
    TabButton.BackgroundTransparency = 0.5
    TabButton.BackgroundColor3 = Color3.new(0.3, 0, 0)
    TabButton.TextColor3 = Color3.new(1, 1, 1)
    TabButton.Font = Enum.Font.Gotham
    TabButton.TextSize = 14
    TabButton.Parent = MainFrame
    
    TabButtons[tabName] = TabButton  -- Правильное добавление в таблицу
end

-- Функция полета (исправленная и оптимизированная)
local flying = false
local flySpeed = 50

local function ToggleFly()
    if not localPlayer.Character then return end
    
    local humanoidRootPart = localPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    flying = not flying
    
    if flying then
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
        bodyVelocity.P = 1000
        bodyVelocity.Parent = humanoidRootPart
        
        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(0, 0, 0)
        bodyGyro.P = 1000
        bodyGyro.Parent = humanoidRootPart
        
        RunService.Heartbeat:Connect(function()
            if not flying or not humanoidRootPart then 
                bodyVelocity:Destroy()
                bodyGyro:Destroy()
                return 
            end
            
            local camera = workspace.CurrentCamera
            bodyGyro.CFrame = camera.CFrame
            
            local moveVector = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector += camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector -= camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector += camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector -= camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVector += Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveVector -= Vector3.new(0, 1, 0) end
            
            bodyVelocity.Velocity = moveVector * flySpeed
        end)
    end
end

-- Кнопка активации полета
local FlyButton = Instance.new("TextButton")
FlyButton.Text = "Включить полет"
FlyButton.Size = UDim2.new(0.8, 0, 0, 40)
FlyButton.Position = UDim2.new(0.1, 0, 0.2, 0)
FlyButton.Parent = TabButtons["Functions"]

FlyButton.MouseButton1Click:Connect(ToggleFly)

-- Регулятор скорости полета (исправленный)
local SpeedSlider = Instance.new("TextBox")
SpeedSlider.Text = tostring(flySpeed)
SpeedSlider.Size = UDim2.new(0.6, 0, 0, 25)
SpeedSlider.Position = UDim2.new(0.2, 0, 0.3, 0)
SpeedSlider.Parent = TabButtons["Functions"]

SpeedSlider.FocusLost:Connect(function()
    local newSpeed = tonumber(SpeedSlider.Text)
    if newSpeed and newSpeed > 0 and newSpeed <= 500 then
        flySpeed = newSpeed
    else
        SpeedSlider.Text = tostring(flySpeed)
    end
end)

-- Ноуклип (исправленная реализация)
local noclip = false
local noclipConnection

local function ToggleNoclip()
    noclip = not noclip
    
    if noclip then
        noclipConnection = RunService.Stepped:Connect(function()
            if localPlayer.Character then
                for _, child in ipairs(localPlayer.Character:GetDescendants()) do
                    if child:IsA("BasePart") then
                        child.CanCollide = false
                    end
                end
            end
        end)
    elseif noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
end

-- Кнопка ноуклипа
local NoclipButton = Instance.new("TextButton")
NoclipButton.Text = "Включить NoClip"
NoclipButton.Size = UDim2.new(0.8, 0, 0, 40)
NoclipButton.Position = UDim2.new(0.1, 0, 0.4, 0)
NoclipButton.Parent = TabButtons["Functions"]

NoclipButton.MouseButton1Click:Connect(ToggleNoclip)

-- Переключение вкладок (исправленная логика)
for name, button in pairs(TabButtons) do
    button.MouseButton1Click:Connect(function()
        for tabName, tabButton in pairs(TabButtons) do
            tabButton.BackgroundColor3 = (tabName == name) 
                and Color3.new(0, 0.5, 0) 
                or Color3.new(0.3, 0, 0)
        end
    end)
end

-- Движение GUI (исправленная реализация)
local dragging = false
local dragStart, frameStart

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        frameStart = MainFrame.Position
    end
end)

MainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            frameStart.X.Scale, 
            frameStart.X.Offset + delta.X,
            frameStart.Y.Scale,
            frameStart.Y.Offset + delta.Y
        )
    end
end)

-- Бинд на открытие/закрытие
local isOpen = true
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        isOpen = not isOpen
        BloodHub.Enabled = isOpen
    end
end)

-- Первоначальная настройка
BloodHub.Enabled = true
MainFrame.Parent = BloodHub
