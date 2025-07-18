local Player = game:GetService("Players").LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Меню
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BloodHub"
ScreenGui.Parent = CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0.2, 0, 0.45, 0)
Frame.Position = UDim2.new(0.8, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
Frame.BorderSizePixel = 2
Frame.Parent = ScreenGui

-- Заголовок и вкладки (код из предыдущего примера)
-- ... (оставьте ваш существующий код создания интерфейса)

-- Переменные для управления
local flyActive = false
local noclipActive = false
local flySpeed = 50
local flyVertical = 0

-- Функция полета
local function FlyController()
    if not flyActive or not Player.Character then return end
    
    local Humanoid = Player.Character:FindFirstChild("Humanoid")
    local RootPart = Player.Character:FindFirstChild("HumanoidRootPart")
    if not Humanoid or not RootPart then return end
    
    -- Сбрасываем стандартную гравитацию
    Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    
    -- Управление
    local cam = workspace.CurrentCamera.CFrame.LookVector
    local moveDir = Vector3.new()
    
    if UIS:IsKeyDown(Enum.KeyCode.W) then
        moveDir = moveDir + Vector3.new(cam.X, 0, cam.Z)
    end
    if UIS:IsKeyDown(Enum.KeyCode.S) then
        moveDir = moveDir - Vector3.new(cam.X, 0, cam.Z)
    end
    if UIS:IsKeyDown(Enum.KeyCode.D) then
        moveDir = moveDir + Vector3.new(-cam.Z, 0, cam.X)
    end
    if UIS:IsKeyDown(Enum.KeyCode.A) then
        moveDir = moveDir + Vector3.new(cam.Z, 0, -cam.X)
    end
    
    -- Вертикальное управление
    if UIS:IsKeyDown(Enum.KeyCode.Space) then
        flyVertical = math.min(flyVertical + 0.5, 1)
    elseif UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
        flyVertical = math.max(flyVertical - 0.5, -1)
    else
        flyVertical = flyVertical * 0.9 -- Плавное замедление
    end
    
    -- Нормализация и применение скорости
    if moveDir.Magnitude > 0 then
        moveDir = moveDir.Unit * flySpeed
    end
    moveDir = moveDir + Vector3.new(0, flyVertical * flySpeed, 0)
    
    RootPart.Velocity = moveDir
end

-- Функция Noclip
local function Noclip()
    if not Player.Character then return end
    
    for _, part in ipairs(Player.Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = noclipActive and false or true
        end
    end
end

-- Обновление
RunService.Heartbeat:Connect(function()
    if flyActive then FlyController() end
    if noclipActive then Noclip() end
end)

-- Кнопка Fly в меню
local FlyButton = CreateButton(MiscContainer, "Fly [OFF]", function()
    flyActive = not flyActive
    FlyButton.Text = flyActive and "Fly [ON]" or "Fly [OFF]"
    SettingsFrame.Visible = flyActive
end)

-- Кнопка Noclip в меню
local NoclipButton = CreateButton(MiscContainer, "Noclip [OFF]", function()
    noclipActive = not noclipActive
    NoclipButton.Text = noclipActive and "Noclip [ON]" or "Noclip [OFF]"
end)

-- Настройки скорости (добавьте этот фрейм в ваш интерфейс)
local SettingsFrame = Instance.new("Frame")
-- ... (ваш существующий код создания SettingsFrame)

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Text = "Speed: " .. flySpeed
-- ... (остальной код интерфейса)

SpeedSlider.MouseButton1Click:Connect(function()
    flySpeed = math.clamp(flySpeed + 5, 10, 100)
    SpeedLabel.Text = "Speed: " .. flySpeed
end)

SpeedSlider.MouseButton2Click:Connect(function()
    flySpeed = math.clamp(flySpeed - 5, 10, 100)
    SpeedLabel.Text = "Speed: " .. flySpeed
end)