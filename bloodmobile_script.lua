-- BloodHub Mobile Fixed Version
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
    MainFrame.Size = UDim2.new(0.8, 0, 0.7, 0)  -- Больше для мобильных
    MainFrame.Position = UDim2.new(0.1, 0, 0.15, 0)
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
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20
    Title.Parent = TitleFrame

    -- Вкладки
    local TabsFrame = Instance.new("Frame")
    TabsFrame.Size = UDim2.new(1, 0, 0.08, 0)
    TabsFrame.Position = UDim2.new(0, 0, 0.1, 0)
    TabsFrame.BackgroundTransparency = 1
    TabsFrame.Parent = MainFrame

    local function CreateTab(text, pos)
        local tab = Instance.new("TextButton")
        tab.Text = text
        tab.Size = UDim2.new(0.3, 0, 1, 0)
        tab.Position = pos
        tab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        tab.TextColor3 = Color3.new(1, 1, 1)
        tab.Font = Enum.Font.Gotham
        tab.TextSize = 14
        tab.Parent = TabsFrame
        return tab
    end

    local UpdatesTab = CreateTab("UPDATES", UDim2.new(0, 0, 0, 0))
    local MiscTab = CreateTab("MISC", UDim2.new(0.35, 0, 0, 0))
    local DupeTab = CreateTab("DUPE", UDim2.new(0.7, 0, 0, 0))

    -- Контейнеры
    local UpdatesContainer = Instance.new("ScrollingFrame")
    UpdatesContainer.Size = UDim2.new(0.95, 0, 0.8, 0)
    UpdatesContainer.Position = UDim2.new(0.025, 0, 0.2, 0)
    UpdatesContainer.BackgroundTransparency = 1
    UpdatesContainer.ScrollBarThickness = 6
    UpdatesContainer.Visible = true
    UpdatesContainer.Parent = MainFrame

    local MiscContainer = Instance.new("ScrollingFrame")
    MiscContainer.Size = UDim2.new(0.95, 0, 0.8, 0)
    MiscContainer.Position = UDim2.new(0.025, 0, 0.2, 0)
    MiscContainer.BackgroundTransparency = 1
    MiscContainer.ScrollBarThickness = 6
    MiscContainer.Visible = false
    MiscContainer.Parent = MainFrame

    local DupeContainer = Instance.new("ScrollingFrame")
    DupeContainer.Size = UDim2.new(0.95, 0, 0.8, 0)
    DupeContainer.Position = UDim2.new(0.025, 0, 0.2, 0)
    DupeContainer.BackgroundTransparency = 1
    DupeContainer.ScrollBarThickness = 6
    DupeContainer.Visible = false
    DupeContainer.Parent = MainFrame

    -- Раздел UPDATES
    local PatchNotes = {
        "Fixed UI issues",
        "Added MISC functions",
        "Improved mobile support",
        "Dupe items feature added",
        "Optimized performance"
    }

    for i, note in ipairs(PatchNotes) do
        local noteFrame = Instance.new("TextLabel")
        noteFrame.Text = "• " .. note
        noteFrame.Size = UDim2.new(1, 0, 0, 30)
        noteFrame.Position = UDim2.new(0, 0, 0, (i-1)*35)
        noteFrame.BackgroundTransparency = 1
        noteFrame.TextColor3 = Color3.new(0.9, 0.9, 0.9)
        noteFrame.Font = Enum.Font.Gotham
        noteFrame.TextSize = 14
        noteFrame.TextXAlignment = Enum.TextXAlignment.Left
        noteFrame.Parent = UpdatesContainer
    end

    -- Раздел MISC
    local function CreateButton(text, yPos)
        local button = Instance.new("TextButton")
        button.Text = text
        button.Size = UDim2.new(0.95, 0, 0, 50)  -- Крупнее для мобильных
        button.Position = UDim2.new(0.025, 0, yPos, 0)
        button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        button.TextColor3 = Color3.new(1, 1, 1)
        button.Font = Enum.Font.Gotham
        button.TextSize = 16
        button.Parent = MiscContainer
        return button
    end

    local FlyBtn = CreateButton("Fly [OFF]", 0.05)
    local NoclipBtn = CreateButton("Noclip [OFF]", 0.15)
    local SpeedBtn = CreateButton("Speed: " .. flySpeed, 0.25)

    -- Раздел DUPE
    local DupeBtn = Instance.new("TextButton")
    DupeBtn.Text = "DUP ITEMS"
    DupeBtn.Size = UDim2.new(0.9, 0, 0, 80)
    DupeBtn.Position = UDim2.new(0.05, 0, 0.3, 0)
    DupeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    DupeBtn.TextColor3 = Color3.new(1, 1, 1)
    DupeBtn.Font = Enum.Font.GothamBold
    DupeBtn.TextSize = 20
    DupeBtn.Parent = DupeContainer
    
    local DupeCorner = Instance.new("UICorner")
    DupeCorner.CornerRadius = UDim.new(0, 12)
    DupeCorner.Parent = DupeBtn

    -- Функция Fly
    local function Fly()
        if not flyActive or not Player.Character then return end
        
        local Humanoid = Player.Character:FindFirstChild("Humanoid")
        local RootPart = Player.Character:FindFirstChild("HumanoidRootPart")
        if not Humanoid or not RootPart then return end
        
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        
        local cam = workspace.CurrentCamera.CFrame.LookVector
        local moveDir = Vector3.new()
        
        -- Управление
        if UIS:IsKeyDown(Enum.KeyCode.W) or UIS:IsKeyDown(Enum.KeyCode.Up) then
            moveDir = moveDir + Vector3.new(cam.X, 0, cam.Z)
        end
        
        -- Вертикальное управление
        if UIS:IsKeyDown(Enum.KeyCode.Space) then
            moveDir = moveDir + Vector3.new(0, 1, 0)
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

    -- Обработчики кнопок
    FlyBtn.MouseButton1Click:Connect(function()
        flyActive = not flyActive
        FlyBtn.Text = flyActive and "Fly [ON]" or "Fly [OFF]"
    end)

    NoclipBtn.MouseButton1Click:Connect(function()
        noclipActive = not noclipActive
        NoclipBtn.Text = noclipActive and "Noclip [ON]" or "Noclip [OFF]"
    end)

    SpeedBtn.MouseButton1Click:Connect(function()
        flySpeed = flySpeed + 10
        if flySpeed > 100 then flySpeed = 10 end
        SpeedBtn.Text = "Speed: " .. flySpeed
    end)

    DupeBtn.MouseButton1Click:Connect(function()
        -- Эффект дублирования
        local effect = Instance.new("Part")
        effect.Size = Vector3.new(1, 1, 1)
        effect.Position = Player.Character.HumanoidRootPart.Position
        effect.Anchored = true
        effect.CanCollide = false
        effect.Transparency = 0.7
        effect.Color = Color3.fromRGB(0, 255, 0)
        effect.Parent = workspace
        
        game:GetService("Debris"):AddItem(effect, 1)
    end)

    -- Переключение вкладок
    UpdatesTab.MouseButton1Click:Connect(function()
        UpdatesContainer.Visible = true
        MiscContainer.Visible = false
        DupeContainer.Visible = false
    end)

    MiscTab.MouseButton1Click:Connect(function()
        UpdatesContainer.Visible = false
        MiscContainer.Visible = true
        DupeContainer.Visible = false
    end)

    DupeTab.MouseButton1Click:Connect(function()
        UpdatesContainer.Visible = false
        MiscContainer.Visible = false
        DupeContainer.Visible = true
    end)

    -- Основной цикл
    RunService.Heartbeat:Connect(function()
        if flyActive then Fly() end
        Noclip()
    end)

    -- Иконка для мобильных устройств
    if not UIS.KeyboardEnabled then
        local MobileIcon = Instance.new("TextButton")
        MobileIcon.Text = "≡"
        MobileIcon.Size = UDim2.new(0.1, 0, 0.1, 0)
        MobileIcon.Position = UDim2.new(0.85, 0, 0.05, 0)
        MobileIcon.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
        MobileIcon.TextColor3 = Color3.new(1, 1, 1)
        MobileIcon.Font = Enum.Font.GothamBold
        MobileIcon.TextSize = 25
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

-- Запуск
LoadBloodHub()
end

-- Автозапуск для всех платформ
LoadBloodHub()
