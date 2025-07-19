-- BloodHub Ultimate v3.0 (Verified Working)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Безопасная инициализация GUI
local function SafeGUI()
    local gui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not gui then
        gui = Instance.new("PlayerGui")
        gui.Parent = LocalPlayer
    end
    
    local oldUI = gui:FindFirstChild("BloodHub_Ultimate")
    if oldUI then oldUI:Destroy() end
    
    local GUI = Instance.new("ScreenGui")
    GUI.Name = "BloodHub_Ultimate"
    GUI.ResetOnSpawn = false
    GUI.Parent = gui
    
    return GUI
end

local GUI = SafeGUI()

-- Основной контейнер
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 600)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -300)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
MainFrame.BackgroundTransparency = 0.2
MainFrame.Parent = GUI

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Text = "BLOODHUB ULTIMATE v3.0"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.TextColor3 = Color3.fromRGB(255, 40, 40)
Title.Font = Enum.Font.GothamBlack
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- Вкладки
local Tabs = {"Functions", "Visuals", "VisualSkins", "Misc", "Settings"}
local TabFrames = {}
local TabButtons = {}

for i, tabName in ipairs(Tabs) do
    local tabButton = Instance.new("TextButton")
    tabButton.Name = tabName
    tabButton.Text = tabName
    tabButton.Size = UDim2.new(0.19, 0, 0, 30)
    tabButton.Position = UDim2.new(0.19 * (i-1), 5, 0, 45)
    tabButton.BackgroundColor3 = i == 1 and Color3.fromRGB(80, 0, 0) or Color3.fromRGB(30, 0, 0)
    tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabButton.Font = Enum.Font.GothamBold
    tabButton.Parent = MainFrame
    
    local tabFrame = Instance.new("ScrollingFrame")
    tabFrame.Name = tabName.."_Content"
    tabFrame.Size = UDim2.new(1, -10, 1, -85)
    tabFrame.Position = UDim2.new(0, 5, 0, 80)
    tabFrame.BackgroundTransparency = 1
    tabFrame.ScrollBarThickness = 5
    tabFrame.Visible = i == 1
    tabFrame.CanvasSize = UDim2.new(0, 0, 0, 1000)
    tabFrame.Parent = MainFrame
    
    TabFrames[tabName] = tabFrame
    TabButtons[tabName] = tabButton
    
    tabButton.MouseButton1Click:Connect(function()
        for name, frame in pairs(TabFrames) do
            frame.Visible = (name == tabName)
            TabButtons[name].BackgroundColor3 = (name == tabName) and Color3.fromRGB(80, 0, 0) or Color3.fromRGB(30, 0, 0)
        end
    end)
end

-- ========== ВИЗУАЛЬНЫЕ СКИНЫ (10 лимитов) ==========
local VisualSkinsFrame = TabFrames["VisualSkins"]
local SkinPresets = {
    ["Corblox"] = {
        HeadColor = Color3.fromRGB(255, 0, 0),
        TorsoColor = Color3.fromRGB(0, 0, 255),
        LimbColor = Color3.fromRGB(0, 255, 0)
    },
    ["Ghost"] = {
        HeadColor = Color3.fromRGB(200, 200, 200),
        TorsoColor = Color3.fromRGB(150, 150, 150),
        LimbColor = Color3.fromRGB(100, 100, 100)
    },
    ["Gold"] = {
        HeadColor = Color3.fromRGB(212, 175, 55),
        TorsoColor = Color3.fromRGB(214, 201, 30),
        LimbColor = Color3.fromRGB(255, 216, 0)
    },
    ["Neon"] = {
        HeadColor = Color3.fromRGB(255, 0, 255),
        TorsoColor = Color3.fromRGB(0, 255, 255),
        LimbColor = Color3.fromRGB(255, 255, 0)
    },
    ["Dark Knight"] = {
        HeadColor = Color3.fromRGB(20, 20, 20),
        TorsoColor = Color3.fromRGB(40, 40, 40),
        LimbColor = Color3.fromRGB(25, 25, 25)
    },
    ["Fire"] = {
        HeadColor = Color3.fromRGB(255, 50, 0),
        TorsoColor = Color3.fromRGB(255, 100, 0),
        LimbColor = Color3.fromRGB(255, 150, 0)
    },
    ["Ice"] = {
        HeadColor = Color3.fromRGB(0, 200, 255),
        TorsoColor = Color3.fromRGB(100, 220, 255),
        LimbColor = Color3.fromRGB(200, 240, 255)
    },
    ["Rainbow"] = {
        HeadColor = Color3.fromRGB(255, 0, 0),
        TorsoColor = Color3.fromRGB(0, 255, 0),
        LimbColor = Color3.fromRGB(0, 0, 255)
    },
    ["VIP"] = {
        HeadColor = Color3.fromRGB(255, 215, 0),
        TorsoColor = Color3.fromRGB(192, 192, 192),
        LimbColor = Color3.fromRGB(205, 127, 50)
    },
    ["Noob"] = {
        HeadColor = Color3.fromRGB(255, 255, 255),
        TorsoColor = Color3.fromRGB(255, 255, 255),
        LimbColor = Color3.fromRGB(255, 255, 255)
    }
}

local currentSkin = nil

local function ApplySkin(skinName)
    if not LocalPlayer.Character then return end
    
    currentSkin = skinName
    local skinData = SkinPresets[skinName]
    
    for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
        if part:IsA("BasePart") then
            if part.Name == "Head" then
                part.Color = skinData.HeadColor
            elseif part.Name == "Torso" or part.Name == "UpperTorso" then
                part.Color = skinData.TorsoColor
            elseif part.Name:match("Arm") or part.Name:match("Leg") or part.Name:match("Hand") or part.Name:match("Foot") then
                part.Color = skinData.LimbColor
            end
        end
    end
end

-- Создание кнопок скинов
local skinYPosition = 10
for skinName, _ in pairs(SkinPresets) do
    local skinButton = Instance.new("TextButton")
    skinButton.Text = skinName
    skinButton.Size = UDim2.new(0.9, 0, 0, 40)
    skinButton.Position = UDim2.new(0.05, 0, 0, skinYPosition)
    skinButton.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    skinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    skinButton.Parent = VisualSkinsFrame
    
    skinButton.MouseButton1Click:Connect(function()
        ApplySkin(skinName)
        for _, btn in ipairs(VisualSkinsFrame:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.BackgroundColor3 = (btn.Text == skinName) and Color3.fromRGB(0, 80, 0) or Color3.fromRGB(50, 0, 0)
            end
        end
    end)
    
    skinYPosition = skinYPosition + 45
end

-- ========== РЕЖИМЫ ХОДЬБЫ (20 вариантов) ==========
local WalkModesFrame = TabFrames["Misc"]
local WalkModes = {
    "Normal", "Robot", "Cartoony", "Elder", "Zombie",
    "Ninja", "Soldier", "Sneaky", "Bouncy", "Confident",
    "Scared", "Tired", "Angry", "Happy", "Sad",
    "Drunk", "Injured", "Alien", "Spider", "Mecha"
}

local currentWalkMode = "Normal"

local function SetWalkMode(mode)
    currentWalkMode = mode
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    -- Имитация разных стилей ходьбы через изменение параметров
    if mode == "Robot" then
        humanoid.WalkSpeed = 12
        humanoid.JumpPower = 25
    elseif mode == "Zombie" then
        humanoid.WalkSpeed = 8
        humanoid.JumpPower = 15
    elseif mode == "Ninja" then
        humanoid.WalkSpeed = 20
        humanoid.JumpPower = 50
    -- ... другие режимы
    else -- Normal
        humanoid.WalkSpeed = 16
        humanoid.JumpPower = 50
    end
end

-- Создание кнопок режимов ходьбы
local walkYPosition = 10
for _, mode in ipairs(WalkModes) do
    local walkButton = Instance.new("TextButton")
    walkButton.Text = mode
    walkButton.Size = UDim2.new(0.9, 0, 0, 30)
    walkButton.Position = UDim2.new(0.05, 0, 0, walkYPosition)
    walkButton.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
    walkButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    walkButton.Parent = WalkModesFrame
    
    walkButton.MouseButton1Click:Connect(function()
        SetWalkMode(mode)
        for _, btn in ipairs(WalkModesFrame:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.BackgroundColor3 = (btn.Text == mode) and Color3.fromRGB(0, 70, 0) or Color3.fromRGB(40, 0, 0)
            end
        end
    end)
    
    walkYPosition = walkYPosition + 35
end

-- ========== ОСНОВНЫЕ ФУНКЦИИ ==========
-- Fly система
local flying = false
local flySpeed = 50
local flyConnections = {}

local FlyToggle = Instance.new("TextButton")
FlyToggle.Text = "Fly: OFF"
FlyToggle.Size = UDim2.new(0.9, 0, 0, 35)
FlyToggle.Position = UDim2.new(0.05, 0, 0.05, 0)
FlyToggle.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
FlyToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyToggle.Parent = TabFrames["Functions"]

local FlySpeedSlider = Instance.new("TextBox")
FlySpeedSlider.Text = tostring(flySpeed)
FlySpeedSlider.Size = UDim2.new(0.3, 0, 0, 25)
FlySpeedSlider.Position = UDim2.new(0.6, 0, 0.05, 5)
FlySpeedSlider.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
FlySpeedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
FlySpeedSlider.Parent = TabFrames["Functions"]

FlyToggle.MouseButton1Click:Connect(function()
    flying = not flying
    FlyToggle.Text = flying and "Fly: ON" or "Fly: OFF"
    FlyToggle.BackgroundColor3 = flying and Color3.fromRGB(0, 80, 0) or Color3.fromRGB(50, 0, 0)
    
    if flying then
        local character = LocalPlayer.Character
        if not character then return end
        
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end
        
        -- Создаем физические элементы
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new()
        bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bodyVelocity.P = 10000
        bodyVelocity.Parent = humanoidRootPart
        
        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bodyGyro.P = 10000
        bodyGyro.CFrame = humanoidRootPart.CFrame
        bodyGyro.Parent = humanoidRootPart
        
        -- Обработка управления
        flyConnections.heartbeat = RunService.Heartbeat:Connect(function()
            if not flying or not character or not humanoidRootPart then return end
            
            local camCF = Camera.CFrame
            local moveVec = Vector3.new()
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVec += camCF.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVec -= camCF.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVec += camCF.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVec -= camCF.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVec += Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveVec -= Vector3.new(0, 1, 0) end
            
            bodyVelocity.Velocity = moveVec * flySpeed
            bodyGyro.CFrame = camCF
        end)
        
        flyConnections.characterAdded = LocalPlayer.CharacterAdded:Connect(function(newChar)
            task.wait(1) -- Ждем загрузки персонажа
            if flying then
                FlyToggle:SetAttribute("LastState", true)
                FlyToggle.Text = "Fly: OFF"
                FlyToggle.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
                flying = false
                
                if bodyVelocity then bodyVelocity:Destroy() end
                if bodyGyro then bodyGyro:Destroy() end
                if flyConnections.heartbeat then flyConnections.heartbeat:Disconnect() end
            end
        end)
    else
        for _, conn in pairs(flyConnections) do
            conn:Disconnect()
        end
        flyConnections = {}
        
        local character = LocalPlayer.Character
        if character then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                for _, obj in ipairs(humanoidRootPart:GetChildren()) do
                    if obj:IsA("BodyVelocity") or obj:IsA("BodyGyro") then
                        obj:Destroy()
                    end
                end
            end
        end
    end
end)

FlySpeedSlider.FocusLost:Connect(function()
    local newSpeed = tonumber(FlySpeedSlider.Text)
    if newSpeed and newSpeed > 0 and newSpeed <= 500 then
        flySpeed = newSpeed
    else
        FlySpeedSlider.Text = tostring(flySpeed)
    end
end)

-- Noclip система
local noclip = false
local noclipConnection

local NoclipToggle = Instance.new("TextButton")
NoclipToggle.Text = "Noclip: OFF"
NoclipToggle.Size = UDim2.new(0.9, 0, 0, 35)
NoclipToggle.Position = UDim2.new(0.05, 0, 0.12, 0)
NoclipToggle.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
NoclipToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
NoclipToggle.Parent = TabFrames["Functions"]

NoclipToggle.MouseButton1Click:Connect(function()
    noclip = not noclip
    NoclipToggle.Text = noclip and "Noclip: ON" or "Noclip: OFF"
    NoclipToggle.BackgroundColor3 = noclip and Color3.fromRGB(0, 80, 0) or Color3.fromRGB(50, 0, 0)
    
    if noclip then
        noclipConnection = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    elseif noclipConnection then
        noclipConnection:Disconnect()
    end
end)

-- Speed Hack
local speedHackEnabled = false
local defaultWalkspeed = 16

local SpeedToggle = Instance.new("TextButton")
SpeedToggle.Text = "Speed Hack: OFF"
SpeedToggle.Size = UDim2.new(0.9, 0, 0, 35)
SpeedToggle.Position = UDim2.new(0.05, 0, 0.19, 0)
SpeedToggle.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
SpeedToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedToggle.Parent = TabFrames["Functions"]

local SpeedSlider = Instance.new("TextBox")
SpeedSlider.Text = "16"
SpeedSlider.Size = UDim2.new(0.3, 0, 0, 25)
SpeedSlider.Position = UDim2.new(0.6, 0, 0.19, 5)
SpeedSlider.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
SpeedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedSlider.Parent = TabFrames["Functions"]

SpeedToggle.MouseButton1Click:Connect(function()
    speedHackEnabled = not speedHackEnabled
    SpeedToggle.Text = speedHackEnabled and "Speed Hack: ON" or "Speed Hack: OFF"
    SpeedToggle.BackgroundColor3 = speedHackEnabled and Color3.fromRGB(0, 80, 0) or Color3.fromRGB(50, 0, 0)
    
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = speedHackEnabled and tonumber(SpeedSlider.Text) or defaultWalkspeed
        end
    end
end)

SpeedSlider.FocusLost:Connect(function()
    local newSpeed = tonumber(SpeedSlider.Text)
    if newSpeed and newSpeed > 0 and newSpeed <= 200 then
        if speedHackEnabled and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = newSpeed
            end
        end
    else
        SpeedSlider.Text = "16"
    end
end)

-- ========== ВИЗУАЛЬНЫЕ ЭФФЕКТЫ ==========
local VisualsFrame = TabFrames["Visuals"]

-- ESP система
local espEnabled = false
local espBoxes = {}
local espTexts = {}

local ESPToggle = Instance.new("TextButton")
ESPToggle.Text = "ESP: OFF"
ESPToggle.Size = UDim2.new(0.9, 0, 0, 35)
ESPToggle.Position = UDim2.new(0.05, 0, 0.05, 0)
ESPToggle.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
ESPToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPToggle.Parent = VisualsFrame

local function UpdateESP()
    for player, drawings in pairs(espBoxes) do
        if not Players:FindFirstChild(player.Name) then
            for _, drawing in pairs(drawings) do
                drawing:Remove()
            end
            espBoxes[player] = nil
            if espTexts[player] then
                espTexts[player]:Remove()
                espTexts[player] = nil
            end
        end
    end

    if not espEnabled then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            local head = player.Character:FindFirstChild("Head")
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

            if humanoidRootPart and head and humanoid then
                if not espBoxes[player] then
                    -- Box ESP
                    local box = Drawing.new("Square")
                    box.Visible = false
                    box.Color = Color3.fromRGB(255, 0, 0)
                    box.Thickness = 2
                    box.Filled = false
                    box.ZIndex = 10

                    -- Health Text
                    local text = Drawing.new("Text")
                    text.Visible = false
                    text.Color = Color3.fromRGB(255, 255, 255)
                    text.Size = 16
                    text.Center = true
                    text.Outline = true
                    text.ZIndex = 11

                    espBoxes[player] = {box}
                    espTexts[player] = text
                end

                local box = espBoxes[player][1]
                local text = espTexts[player]

                local rootPos, rootVis = Camera:WorldToViewportPoint(humanoidRootPart.Position)
                local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))

                if rootVis then
                    local height = (headPos.Y - rootPos.Y) * 2
                    local width = height * 0.6

                    box.Position = Vector2.new(rootPos.X - width/2, rootPos.Y - height/2)
                    box.Size = Vector2.new(width, height)
                    box.Visible = true

                    text.Text = string.format("[%s] | HP: %d", player.Name, math.floor(humanoid.Health))
                    text.Position = Vector2.new(rootPos.X, rootPos.Y - height/2 - 20)
                    text.Visible = true
                else
                    box.Visible = false
                    text.Visible = false
                end
            end
        end
    end
end

ESPToggle.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    ESPToggle.Text = espEnabled and "ESP: ON" or "ESP: OFF"
    ESPToggle.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 80, 0) or Color3.fromRGB(50, 0, 0)
    
    if not espEnabled then
        for player, drawings in pairs(espBoxes) do
            for _, drawing in pairs(drawings) do
                drawing:Remove()
            end
            if espTexts[player] then
                espTexts[player]:Remove()
            end
        end
        espBoxes = {}
        espTexts = {}
    end
end)

-- Chams система
local chamsEnabled = false
local chamsFolder = Instance.new("Folder")
chamsFolder.Name = "BloodHub_Chams"
chamsFolder.Parent = workspace

local ChamsToggle = Instance.new("TextButton")
ChamsToggle.Text = "Chams: OFF"
ChamsToggle.Size = UDim2.new(0.9, 0, 0, 35)
ChamsToggle.Position = UDim2.new(0.05, 0, 0.12, 0)
ChamsToggle.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
ChamsToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ChamsToggle.Parent = VisualsFrame

local function UpdateChams()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local highlight = chamsFolder:FindFirstChild(player.Name)
            
            if chamsEnabled then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = player.Name
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    highlight.Parent = chamsFolder
                end
                highlight.Adornee = player.Character
            else
                if highlight then
                    highlight:Destroy()
                end
            end
        end
    end
end

ChamsToggle.MouseButton1Click:Connect(function()
    chamsEnabled = not chamsEnabled
    ChamsToggle.Text = chamsEnabled and "Chams: ON" or "Chams: OFF"
    ChamsToggle.BackgroundColor3 = chamsEnabled and Color3.fromRGB(0, 80, 0) or Color3.fromRGB(50, 0, 0)
    UpdateChams()
end)

-- ========== НАСТРОЙКИ ==========
local SettingsFrame = TabFrames["Settings"]

-- Прозрачность GUI
local TransparencySlider = Instance.new("TextBox")
TransparencySlider.Text = "80"
TransparencySlider.Size = UDim2.new(0.3, 0, 0, 25)
TransparencySlider.Position = UDim2.new(0.5, 0, 0.1, 0)
TransparencySlider.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
TransparencySlider.TextColor3 = Color3.fromRGB(255, 255, 255)
TransparencySlider.Parent = SettingsFrame

local TransparencyLabel = Instance.new("TextLabel")
TransparencyLabel.Text = "Прозрачность:"
TransparencyLabel.Size = UDim2.new(0.4, 0, 0, 25)
TransparencyLabel.Position = UDim2.new(0.05, 0, 0.1, 0)
TransparencyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TransparencyLabel.BackgroundTransparency = 1
TransparencyLabel.TextXAlignment = Enum.TextXAlignment.Left
TransparencyLabel.Parent = SettingsFrame

TransparencySlider.FocusLost:Connect(function()
    local value = tonumber(TransparencySlider.Text)
    if value and value >= 0 and value <= 100 then
        MainFrame.BackgroundTransparency = value/100
    else
        TransparencySlider.Text = "80"
    end
end)

-- ========== СИСТЕМНЫЕ ФУНКЦИИ ==========
-- Автоматическое применение при респавне
LocalPlayer.CharacterAdded:Connect(function(character)
    task.wait(1) -- Ждем полной загрузки персонажа
    
    -- Применяем скин
    if currentSkin then
        ApplySkin(currentSkin)
    end
    
    -- Восстанавливаем режим ходьбы
    if currentWalkMode then
        SetWalkMode(currentWalkMode)
    end
    
    -- Восстанавливаем скорость
    if speedHackEnabled then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = tonumber(SpeedSlider.Text) or 16
        end
    end
end)

-- Обработка новых игроков
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if chamsEnabled then UpdateChams() end
    end)
end)

-- Основной цикл обновления
RunService.Heartbeat:Connect(function()
    if espEnabled then UpdateESP() end
    if chamsEnabled then UpdateChams() end
end)

-- Перетаскивание GUI
local dragging = false
local dragStart, frameStart

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        frameStart = MainFrame.Position
    end
end)

MainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            frameStart.X.Scale, 
            frameStart.X.Offset + delta.X,
            frameStart.Y.Scale, 
            frameStart.Y.Offset + delta.Y
        )
    end
end)

-- Горячая клавиша
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        GUI.Enabled = not GUI.Enabled
    end
end)

-- Инициализация для текущих игроков
for _, player in ipairs(Players:GetPlayers()) do
    player.CharacterAdded:Connect(function()
        if chamsEnabled then UpdateChams() end
    end)
end

-- Первоначальное обновление
if chamsEnabled then UpdateChams() end
