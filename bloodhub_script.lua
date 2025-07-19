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
    local speedActive = false
    local spinActive = false
    local flySpeed = 50  -- Начальная скорость (макс 100)
    local spinSpeed = 1  -- Скорость вращения

    -- Создание интерфейса
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BloodHub"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.Enabled = false -- Начинаем с закрытого меню

    -- Главный контейнер
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0.18, 0, 0.3, 0)
    MainFrame.Position = UDim2.new(0.82, 0, 0.35, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 0
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame
    MainFrame.Parent = ScreenGui

    -- Заголовок
    local TitleFrame = Instance.new("Frame")
    TitleFrame.Size = UDim2.new(1, 0, 0.12, 0)
    TitleFrame.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Parent = TitleFrame
    TitleFrame.Parent = MainFrame

    local Title = Instance.new("TextLabel")
    Title.Text = "BLOODHUB"
    Title.Size = UDim2.new(1, 0, 0.7, 0)
    Title.Position = UDim2.new(0, 0, 0.15, 0)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 14
    Title.Parent = TitleFrame

    local Version = Instance.new("TextLabel")
    Version.Text = "v1.0 | @ws3eqr"
    Version.Size = UDim2.new(1, 0, 0.3, 0)
    Version.Position = UDim2.new(0, 0, 0.7, 0)
    Version.BackgroundTransparency = 1
    Version.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    Version.Font = Enum.Font.Gotham
    Version.TextSize = 10
    Version.Parent = TitleFrame

    -- Вкладки
    local TabsFrame = Instance.new("Frame")
    TabsFrame.Size = UDim2.new(1, 0, 0.1, 0)
    TabsFrame.Position = UDim2.new(0, 0, 0.12, 0)
    TabsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TabsFrame.BorderSizePixel = 0
    TabsFrame.Parent = MainFrame

    local function CreateTab(text, pos)
        local tab = Instance.new("TextButton")
        tab.Text = text
        tab.Size = UDim2.new(0.5, 0, 1, 0)
        tab.Position = pos
        tab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        tab.TextColor3 = Color3.new(1, 1, 1)
        tab.Font = Enum.Font.GothamBold
        tab.TextSize = 12
        tab.AutoButtonColor = false
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = tab
        
        tab.Parent = TabsFrame
        return tab
    end

    local UpdatesTab = CreateTab("UPDATES", UDim2.new(0, 0, 0, 0))
    local MiscTab = CreateTab("MISC", UDim2.new(0.5, 0, 0, 0))

    -- Контейнеры
    local UpdatesContainer = Instance.new("ScrollingFrame")
    UpdatesContainer.Size = UDim2.new(0.95, 0, 0.75, 0)
    UpdatesContainer.Position = UDim2.new(0.025, 0, 0.23, 0)
    UpdatesContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    UpdatesContainer.ScrollBarThickness = 5
    UpdatesContainer.Visible = true
    UpdatesContainer.Parent = MainFrame

    local MiscContainer = Instance.new("ScrollingFrame")
    MiscContainer.Size = UDim2.new(0.95, 0, 0.75, 0)
    MiscContainer.Position = UDim2.new(0.025, 0, 0.23, 0)
    MiscContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    MiscContainer.ScrollBarThickness = 5
    MiscContainer.Visible = false
    MiscContainer.Parent = MainFrame

    -- Раздел UPDATES
    local PatchNotes = {
        "Fly system added",
        "Noclip physics fixed",
        "Speed control slider",
        "Spin rotation control",
        "Anti-cheat test module"
    }

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 8)
    Layout.Parent = UpdatesContainer

    for i, note in ipairs(PatchNotes) do
        local noteFrame = Instance.new("Frame")
        noteFrame.Size = UDim2.new(0.9, 0, 0, 22)
        noteFrame.Position = UDim2.new(0.05, 0, 0, (i-1)*30)
        noteFrame.BackgroundTransparency = 1
        noteFrame.Parent = UpdatesContainer
        
        local bullet = Instance.new("TextLabel")
        bullet.Text = "•"
        bullet.Size = UDim2.new(0.1, 0, 1, 0)
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
    local function CreateButton(parent, text, yPos)
        local button = Instance.new("TextButton")
        button.Text = text
        button.Size = UDim2.new(0.9, 0, 0, 30)
        button.Position = UDim2.new(0.05, 0, yPos, 0)
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

    -- Кнопки функций
    local FlyBtn = CreateButton(MiscContainer, "Fly [ ]", 0.05)
    local NoclipBtn = CreateButton(MiscContainer, "Noclip [ ]", 0.15)
    local SpeedBtn = CreateButton(MiscContainer, "Speed Control [ ]", 0.25)
    local SpinBtn = CreateButton(MiscContainer, "Spin Control [ ]", 0.35)

    -- Фрейм настроек скорости
    local SpeedFrame = Instance.new("Frame")
    SpeedFrame.Size = UDim2.new(0.9, 0, 0, 100)
    SpeedFrame.Position = UDim2.new(0.05, 0, 0.45, 0)
    SpeedFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    SpeedFrame.Visible = false
    SpeedFrame.Parent = MiscContainer

    local SpeedLabel = Instance.new("TextLabel")
    SpeedLabel.Text = "Speed: " .. flySpeed
    SpeedLabel.Size = UDim2.new(1, 0, 0.3, 0)
    SpeedLabel.BackgroundTransparency = 1
    SpeedLabel.TextColor3 = Color3.new(1, 1, 1)
    SpeedLabel.Font = Enum.Font.GothamBold
    SpeedLabel.TextSize = 12
    SpeedLabel.Parent = SpeedFrame

    local SpeedUp = CreateButton(SpeedFrame, "▲ Increase", 0.3)
    local SpeedDown = CreateButton(SpeedFrame, "▼ Decrease", 0.6)

    -- Фрейм настроек вращения
    local SpinFrame = Instance.new("Frame")
    SpinFrame.Size = UDim2.new(0.9, 0, 0, 100)
    SpinFrame.Position = UDim2.new(0.05, 0, 0.6, 0)
    SpinFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    SpinFrame.Visible = false
    SpinFrame.Parent = MiscContainer

    local SpinLabel = Instance.new("TextLabel")
    SpinLabel.Text = "Spin: " .. spinSpeed
    SpinLabel.Size = UDim2.new(1, 0, 0.3, 0)
    SpinLabel.BackgroundTransparency = 1
    SpinLabel.TextColor3 = Color3.new(1, 1, 1)
    SpinLabel.Font = Enum.Font.GothamBold
    SpinLabel.TextSize = 12
    SpinLabel.Parent = SpinFrame

    local SpinUp = CreateButton(SpinFrame, "▲ Faster", 0.3)
    local SpinDown = CreateButton(SpinFrame, "▼ Slower", 0.6)

    -- Функция Fly
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
            moveDir += Vector3.new(0, 1, 0)
        elseif UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDir += Vector3.new(0, -1, 0)
        end
        
        -- Применение скорости (макс 100)
        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit * math.min(flySpeed, 100)
        end
        RootPart.Velocity = moveDir
    end

    -- Функция вращения
    local function Spin()
        if not spinActive or not Player.Character then return end
        
        local RootPart = Player.Character:FindFirstChild("HumanoidRootPart")
        if not RootPart then return end
        
        RootPart.CFrame = RootPart.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
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

    -- Обработчики кнопок
    FlyBtn.MouseButton1Click:Connect(function()
        flyActive = not flyActive
        FlyBtn.Text = flyActive and "Fly [✓]" or "Fly [ ]"
    end)

    NoclipBtn.MouseButton1Click:Connect(function()
        noclipActive = not noclipActive
        NoclipBtn.Text = noclipActive and "Noclip [✓]" or "Noclip [ ]"
    end)

    SpeedBtn.MouseButton1Click:Connect(function()
        speedActive = not speedActive
        SpeedBtn.Text = speedActive and "Speed Control [✓]" or "Speed Control [ ]"
        SpeedFrame.Visible = speedActive
    end)

    SpinBtn.MouseButton1Click:Connect(function()
        spinActive = not spinActive
        SpinBtn.Text = spinActive and "Spin Control [✓]" or "Spin Control [ ]"
        SpinFrame.Visible = spinActive
    end)

    -- Управление скоростью
    SpeedUp.MouseButton1Click:Connect(function()
        flySpeed = math.min(flySpeed + 5, 100)
        SpeedLabel.Text = "Speed: " .. flySpeed
    end)

    SpeedDown.MouseButton1Click:Connect(function()
        flySpeed = math.max(flySpeed - 5, 10)
        SpeedLabel.Text = "Speed: " .. flySpeed
    end)

    -- Управление вращением
    SpinUp.MouseButton1Click:Connect(function()
        spinSpeed = math.min(spinSpeed + 0.5, 10)
        SpinLabel.Text = "Spin: " .. spinSpeed
    end)

    SpinDown.MouseButton1Click:Connect(function()
        spinSpeed = math.max(spinSpeed - 0.5, 0.5)
        SpinLabel.Text = "Spin: " .. spinSpeed
    end)

    -- Основной цикл
    RunService.Heartbeat:Connect(function()
        if flyActive then Fly() end
        if spinActive then Spin() end
        Noclip()
    end)

    -- Переключение вкладок
    UpdatesTab.MouseButton1Click:Connect(function()
        UpdatesContainer.Visible = true
        MiscContainer.Visible = false
        UpdatesTab.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
        MiscTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end)

    MiscTab.MouseButton1Click:Connect(function()
        UpdatesContainer.Visible = false
        MiscContainer.Visible = true
        MiscTab.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
        UpdatesTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end)

    -- Управление меню (правый Ctrl)
    UIS.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.RightControl then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)

    -- Инициализация
    UpdatesTab.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
end

-- Запуск с обработкой ошибок
local success, err = pcall(LoadBloodHub)
if not success then
    warn("BloodHub Error:", err)
end