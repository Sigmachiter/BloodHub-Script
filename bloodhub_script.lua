local function LoadBloodHub()
    -- Удаляем старые версии
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
    local lastCharacter

    -- Создаем интерфейс
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BloodHub"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.Enabled = true

    -- Главный фрейм
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
    Version.Text = "v1.2 | @ws3eqr"
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
    
    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(0, 8)
    UICorner2.Parent = UpdatesContainer
    UpdatesContainer.Parent = MainFrame

    local MiscContainer = Instance.new("ScrollingFrame")
    MiscContainer.Size = UDim2.new(0.95, 0, 0.75, 0)
    MiscContainer.Position = UDim2.new(0.025, 0, 0.23, 0)
    MiscContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    MiscContainer.ScrollBarThickness = 5
    MiscContainer.Visible = false
    
    local UICorner3 = Instance.new("UICorner")
    UICorner3.CornerRadius = UDim.new(0, 8)
    UICorner3.Parent = MiscContainer
    MiscContainer.Parent = MainFrame

    -- Функция создания кнопок
    local function CreateButton(parent, text)
        local button = Instance.new("TextButton")
        button.Text = text
        button.Size = UDim2.new(0.9, 0, 0, 30)
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
        "Fixed noclip toggle",
        "Improved fly controls",
        "New UI design",
        "Added speed control"
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
    local FlyBtn = CreateButton(MiscContainer, "FLY [OFF]")
    local NoclipBtn = CreateButton(MiscContainer, "NOCLIP [OFF]")

    -- Настройки скорости
    local SpeedFrame = Instance.new("Frame")
    SpeedFrame.Size = UDim2.new(0.9, 0, 0, 70)
    SpeedFrame.Position = UDim2.new(0.05, 0, 0.15, 0)
    SpeedFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    SpeedFrame.Visible = false
    
    local UICorner4 = Instance.new("UICorner")
    UICorner4.CornerRadius = UDim.new(0, 6)
    UICorner4.Parent = SpeedFrame
    SpeedFrame.Parent = MiscContainer

    local SpeedLabel = Instance.new("TextLabel")
    SpeedLabel.Text = "SPEED: " .. flySpeed
    SpeedLabel.Size = UDim2.new(1, 0, 0.3, 0)
    SpeedLabel.BackgroundTransparency = 1
    SpeedLabel.TextColor3 = Color3.new(1, 1, 1)
    SpeedLabel.Font = Enum.Font.GothamBold
    SpeedLabel.TextSize = 12
    SpeedLabel.Parent = SpeedFrame

    -- Функция Noclip (исправленная)
    local function UpdateNoclip()
        if not Player.Character then return end
        
        for _, part in ipairs(Player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not noclipActive
            end
        end
    end

    -- Функция Fly (исправленная)
    local function UpdateFly()
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
            flyVertical = math.min(flyVertical + 0.15, 1)
        elseif UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
            flyVertical = math.max(flyVertical - 0.15, -1)
        else
            flyVertical = flyVertical * 0.85
        end
        
        if moveDir.Magnitude > 0 then moveDir = moveDir.Unit * flySpeed end
        RootPart.Velocity = moveDir + Vector3.new(0, flyVertical * flySpeed, 0)
    end

    -- Обработчики кнопок
    FlyBtn.MouseButton1Click:Connect(function()
        flyActive = not flyActive
        FlyBtn.Text = flyActive and "FLY [ON]" or "FLY [OFF]"
        SpeedFrame.Visible = flyActive
        
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.PlatformStand = flyActive
        end
    end)

    NoclipBtn.MouseButton1Click:Connect(function()
        noclipActive = not noclipActive
        NoclipBtn.Text = noclipActive and "NOCLIP [ON]" or "NOCLIP [OFF]"
        UpdateNoclip() -- Мгновенное применение
    end)

    -- Автоматическое обновление при смене персонажа
    Player.CharacterAdded:Connect(function()
        if flyActive and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.PlatformStand = true
        end
        UpdateNoclip()
    end)

    -- Основной цикл
    RunService.Heartbeat:Connect(function()
        UpdateFly()
        UpdateNoclip()
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

    -- Закрытие/открытие меню
    UIS.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.RightControl then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)

    -- Инициализация
    UpdatesTab.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
end

-- Загрузка с защитой
local success, err = pcall(LoadBloodHub)
if not success then
    warn("BloodHub Error:", err)
end
