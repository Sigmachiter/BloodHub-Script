local function LoadBloodHub()
    -- Защита от повторного запуска
    if _G.BloodHubLoaded then return end
    _G.BloodHubLoaded = true

    -- Удаление предыдущей версии
    if game:GetService("CoreGui"):FindFirstChild("BloodHub") then
        game:GetService("CoreGui").BloodHub:Destroy()
    end

    -- Сервисы
    local Player = game:GetService("Players").LocalPlayer
    local UIS = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")

    -- Состояния
    local flyActive = false
    local noclipActive = false
    local flySpeed = 50
    local menuOpen = false

    -- Создание интерфейса
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BloodHub"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.Enabled = false

    -- Главный контейнер (с анимацией)
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0.2, 0, 0.35, 0)
    MainFrame.Position = UDim2.new(0.8, 0, 0.3, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.ClipsDescendants = true
    
    -- Тень
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Image = "rbxassetid://1316045217"
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    Shadow.Size = UDim2.new(1, 10, 1, 10)
    Shadow.Position = UDim2.new(0, -5, 0, -5)
    Shadow.BackgroundTransparency = 1
    Shadow.ImageTransparency = 0.5
    Shadow.Parent = MainFrame

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame
    MainFrame.Parent = ScreenGui

    -- Заголовок (стильный)
    local Title = Instance.new("TextLabel")
    Title.Text = "BLOODHUB"
    Title.Size = UDim2.new(1, 0, 0.1, 0)
    Title.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 16
    Title.Parent = MainFrame

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Parent = Title

    local Version = Instance.new("TextLabel")
    Version.Text = "v1.1 | @ws3eqr"
    Version.Size = UDim2.new(1, 0, 0.05, 0)
    Version.Position = UDim2.new(0, 0, 0.1, 0)
    Version.BackgroundTransparency = 1
    Version.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    Version.Font = Enum.Font.Gotham
    Version.TextSize = 10
    Version.Parent = MainFrame

    -- Вкладки (с анимацией наведения)
    local TabsFrame = Instance.new("Frame")
    TabsFrame.Size = UDim2.new(1, 0, 0.08, 0)
    TabsFrame.Position = UDim2.new(0, 0, 0.15, 0)
    TabsFrame.BackgroundTransparency = 1
    TabsFrame.Parent = MainFrame

    local function CreateTab(text, pos, width)
        local tab = Instance.new("TextButton")
        tab.Text = text
        tab.Size = UDim2.new(width, 0, 1, 0)
        tab.Position = pos
        tab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        tab.TextColor3 = Color3.new(1, 1, 1)
        tab.Font = Enum.Font.GothamBold
        tab.TextSize = 12
        tab.AutoButtonColor = false
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = tab
        
        -- Анимация наведения
        tab.MouseEnter:Connect(function()
            TweenService:Create(tab, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 70)}):Play()
        end)
        
        tab.MouseLeave:Connect(function()
            if tab.Text ~= "UPDATES" then
                TweenService:Create(tab, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
            end
        end)
        
        tab.Parent = TabsFrame
        return tab
    end

    local UpdatesTab = CreateTab("UPDATES", UDim2.new(0, 0, 0, 0), 0.33)
    local MiscTab = CreateTab("MISC", UDim2.new(0.33, 0, 0, 0), 0.33)
    local DupeTab = CreateTab("DUPE", UDim2.new(0.66, 0, 0, 0), 0.34)

    -- Контейнеры (скролл)
    local function CreateContainer()
        local container = Instance.new("ScrollingFrame")
        container.Size = UDim2.new(0.95, 0, 0.7, 0)
        container.Position = UDim2.new(0.025, 0, 0.23, 0)
        container.BackgroundTransparency = 1
        container.ScrollBarThickness = 5
        container.ScrollBarImageColor3 = Color3.fromRGB(200, 40, 40)
        container.Parent = MainFrame
        return container
    end

    local UpdatesContainer = CreateContainer()
    UpdatesContainer.Visible = true

    local MiscContainer = CreateContainer()
    MiscContainer.Visible = false

    local DupeContainer = CreateContainer()
    DupeContainer.Visible = false

    -- Раздел UPDATES (список изменений)
    local PatchNotes = {
        "Fly system improved",
        "Noclip now more stealthy",
        "Speed control (10-100)",
        "Dupe items (visual effect)",
        "Anti-cheat bypass tweaks"
    }

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 8)
    Layout.Parent = UpdatesContainer

    for i, note in ipairs(PatchNotes) do
        local noteFrame = Instance.new("TextLabel")
        noteFrame.Text = "• " .. note
        noteFrame.Size = UDim2.new(1, 0, 0, 20)
        noteFrame.BackgroundTransparency = 1
        noteFrame.TextColor3 = Color3.new(0.9, 0.9, 0.9)
        noteFrame.Font = Enum.Font.Gotham
        noteFrame.TextSize = 12
        noteFrame.TextXAlignment = Enum.TextXAlignment.Left
        noteFrame.Parent = UpdatesContainer
    end

    -- Раздел MISC (Fly, Noclip, Speed)
    local function CreateButton(parent, text, yPos)
        local button = Instance.new("TextButton")
        button.Text = text
        button.Size = UDim2.new(0.9, 0, 0, 35)
        button.Position = UDim2.new(0.05, 0, yPos, 0)
        button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        button.TextColor3 = Color3.new(1, 1, 1)
        button.Font = Enum.Font.Gotham
        button.TextSize = 12
        button.AutoButtonColor = false
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = button
        
        -- Анимация наведения
        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
        end)
        
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
        end)
        
        button.Parent = parent
        return button
    end

    local FlyBtn = CreateButton(MiscContainer, "Fly [ ]", 0.05)
    local NoclipBtn = CreateButton(MiscContainer, "Noclip [ ]", 0.15)
    local SpeedBtn = CreateButton(MiscContainer, "Speed: " .. flySpeed, 0.25)

    -- Раздел DUPE (визуальный эффект)
    local DupeBtn = Instance.new("TextButton")
    DupeBtn.Text = "DUP ITEMS"
    DupeBtn.Size = UDim2.new(0.9, 0, 0, 45)
    DupeBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
    DupeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    DupeBtn.TextColor3 = Color3.new(1, 1, 1)
    DupeBtn.Font = Enum.Font.GothamBold
    DupeBtn.TextSize = 14
    DupeBtn.Parent = DupeContainer
    
    local DupeCorner = Instance.new("UICorner")
    DupeCorner.CornerRadius = UDim.new(0, 10)
    DupeCorner.Parent = DupeBtn

    -- Анимация нажатия
    DupeBtn.MouseButton1Down:Connect(function()
        TweenService:Create(DupeBtn, TweenInfo.new(0.1), {Size = UDim2.new(0.88, 0, 0, 43)}):Play()
    end)
    
    DupeBtn.MouseButton1Up:Connect(function()
        TweenService:Create(DupeBtn, TweenInfo.new(0.1), {Size = UDim2.new(0.9, 0, 0, 45)}):Play()
    end)

    -- Fly (оптимизированная версия)
    local function Fly()
        if not flyActive or not Player.Character then return end
        
        local Humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
        local RootPart = Player.Character:FindFirstChild("HumanoidRootPart")
        if not Humanoid or not RootPart then return end
        
        -- Плавное движение (менее заметно для античита)
        local cam = workspace.CurrentCamera.CFrame.LookVector
        local moveDir = Vector3.new()
        
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir += cam * 0.7 end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir -= cam * 0.7 end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir += Vector3.new(-cam.Z, 0, cam.X) * 0.7 end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir += Vector3.new(cam.Z, 0, -cam.X) * 0.7 end
        
        if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0, 0.7, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir += Vector3.new(0, -0.7, 0) end
        
        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit * (flySpeed / 20) -- Меньше резких изменений
            RootPart.Velocity = RootPart.Velocity:Lerp(moveDir, 0.3) -- Плавность
        end
    end

    -- Noclip (скрытый режим)
    local lastNoclipCheck = 0
    local function Noclip()
        if not noclipActive or not Player.Character then return end
        
        -- Проверка раз в 0.5 сек (меньше нагрузки)
        if tick() - lastNoclipCheck < 0.5 then return end
        lastNoclipCheck = tick()
        
        for _, part in ipairs(Player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
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
        flySpeed = flySpeed + 10
        if flySpeed > 100 then flySpeed = 10 end
        SpeedBtn.Text = "Speed: " .. flySpeed
    end)

    -- Dupe эффект (зелёный взрыв)
    DupeBtn.MouseButton1Click:Connect(function()
        if not Player.Character then return end
        
        local root = Player.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        local effect = Instance.new("Part")
        effect.Size = Vector3.new(1, 1, 1)
        effect.Position = root.Position
        effect.Anchored = true
        effect.CanCollide = false
        effect.Material = Enum.Material.Neon
        effect.Color = Color3.fromRGB(0, 255, 0)
        effect.Transparency = 0.5
        effect.Parent = workspace
        
        -- Анимация расширения
        TweenService:Create(effect, TweenInfo.new(0.5), {Size = Vector3.new(5, 5, 5), Transparency = 1}):Play()
        game:GetService("Debris"):AddItem(effect, 1)
    end)

    -- Переключение вкладок
    local function SwitchTab(selectedTab)
        UpdatesContainer.Visible = (selectedTab == UpdatesTab)
        MiscContainer.Visible = (selectedTab == MiscTab)
        DupeContainer.Visible = (selectedTab == DupeTab)
        
        -- Анимация смены вкладок
        for _, tab in ipairs({UpdatesTab, MiscTab, DupeTab}) do
            TweenService:Create(tab, TweenInfo.new(0.2), {
                BackgroundColor3 = (tab == selectedTab) 
                    and Color3.fromRGB(200, 40, 40) 
                    or Color3.fromRGB(50, 50, 50)
            }):Play()
        end
    end

    UpdatesTab.MouseButton1Click:Connect(function() SwitchTab(UpdatesTab) end)
    MiscTab.MouseButton1Click:Connect(function() SwitchTab(MiscTab) end)
    DupeTab.MouseButton1Click:Connect(function() SwitchTab(DupeTab) end)

    -- Основной цикл (оптимизированный)
    RunService.Heartbeat:Connect(function()
        if flyActive then Fly() end
        if noclipActive then Noclip() end
    end)

    -- Открытие/закрытие меню (правый Ctrl + плавная анимация)
    UIS.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.RightControl then
            menuOpen = not menuOpen
            ScreenGui.Enabled = menuOpen
            
            -- Анимация появления/исчезновения
            TweenService:Create(MainFrame, TweenInfo.new(0.3), {
                Position = menuOpen and UDim2.new(0.5, 0, 0.5, 0) or UDim2.new(1.2, 0, 0.5, 0)
            }):Play()
        end
    end)

    -- Инициализация
    SwitchTab(UpdatesTab)
    TweenService:Create(MainFrame, TweenInfo.new(0.5), {Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
end

-- Запуск
LoadBloodHub()
