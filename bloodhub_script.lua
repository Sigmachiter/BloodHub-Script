local function LoadBloodHub()
    -- Очистка предыдущей версии
    if game:GetService("CoreGui"):FindFirstChild("BloodHub") then
        game:GetService("CoreGui").BloodHub:Destroy()
    end

    -- Основные переменные
    local Player = game:GetService("Players").LocalPlayer
    local UIS = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local flyActive = false
    local noclipActive = false
    local flySpeed = 50
    local flyVertical = 0

    -- Создание интерфейса с закругленными краями
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BloodHub"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.Enabled = true

    local function RoundedFrame(parent, size, position)
        local frame = Instance.new("Frame")
        frame.Size = size
        frame.Position = position
        frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        frame.BackgroundTransparency = 0.1
        frame.BorderSizePixel = 0
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = frame
        
        frame.Parent = parent
        return frame
    end

    -- Главный контейнер
    local MainFrame = RoundedFrame(ScreenGui, UDim2.new(0.16, 0, 0.25, 0), UDim2.new(0.82, 0, 0.35, 0))
    
    -- Заголовок
    local TitleFrame = RoundedFrame(MainFrame, UDim2.new(1, 0, 0.12, 0), UDim2.new(0, 0, 0, 0))
    TitleFrame.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
    
    local Title = Instance.new("TextLabel")
    Title.Text = "BLOODHUB"
    Title.Size = UDim2.new(1, 0, 0.8, 0)
    Title.Position = UDim2.new(0, 0, 0.1, 0)
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
    local TabsFrame = RoundedFrame(MainFrame, UDim2.new(1, 0, 0.1, 0), UDim2.new(0, 0, 0.12, 0))
    TabsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

    local function CreateTab(text, pos, parent)
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
        
        tab.Parent = parent
        return tab
    end

    local UpdatesTab = CreateTab("UPDATES", UDim2.new(0, 0, 0, 0), TabsFrame)
    local MiscTab = CreateTab("MISC", UDim2.new(0.5, 0, 0, 0), TabsFrame)

    -- Контейнеры
    local UpdatesContainer = RoundedFrame(MainFrame, UDim2.new(0.95, 0, 0.75, 0), UDim2.new(0.025, 0, 0.23, 0))
    UpdatesContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    UpdatesContainer.Visible = true

    local MiscContainer = RoundedFrame(MainFrame, UDim2.new(0.95, 0, 0.75, 0), UDim2.new(0.025, 0, 0.23, 0))
    MiscContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    MiscContainer.Visible = false

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
        
        -- Эффект при наведении
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
        "Fixed noclip physics",
        "Improved fly system",
        "Added new GUI design",
        "Optimized performance"
    }

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 5)
    Layout.Parent = UpdatesContainer

    for i, note in ipairs(PatchNotes) do
        local noteFrame = Instance.new("Frame")
        noteFrame.Size = UDim2.new(0.9, 0, 0, 25)
        noteFrame.Position = UDim2.new(0.05, 0, 0, (i-1)*30)
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
    local SpeedFrame = RoundedFrame(MiscContainer, UDim2.new(0.9, 0, 0, 70), UDim2.new(0.05, 0, 0.15, 0))
    SpeedFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    SpeedFrame.Visible = false

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

    -- Основной цикл
    RunService.Heartbeat:Connect(function()
        if flyActive then Fly() end
        if noclipActive then Noclip() end
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
end

-- Запуск с обработкой ошибок
local success, err = pcall(LoadBloodHub)
if not success then
    warn("BloodHub Error:", err)
end