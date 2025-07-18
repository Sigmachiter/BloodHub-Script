-- BloodHub AC Test v1.3
-- Автор: @ws3eqr
-- Функции: Fly, Noclip, Speed Control

local function LoadBloodHub()
    -- Удаление старых версий
    if game:GetService("CoreGui"):FindFirstChild("BloodHub") then
        game:GetService("CoreGui").BloodHub:Destroy()
    end

    -- Основные сервисы
    local Player = game:GetService("Players").LocalPlayer
    local UIS = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")

    -- Настройки
    local flyActive = false
    local noclipActive = false
    local flySpeed = 50
    local flyVertical = 0

    -- Создание интерфейса
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BloodHub"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.Enabled = true

    -- Главный фрейм (стильный дизайн)
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0.18, 0, 0.3, 0)
    MainFrame.Position = UDim2.new(0.8, 0, 0.35, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BorderSizePixel = 0

    -- Закругленные углы
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame

    -- Кнопка закрытия (красный крестик)
    local CloseButton = Instance.new("TextButton")
    CloseButton.Text = "×"
    CloseButton.TextSize = 18
    CloseButton.Size = UDim2.new(0, 25, 0, 25)
    CloseButton.Position = UDim2.new(1, -30, 0, -10)
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseButton.TextColor3 = Color3.new(1, 1, 1)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.ZIndex = 2
    CloseButton.Parent = MainFrame

    -- Стиль крестика (круглый)
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(1, 0)
    CloseCorner.Parent = CloseButton

    -- Анимация кнопки
    CloseButton.MouseEnter:Connect(function()
        CloseButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
    end)
    CloseButton.MouseLeave:Connect(function()
        CloseButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    end)

    -- Функция закрытия
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- Заголовок
    local Title = Instance.new("TextLabel")
    Title.Text = "BLOODHUB TEST"
    Title.Size = UDim2.new(1, 0, 0.1, 0)
    Title.Position = UDim2.new(0, 0, 0.02, 0)
    Title.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 14
    Title.Parent = MainFrame

    -- Версия
    local Version = Instance.new("TextLabel")
    Version.Text = "v1.3 | @ws3eqr"
    Version.Size = UDim2.new(1, 0, 0.08, 0)
    Version.Position = UDim2.new(0, 0, 0.1, 0)
    Version.BackgroundTransparency = 1
    Version.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    Version.Font = Enum.Font.Gotham
    Version.TextSize = 11
    Version.Parent = MainFrame

    -- Вкладки
    local TabsFrame = Instance.new("Frame")
    TabsFrame.Size = UDim2.new(1, 0, 0.08, 0)
    TabsFrame.Position = UDim2.new(0, 0, 0.18, 0)
    TabsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TabsFrame.Parent = MainFrame

    -- ... (полный код вкладок и функций Fly/Noclip) ...

    MainFrame.Parent = ScreenGui

    -- Основные функции
    local function Fly()
        if not flyActive or not Player.Character then return end
        
        local Humanoid = Player.Character:FindFirstChild("Humanoid")
        local RootPart = Player.Character:FindFirstChild("HumanoidRootPart")
        if not Humanoid or not RootPart then return end
        
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        
        local cam = workspace.CurrentCamera.CFrame.LookVector
        local moveDir = Vector3.new()
        
        -- Управление WASD
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir += Vector3.new(cam.X, 0, cam.Z) end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir -= Vector3.new(cam.X, 0, cam.Z) end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir += Vector3.new(-cam.Z, 0, cam.X) end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir += Vector3.new(cam.Z, 0, -cam.X) end
        
        -- Вертикальное управление
        if UIS:IsKeyDown(Enum.KeyCode.Space) then
            flyVertical = math.min(flyVertical + 0.2, 1)
        elseif UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
            flyVertical = math.max(flyVertical - 0.2, -1)
        else
            flyVertical = flyVertical * 0.8
        end
        
        -- Применение скорости
        if moveDir.Magnitude > 0 then moveDir = moveDir.Unit * flySpeed end
        RootPart.Velocity = moveDir + Vector3.new(0, flyVertical * flySpeed, 0)
    end

    local function Noclip()
        if not Player.Character then return end
        for _, part in ipairs(Player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not noclipActive
            end
        end
    end

    -- Основной цикл
    RunService.Heartbeat:Connect(function()
        if flyActive then Fly() end
        if noclipActive then Noclip() end
    end)
end

-- Защищенный запуск
local success, err = pcall(LoadBloodHub)
if not success then
    warn("BloodHub Error:", err)
end