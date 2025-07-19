-- Universal BloodHub Loader for KRNL, Delta, Android
local function LoadBloodHub()
    -- Удаление предыдущей версии
    if game:GetService("CoreGui"):FindFirstChild("BloodHub") then
        game:GetService("CoreGui").BloodHub:Destroy()
    end

    -- Основные сервисы
    local Player = game:GetService("Players").LocalPlayer
    local UIS = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")

    -- Состояния
    local flyActive = false
    local noclipActive = false
    local flySpeed = 50
    local flyVertical = 0

    -- Создание интерфейса
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BloodHub"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.Enabled = false

    -- Главный контейнер
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0.3, 0, 0.4, 0)
    MainFrame.Position = UDim2.new(0.35, 0, 0.3, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 0
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame
    MainFrame.Parent = ScreenGui

    -- Заголовок
    local TitleFrame = Instance.new("Frame")
    TitleFrame.Size = UDim2.new(1, 0, 0.1, 0)
    TitleFrame.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 12)
    TitleCorner.Parent = TitleFrame
    TitleFrame.Parent = MainFrame

    local Title = Instance.new("TextLabel")
    Title.Text = "BLOODHUB"
    Title.Size = UDim2.new(1, 0, 0.7, 0)
    Title.Position = UDim2.new(0, 0, 0.15, 0)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.Parent = TitleFrame

    -- Кнопки функций
    local function CreateButton(text, yPos, callback)
        local button = Instance.new("TextButton")
        button.Text = text
        button.Size = UDim2.new(0.9, 0, 0.15, 0)
        button.Position = UDim2.new(0.05, 0, yPos, 0)
        button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        button.TextColor3 = Color3.new(1, 1, 1)
        button.Font = Enum.Font.Gotham
        button.TextSize = 14
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = button
        
        button.MouseButton1Click:Connect(callback)
        button.Parent = MainFrame
        return button
    end

    -- Создание кнопок
    local FlyBtn = CreateButton("Fly [OFF]", 0.15, function()
        flyActive = not flyActive
        FlyBtn.Text = flyActive and "Fly [ON]" or "Fly [OFF]"
    end)
    
    local NoclipBtn = CreateButton("Noclip [OFF]", 0.32, function()
        noclipActive = not noclipActive
        NoclipBtn.Text = noclipActive and "Noclip [ON]" or "Noclip [OFF]"
    end)
    
    local CloseBtn = CreateButton("Close Menu", 0.8, function()
        ScreenGui.Enabled = false
    end)

    -- Функция Fly
    local function Fly()
        if not flyActive or not Player.Character then return end
        
        local Humanoid = Player.Character:FindFirstChild("Humanoid")
        local RootPart = Player.Character:FindFirstChild("HumanoidRootPart")
        if not Humanoid or not RootPart then return end
        
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        
        local moveDir = Vector3.new()
        
        -- Упрощенное управление для мобильных устройств
        if UIS:IsKeyDown(Enum.KeyCode.W) or UIS:IsKeyDown(Enum.KeyCode.Up) then
            moveDir = Vector3.new(0, 0, -1)
        end
        
        if UIS:IsKeyDown(Enum.KeyCode.Space) then
            moveDir = Vector3.new(0, 1, 0)
        end
        
        -- Применение скорости
        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit * flySpeed
        end
        RootPart.Velocity = moveDir
    end

    -- Функция Noclip
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
        Noclip()
    end)

    -- Иконка для мобильных устройств
    if not UIS.KeyboardEnabled then
        local MobileIcon = Instance.new("ImageButton")
        MobileIcon.Image = "rbxassetid://7072725342"  -- Иконка шестеренки
        MobileIcon.Size = UDim2.new(0.1, 0, 0.15, 0)
        MobileIcon.Position = UDim2.new(0.85, 0, 0.05, 0)
        MobileIcon.BackgroundTransparency = 1
        MobileIcon.Parent = game:GetService("CoreGui")
        
        MobileIcon.MouseButton1Click:Connect(function()
            ScreenGui.Enabled = not ScreenGui.Enabled
        end)
    else
        -- Управление для ПК
        UIS.InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.RightControl then
                ScreenGui.Enabled = not ScreenGui.Enabled
            end
        end)
    end
end

-- Автозапуск для всех платформ
LoadBloodHub()