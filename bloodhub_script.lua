-- BloodHub Premium v3.0 by @ws3eqr
local function LoadBloodHub()
    if _G.BloodHubLoaded then return end
    _G.BloodHubLoaded = true

    -- Сервисы
    local Player = game:GetService("Players").LocalPlayer
    local UIS = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")

    -- Состояния
    local flyActive = false
    local noclipActive = false
    local flySpeed = 50
    local walkSpeed = 16
    local dragging = false
    local dragInput, dragStart, startPos

    -- Создание интерфейса
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BloodHub"
    ScreenGui.Parent = game:GetService("CoreGui")

    -- Главное окно (с возможностью перемещения)
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0.25, 0, 0.4, 0)
    MainFrame.Position = UDim2.new(0.75, 0, 0.3, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Selectable = true
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    -- Система перемещения окна
    local function UpdateInput(input)
        if dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X, 
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end

    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            UpdateInput(input)
        end
    end)

    -- WalkSpeed Slider (ползунок)
    local WalkSpeedBtn = Instance.new("TextButton")
    WalkSpeedBtn.Name = "WalkSpeedBtn"
    WalkSpeedBtn.Text = "WalkSpeed: "..walkSpeed
    WalkSpeedBtn.Size = UDim2.new(0.9, 0, 0, 35)
    WalkSpeedBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
    WalkSpeedBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    WalkSpeedBtn.TextColor3 = Color3.new(1, 1, 1)
    WalkSpeedBtn.Font = Enum.Font.GothamBold
    WalkSpeedBtn.TextSize = 12
    WalkSpeedBtn.Parent = MainFrame

    WalkSpeedBtn.MouseButton1Click:Connect(function()
        walkSpeed = walkSpeed + 5
        if walkSpeed > 100 then walkSpeed = 16 end
        WalkSpeedBtn.Text = "WalkSpeed: "..walkSpeed
        
        if Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
            Player.Character.Humanoid.WalkSpeed = walkSpeed
        end
    end)

    -- Noclip (100% рабочий)
    local NoclipBtn = Instance.new("TextButton")
    NoclipBtn.Name = "NoclipBtn"
    NoclipBtn.Text = "Noclip [OFF]"
    NoclipBtn.Size = UDim2.new(0.9, 0, 0, 35)
    NoclipBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
    NoclipBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    NoclipBtn.TextColor3 = Color3.new(1, 1, 1)
    NoclipBtn.Font = Enum.Font.GothamBold
    NoclipBtn.TextSize = 12
    NoclipBtn.Parent = MainFrame

    NoclipBtn.MouseButton1Click:Connect(function()
        noclipActive = not noclipActive
        NoclipBtn.Text = noclipActive and "Noclip [ON]" or "Noclip [OFF]"
    end)

    -- Dupe Items (рабочий)
    local DupeBtn = Instance.new("TextButton")
    DupeBtn.Name = "DupeBtn"
    DupeBtn.Text = "Dupe Items"
    DupeBtn.Size = UDim2.new(0.9, 0, 0, 35)
    DupeBtn.Position = UDim2.new(0.05, 0, 0.3, 0)
    DupeBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    DupeBtn.TextColor3 = Color3.new(1, 1, 1)
    DupeBtn.Font = Enum.Font.GothamBold
    DupeBtn.TextSize = 14
    DupeBtn.Parent = MainFrame

    DupeBtn.MouseButton1Click:Connect(function()
        if Player.Backpack then
            for _, tool in ipairs(Player.Backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    local clone = tool:Clone()
                    clone.Parent = Player.Backpack
                end
            end
        end
    end)

    -- Основной цикл
    RunService.Heartbeat:Connect(function()
        -- Noclip
        if Player.Character then
            for _, part in ipairs(Player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = not noclipActive
                end
            end
        end
    end)

    -- Управление видимостью
    UIS.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.RightControl then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)

    -- Инициализация
    ScreenGui.Enabled = false
end

-- Автозапуск
LoadBloodHub()
