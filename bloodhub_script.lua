-- BloodHub Ultra v2.0 by @ws3eqr
local function LoadBloodHub()
    if _G.BloodHubLoaded then return end
    _G.BloodHubLoaded = true

    -- Удаление старой версии
    if game:GetService("CoreGui"):FindFirstChild("BloodHub") then
        game:GetService("CoreGui").BloodHub:Destroy()
    end

    -- Сервисы
    local Player = game:GetService("Players").LocalPlayer
    local UIS = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")
    local SoundService = game:GetService("SoundService")

    -- Состояния
    local flyActive = false
    local noclipActive = false
    local flySpeed = 50
    local walkSpeed = 16
    local menuOpen = false
    local flyVertical = 0

    -- Создание интерфейса
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BloodHub"
    ScreenGui.Parent = game:GetService("CoreGui")

    -- Главный фрейм с градиентом
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0.25, 0, 0.4, 0)
    MainFrame.Position = UDim2.new(0.75, 0, 0.3, 0)
    MainFrame.BackgroundTransparency = 0.1
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    
    -- Чёрно-красный градиент
    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 0, 0))
    }
    Gradient.Rotation = 90
    Gradient.Parent = MainFrame

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame

    -- Тень
    local Shadow = Instance.new("ImageLabel")
    Shadow.Image = "rbxassetid://1316045217"
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    Shadow.Size = UDim2.new(1, 10, 1, 10)
    Shadow.Position = UDim2.new(0, -5, 0, -5)
    Shadow.BackgroundTransparency = 1
    Shadow.ImageColor3 = Color3.fromRGB(255, 40, 40)
    Shadow.ImageTransparency = 0.7
    Shadow.Parent = MainFrame

    MainFrame.Parent = ScreenGui

    -- Заголовок
    local Title = Instance.new("TextLabel")
    Title.Text = "BLOODHUB ULTRA"
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 18
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Size = UDim2.new(1, 0, 0.1, 0)
    Title.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    Title.Parent = MainFrame

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 6)
    TitleCorner.Parent = Title

    -- Версия
    local Version = Instance.new("TextLabel")
    Version.Text = "v2.0 | @ws3eqr"
    Version.Font = Enum.Font.Gotham
    Version.TextSize = 12
    Version.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    Version.Size = UDim2.new(1, 0, 0.05, 0)
    Version.Position = UDim2.new(0, 0, 0.1, 0)
    Version.BackgroundTransparency = 1
    Version.Parent = MainFrame

    -- Вкладки
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
        tab.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        tab.TextColor3 = Color3.new(1, 1, 1)
        tab.Font = Enum.Font.GothamBold
        tab.TextSize = 12
        tab.AutoButtonColor = false
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = tab
        
        tab.MouseEnter:Connect(function()
            TweenService:Create(tab, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 0, 0)}):Play()
        end)
        
        tab.MouseLeave:Connect(function()
            if tab.Text ~= "MAIN" then
                TweenService:Create(tab, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
            end
        end)
        
        tab.Parent = TabsFrame
        return tab
    end

    local MainTab = CreateTab("MAIN", UDim2.new(0, 0, 0, 0), 0.33)
    local PlayerTab = CreateTab("PLAYER", UDim2.new(0.33, 0, 0, 0), 0.33)
    local DupeTab = CreateTab("DUPE", UDim2.new(0.66, 0, 0, 0), 0.34)

    -- Контейнеры
    local function CreateContainer()
        local container = Instance.new("ScrollingFrame")
        container.Size = UDim2.new(0.95, 0, 0.7, 0)
        container.Position = UDim2.new(0.025, 0, 0.23, 0)
        container.BackgroundTransparency = 1
        container.ScrollBarThickness = 4
        container.ScrollBarImageColor3 = Color3.fromRGB(180, 0, 0)
        container.Parent = MainFrame
        return container
    end

    local MainContainer = CreateContainer()
    local PlayerContainer = CreateContainer()
    local DupeContainer = CreateContainer()

    -- Кнопки
    local function CreateButton(parent, text, yPos)
        local button = Instance.new("TextButton")
        button.Text = text
        button.Size = UDim2.new(0.9, 0, 0, 35)
        button.Position = UDim2.new(0.05, 0, yPos, 0)
        button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        button.TextColor3 = Color3.new(1, 1, 1)
        button.Font = Enum.Font.Gotham
        button.TextSize = 12
        button.AutoButtonColor = false
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = button
        
        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 0, 0)}):Play()
        end)
        
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
        end)
        
        button.Parent = parent
        return button
    end

    -- MAIN TAB
    local FlyBtn = CreateButton(MainContainer, "FLY [OFF]", 0.05)
    local NoclipBtn = CreateButton(MainContainer, "NOCLIP [OFF]", 0.12)
    local SpeedBtn = CreateButton(MainContainer, "SPEED: "..flySpeed, 0.19)

    -- PLAYER TAB
    local WalkSpeedBtn = CreateButton(PlayerContainer, "WALKSPEED: "..walkSpeed, 0.05)

    -- DUPE TAB
    local DupeBtn = CreateButton(DupeContainer, "DUPE ITEMS", 0.05)
    DupeBtn.Size = UDim2.new(0.9, 0, 0, 40)
    DupeBtn.Font = Enum.Font.GothamBold
    DupeBtn.TextSize = 14

    -- Fly функция
    local function Fly()
        if not flyActive or not Player.Character then return end
        
        local Humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
        local RootPart = Player.Character:FindFirstChild("HumanoidRootPart")
        if not Humanoid or not RootPart then return end
        
        local cam = workspace.CurrentCamera.CFrame
        local moveVec = Vector3.new()
        
        -- WASD движение
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveVec += cam.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveVec -= cam.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveVec += cam.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveVec -= cam.RightVector end
        
        -- Вертикальное движение
        if UIS:IsKeyDown(Enum.KeyCode.Space) then
            flyVertical = math.min(flyVertical + 0.5, flySpeed/2)
        elseif UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
            flyVertical = math.max(flyVertical - 0.5, -flySpeed/2)
        else
            flyVertical = flyVertical * 0.9
        end
        
        -- Применение скорости
        if moveVec.Magnitude > 0 then
            moveVec = (moveVec.Unit * flySpeed) + Vector3.new(0, flyVertical, 0)
            RootPart.Velocity = moveVec
        else
            RootPart.Velocity = Vector3.new(0, flyVertical, 0)
        end
    end

    -- Noclip функция
    local function Noclip()
        if not Player.Character then return end
        for _, part in ipairs(Player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not noclipActive
            end
        end
    end

    -- Dupe функция
    local function DupeItems()
        if not Player.Character then return end
        
        -- Клонирование инструментов
        for _, tool in ipairs(Player.Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local clone = tool:Clone()
                clone.Parent = Player.Character
            end
        end
        
        -- Визуальный эффект
        local effect = Instance.new("Part")
        effect.Size = Vector3.new(1, 1, 1)
        effect.Position = Player.Character.HumanoidRootPart.Position
        effect.Anchored = true
        effect.CanCollide = false
        effect.Material = Enum.Material.Neon
        effect.Color = Color3.fromRGB(0, 255, 0)
        effect.Transparency = 0.5
        effect.Parent = workspace
        
        TweenService:Create(effect, TweenInfo.new(0.5), {Size = Vector3.new(5, 5, 5), Transparency = 1}):Play()
        game:GetService("Debris"):AddItem(effect, 1)
        
        -- Звук
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://142127347"
        sound.Parent = workspace
        sound:Play()
        game:GetService("Debris"):AddItem(sound, 2)
    end

    -- Обработчики кнопок
    FlyBtn.MouseButton1Click:Connect(function()
        flyActive = not flyActive
        FlyBtn.Text = flyActive and "FLY [ON]" or "FLY [OFF]"
    end)

    NoclipBtn.MouseButton1Click:Connect(function()
        noclipActive = not noclipActive
        NoclipBtn.Text = noclipActive and "NOCLIP [ON]" or "NOCLIP [OFF]"
    end)

    SpeedBtn.MouseButton1Click:Connect(function()
        flySpeed = flySpeed + 10
        if flySpeed > 100 then flySpeed = 10 end
        SpeedBtn.Text = "SPEED: "..flySpeed
    end)

    WalkSpeedBtn.MouseButton1Click:Connect(function()
        walkSpeed = walkSpeed + 5
        if walkSpeed > 50 then walkSpeed = 16 end
        WalkSpeedBtn.Text = "WALKSPEED: "..walkSpeed
        if Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
            Player.Character.Humanoid.WalkSpeed = walkSpeed
        end
    end)

    DupeBtn.MouseButton1Click:Connect(function()
        DupeItems()
    end)

    -- Переключение вкладок
    local function SwitchTab(tab)
        MainContainer.Visible = (tab == MainTab)
        PlayerContainer.Visible = (tab == PlayerTab)
        DupeContainer.Visible = (tab == DupeTab)
        
        for _, t in ipairs({MainTab, PlayerTab, DupeTab}) do
            TweenService:Create(t, TweenInfo.new(0.2), {
                BackgroundColor3 = (t == tab) and Color3.fromRGB(180, 0, 0) or Color3.fromRGB(30, 30, 30)
            }):Play()
        end
    end

    MainTab.MouseButton1Click:Connect(function() SwitchTab(MainTab) end)
    PlayerTab.MouseButton1Click:Connect(function() SwitchTab(PlayerTab) end)
    DupeTab.MouseButton1Click:Connect(function() SwitchTab(DupeTab) end)

    -- Основной цикл
    RunService.Heartbeat:Connect(function()
        if flyActive then Fly() end
        if noclipActive then Noclip() end
    end)

    -- Управление меню
    UIS.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.RightControl then
            menuOpen = not menuOpen
            ScreenGui.Enabled = menuOpen
            
            TweenService:Create(MainFrame, TweenInfo.new(0.3), {
                Position = menuOpen and UDim2.new(0.5, 0, 0.5, 0) or UDim2.new(1.2, 0, 0.5, 0)
            }):Play()
        end
    end)

    -- Инициализация
    SwitchTab(MainTab)
    MainFrame.Position = UDim2.new(1.2, 0, 0.5, 0)
    ScreenGui.Enabled = false
end

LoadBloodHub()
