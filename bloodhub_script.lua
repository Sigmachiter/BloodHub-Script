-- BloodHub AC Test v1.4
-- Автор: @ws3eqr
-- Функции: Fly, Noclip, Speed Control, Close Button

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

    -- Главный фрейм
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0.18, 0, 0.32, 0)
    MainFrame.Position = UDim2.new(0.8, 0, 0.35, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    -- Закругленные углы
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame

    -- Кнопка закрытия (крестик)
    local CloseButton = Instance.new("TextButton")
    CloseButton.Text = "×"
    CloseButton.TextSize = 20
    CloseButton.Size = UDim2.new(0, 28, 0, 28)
    CloseButton.Position = UDim2.new(1, -30, 0, -12)
    CloseButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
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
    Title.Text = "BLOODHUB"
    Title.Size = UDim2.new(1, 0, 0.1, 0)
    Title.Position = UDim2.new(0, 0, 0.02, 0)
    Title.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 14
    Title.Parent = MainFrame

    -- Версия и автор
    local Version = Instance.new("TextLabel")
    Version.Text = "v1.4 | @ws3eqr"
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
    TabsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TabsFrame.Parent = MainFrame

    local UpdatesTab = Instance.new("TextButton")
    UpdatesTab.Text = "UPDATES"
    UpdatesTab.Size = UDim2.new(0.5, 0, 1, 0)
    UpdatesTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    UpdatesTab.TextColor3 = Color3.new(1, 1, 1)
    UpdatesTab.Font = Enum.Font.GothamBold
    UpdatesTab.TextSize = 12
    UpdatesTab.Parent = TabsFrame

    local MiscTab = Instance.new("TextButton")
    MiscTab.Text = "MISC"
    MiscTab.Size = UDim2.new(0.5, 0, 1, 0)
    MiscTab.Position = UDim2.new(0.5, 0, 0, 0)
    MiscTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    MiscTab.TextColor3 = Color3.new(1, 1, 1)
    MiscTab.Font = Enum.Font.GothamBold
    MiscTab.TextSize = 12
    MiscTab.Parent = TabsFrame

    -- Контейнеры
    local UpdatesContainer = Instance.new("ScrollingFrame")
    UpdatesContainer.Size = UDim2.new(1, 0, 0.7, 0)
    UpdatesContainer.Position = UDim2.new(0, 0, 0.26, 0)
    UpdatesContainer.BackgroundTransparency = 1
    UpdatesContainer.ScrollBarThickness = 3
    UpdatesContainer.Visible = true
    UpdatesContainer.Parent = MainFrame

    local MiscContainer = Instance.new("ScrollingFrame")
    MiscContainer.Size = UDim2.new(1, 0, 0.7, 0)
    MiscContainer.Position = UDim2.new(0, 0, 0.26, 0)
    MiscContainer.BackgroundTransparency = 1
    MiscContainer.ScrollBarThickness = 3
    MiscContainer.Visible = false
    MiscContainer.Parent = MainFrame

    -- Функция создания кнопок
    local function CreateButton(parent, text)
        local button = Instance.new("TextButton")
        button.Text = text
        button.Size = UDim2.new(0.9, 0, 0, 32)
        button.Position = UDim2.new(0.05, 0, 0, 0)
        button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        button.TextColor3 = Color3.new(1, 1, 1)
        button.Font = Enum.Font.Gotham
        button.TextSize = 12
        button.AutoButtonColor = false
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = button
        
        button.MouseEnter:Connect(function()
            button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end)
        
        button.MouseLeave:Connect(function()
            button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        end)
        
        button.Parent = parent
        return button
    end

    -- Раздел UPDATES
    local PatchNotes = {
        "Fixed fly movement",
        "Improved noclip",
        "Added close button",
        "Optimized performance"
    }

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 8)
    Layout.Parent = UpdatesContainer

    for i, note in ipairs(PatchNotes) do
        local noteFrame = Instance.new("Frame")
        noteFrame.Size = UDim2.new(0.9, 0, 0, 24)
        noteFrame.Position = UDim2.new(0.05, 0, 0, (i-1)*32)
        noteFrame.BackgroundTransparency = 1
        noteFrame.Parent = UpdatesContainer
        
        local bullet = Instance.new("TextLabel")
        bullet.Text = "•"
        bullet.Size = UDim2.new(0.1, 0, 1, 0)
        bullet.Position = UDim2.new(0, 0, 0, 0)
        bullet.BackgroundTransparency = 1
        bullet.TextColor3 = Color3.fromRGB(200, 40, 40)
        bullet.Font = Enum.Font.GothamBold
        bullet.TextSize = 14
        bullet.Parent = noteFrame
        
        local text = Instance.new("TextLabel")
        text.Text = note
        text.Size = UDim2.new(0.9, 0, 1, 0)
        text.Position = UDim2.new(0.1, 0, 0, 0)
        text.BackgroundTransparency = 1
        text.TextColor3 = Color3.new(0.9, 0.9, 0.9)
        text.Font = Enum.Font.Gotham
        text.TextSize = 12
        text.TextXAlignment = Enum.TextXAlignment.Left
        text.Parent = noteFrame
    end

    -- Раздел MISC
    local FlyBtn = CreateButton(MiscContainer, "FLY [OFF]")
    local NoclipBtn = CreateButton(MiscContainer, "NOCLIP [OFF]")

    -- Настройки скорости
    local SpeedFrame = Instance.new("Frame")
    SpeedFrame.Size = UDim2.new(0.9, 0, 0, 80)
    SpeedFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
    SpeedFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    SpeedFrame.BorderSizePixel = 0
    SpeedFrame.Visible = false
    SpeedFrame.Parent = MiscContainer

    local UICornerSpeed = Instance.new("UICorner")
    UICornerSpeed.CornerRadius = UDim.new(0, 6)
    UICornerSpeed.Parent = SpeedFrame

    local SpeedLabel = Instance.new("TextLabel")
    SpeedLabel.Text = "SPEED: " .. flySpeed
    SpeedLabel.Size = UDim2.new(1, 0, 0.3, 0)
    SpeedLabel.Position = UDim2.new(0, 0, 0.1, 0)
    SpeedLabel.BackgroundTransparency = 1
    SpeedLabel.TextColor3 = Color3.new(1, 1, 1)
    SpeedLabel.Font = Enum.Font.GothamBold
    SpeedLabel.TextSize = 12
    SpeedLabel.Parent = SpeedFrame

    -- Функции управления
    local function Fly()
        if not flyActive or not Player.Character then return end
        
        local Humanoid = Player.Character:FindFirstChild("Humanoid")
        local RootPart = Player.Character:FindFirstChild("HumanoidRootPart")
        if not Humanoid or not RootPart then return end
        
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        
        local cam = workspace.CurrentCamera.CFrame.LookVector
        local moveDir = Vector3.new()
        
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir += Vector3.new(cam.X, 0, cam.Z) end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir -= Vector3.new(cam.X, 0, cam.Z) end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir += Vector3.new(-cam.Z, 0, cam.X) end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir += Vector3.new(cam.Z, 0, -cam.X) end
        
        if UIS:IsKeyDown(Enum.KeyCode.Space) then
            flyVertical = math.min(flyVertical + 0.2, 1)
        elseif UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
            flyVertical = math.max(flyVertical - 0.2, -1)
        else
            flyVertical = flyVertical * 0.8
        end
        
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

    -- Обработчики кнопок
    FlyBtn.MouseButton1Click:Connect(function()
        flyActive = not flyActive
        FlyBtn.Text = flyActive and "FLY [ON]" or "FLY [OFF]"
        SpeedFrame.Visible = flyActive
    end)

    NoclipBtn.MouseButton1Click:Connect(function()
        noclipActive = not noclipActive
        NoclipBtn.Text = noclipActive and "NOCLIP [ON]" or "NOCLIP [OFF]"
    end)

    -- Настройки скорости
    local SpeedUp = CreateButton(SpeedFrame, "▲ INCREASE")
    SpeedUp.Position = UDim2.new(0, 0, 0.4, 0)
    SpeedUp.MouseButton1Click:Connect(function()
        flySpeed = math.clamp(flySpeed + 5, 10, 150)
        SpeedLabel.Text = "SPEED: " .. flySpeed
    end)

    local SpeedDown = CreateButton(SpeedFrame, "▼ DECREASE")
    SpeedDown.Position = UDim2.new(0, 0, 0.7, 0)
    SpeedDown.MouseButton1Click:Connect(function()
        flySpeed = math.clamp(flySpeed - 5, 10, 150)
        SpeedLabel.Text = "SPEED: " .. flySpeed
    end)

    -- Переключение вкладок
    UpdatesTab.MouseButton1Click:Connect(function()
        UpdatesContainer.Visible = true
        MiscContainer.Visible = false
        UpdatesTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        MiscTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end)

    MiscTab.MouseButton1Click:Connect(function()
        UpdatesContainer.Visible = false
        MiscContainer.Visible = true
        MiscTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        UpdatesTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end)

    -- Основной цикл
    RunService.Heartbeat:Connect(function()
        if flyActive then Fly() end
        if noclipActive then Noclip() end
    end)

    -- Активация интерфейса
    ScreenGui.Enabled = true
end

-- Защищенный запуск
local success, err = pcall(LoadBloodHub)
if not success then
    warn("BloodHub Error:", err)
end