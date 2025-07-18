local function LoadBloodHub()
    -- Обработка ошибок через pcall
    local success, err = pcall(function()
        local Player = game:GetService("Players").LocalPlayer
        local CoreGui = game:GetService("CoreGui")
        local UIS = game:GetService("UserInputService")
        local RunService = game:GetService("RunService")

        -- Удаляем старую версию меню
        if CoreGui:FindFirstChild("BloodHub") then
            CoreGui.BloodHub:Destroy()
        end

        -- Переменные
        local flyActive = false
        local noclipActive = false
        local flySpeed = 50
        local flyVertical = 0

        -- Создание интерфейса
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "BloodHub"
        ScreenGui.Parent = CoreGui

        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(0.25, 0, 0.4, 0)
        Frame.Position = UDim2.new(0.75, 0, 0.3, 0)
        Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        Frame.BorderColor3 = Color3.fromRGB(255, 40, 40)
        Frame.BorderSizePixel = 2
        Frame.Parent = ScreenGui

        -- Заголовок
        local Title = Instance.new("TextLabel")
        Title.Text = "BLOODHUB v2.0"
        Title.Size = UDim2.new(1, 0, 0.1, 0)
        Title.BackgroundColor3 = Color3.fromRGB(255, 40, 40)
        Title.TextColor3 = Color3.new(1, 1, 1)
        Title.Font = Enum.Font.GothamBlack
        Title.Parent = Frame

        -- Вкладки
        local TabsFrame = Instance.new("Frame")
        TabsFrame.Size = UDim2.new(1, 0, 0.08, 0)
        TabsFrame.Position = UDim2.new(0, 0, 0.1, 0)
        TabsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TabsFrame.Parent = Frame

        local UpdatesTab = Instance.new("TextButton")
        UpdatesTab.Text = "UPDATES"
        UpdatesTab.Size = UDim2.new(0.5, 0, 1, 0)
        UpdatesTab.BackgroundColor3 = Color3.fromRGB(255, 40, 40)
        UpdatesTab.TextColor3 = Color3.new(1, 1, 1)
        UpdatesTab.Font = Enum.Font.GothamBold
        UpdatesTab.Parent = TabsFrame

        local MiscTab = Instance.new("TextButton")
        MiscTab.Text = "MISC"
        MiscTab.Size = UDim2.new(0.5, 0, 1, 0)
        MiscTab.Position = UDim2.new(0.5, 0, 0, 0)
        MiscTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        MiscTab.TextColor3 = Color3.new(1, 1, 1)
        MiscTab.Font = Enum.Font.GothamBold
        MiscTab.Parent = TabsFrame

        -- Контейнеры
        local UpdatesContainer = Instance.new("ScrollingFrame")
        UpdatesContainer.Size = UDim2.new(1, 0, 0.82, 0)
        UpdatesContainer.Position = UDim2.new(0, 0, 0.18, 0)
        UpdatesContainer.BackgroundTransparency = 1
        UpdatesContainer.ScrollBarThickness = 3
        UpdatesContainer.Visible = true
        UpdatesContainer.Parent = Frame

        local MiscContainer = Instance.new("ScrollingFrame")
        MiscContainer.Size = UDim2.new(1, 0, 0.82, 0)
        MiscContainer.Position = UDim2.new(0, 0, 0.18, 0)
        MiscContainer.BackgroundTransparency = 1
        MiscContainer.ScrollBarThickness = 3
        MiscContainer.Visible = false
        MiscContainer.Parent = Frame

        -- Функция создания кнопок
        local function CreateButton(parent, text)
            local Button = Instance.new("TextButton")
            Button.Text = text
            Button.Size = UDim2.new(0.9, 0, 0, 35)
            Button.Position = UDim2.new(0.05, 0, 0, 0)
            Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Button.BorderColor3 = Color3.fromRGB(255, 40, 40)
            Button.BorderSizePixel = 1
            Button.TextColor3 = Color3.new(1, 1, 1)
            Button.Font = Enum.Font.Gotham
            Button.Parent = parent
            return Button
        end

        -- Раздел UPDATES
        CreateButton(UpdatesContainer, "Test#1 (Disabled)")

        -- Раздел MISC
        local FlyBtn = CreateButton(MiscContainer, "FLY [OFF]")
        local NoclipBtn = CreateButton(MiscContainer, "NOCLIP [OFF]")

        -- Настройки скорости
        local SpeedFrame = Instance.new("Frame")
        SpeedFrame.Size = UDim2.new(0.9, 0, 0, 80)
        SpeedFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
        SpeedFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        SpeedFrame.BorderSizePixel = 0
        SpeedFrame.Visible = false
        SpeedFrame.Parent = MiscContainer

        local SpeedLabel = Instance.new("TextLabel")
        SpeedLabel.Text = "Speed: " .. flySpeed
        SpeedLabel.Size = UDim2.new(1, 0, 0.4, 0)
        SpeedLabel.BackgroundTransparency = 1
        SpeedLabel.TextColor3 = Color3.new(1, 1, 1)
        SpeedLabel.Font = Enum.Font.Gotham
        SpeedLabel.Parent = SpeedFrame

        -- Механики
        local function Fly()
            if not flyActive or not Player.Character then return end
            
            local Humanoid = Player.Character:FindFirstChild("Humanoid")
            local RootPart = Player.Character:FindFirstChild("HumanoidRootPart")
            if not Humanoid or not RootPart then return end
            
            Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            
            local cam = workspace.CurrentCamera.CFrame.LookVector
            local moveDir = Vector3.new()
            
            -- Горизонтальное движение
            if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir += Vector3.new(cam.X, 0, cam.Z) end
            if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir -= Vector3.new(cam.X, 0, cam.Z) end
            if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir += Vector3.new(-cam.Z, 0, cam.X) end
            if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir += Vector3.new(cam.Z, 0, -cam.X) end
            
            -- Вертикальное движение
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

        -- Изменение скорости
        local SpeedUp = CreateButton(SpeedFrame, "▲ Increase")
        SpeedUp.Position = UDim2.new(0, 0, 0.4, 0)
        SpeedUp.MouseButton1Click:Connect(function()
            flySpeed = math.clamp(flySpeed + 5, 10, 100)
            SpeedLabel.Text = "Speed: " .. flySpeed
        end)

        local SpeedDown = CreateButton(SpeedFrame, "▼ Decrease")
        SpeedDown.Position = UDim2.new(0, 0, 0.7, 0)
        SpeedDown.MouseButton1Click:Connect(function()
            flySpeed = math.clamp(flySpeed - 5, 10, 100)
            SpeedLabel.Text = "Speed: " .. flySpeed
        end)

        -- Основной цикл
        RunService.Heartbeat:Connect(function()
            if flyActive then Fly() end
            if noclipActive then Noclip() end
        end)

        -- Управление видимостью
        UIS.InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.RightControl then
                ScreenGui.Enabled = not ScreenGui.Enabled
            end
        end)
    end)

    if not success then
        warn("Ошибка в BloodHub:", err)
    end
end

-- Запуск с защитой
local success, err = pcall(LoadBloodHub)
if not success then
    warn("Фатальная ошибка:", err)
end