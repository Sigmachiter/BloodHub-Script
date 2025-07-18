local Player = game:GetService("Players").LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")

-- Создаём интерфейс
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BloodHub"
ScreenGui.Parent = CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0.2, 0, 0.4, 0) -- Увеличили высоту для настроек
Frame.Position = UDim2.new(0.8, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
Frame.BorderSizePixel = 2
Frame.Parent = ScreenGui

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Text = "BLOODHUB"
Title.Size = UDim2.new(1, 0, 0.08, 0)
Title.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Title.TextColor3 = Color3.fromRGB(0, 0, 0)
Title.Font = Enum.Font.GothamBlack
Title.Parent = Frame

-- Вкладки
local TabsFrame = Instance.new("Frame")
TabsFrame.Size = UDim2.new(1, 0, 0.07, 0)
TabsFrame.Position = UDim2.new(0, 0, 0.08, 0)
TabsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TabsFrame.Parent = Frame

local UpdatesTab = Instance.new("TextButton")
UpdatesTab.Text = "UPDATES"
UpdatesTab.Size = UDim2.new(0.5, 0, 1, 0)
UpdatesTab.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
UpdatesTab.TextColor3 = Color3.fromRGB(0, 0, 0)
UpdatesTab.Font = Enum.Font.GothamBold
UpdatesTab.Parent = TabsFrame

local MiscTab = Instance.new("TextButton")
MiscTab.Text = "MISC"
MiscTab.Size = UDim2.new(0.5, 0, 1, 0)
MiscTab.Position = UDim2.new(0.5, 0, 0, 0)
MiscTab.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MiscTab.TextColor3 = Color3.fromRGB(255, 255, 255)
MiscTab.Font = Enum.Font.GothamBold
MiscTab.Parent = TabsFrame

-- Контейнеры
local UpdatesContainer = Instance.new("ScrollingFrame")
UpdatesContainer.Size = UDim2.new(1, 0, 0.85, 0)
UpdatesContainer.Position = UDim2.new(0, 0, 0.15, 0)
UpdatesContainer.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
UpdatesContainer.ScrollBarThickness = 3
UpdatesContainer.Visible = true
UpdatesContainer.Parent = Frame

local MiscContainer = Instance.new("ScrollingFrame")
MiscContainer.Size = UDim2.new(1, 0, 0.85, 0)
MiscContainer.Position = UDim2.new(0, 0, 0.15, 0)
MiscContainer.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MiscContainer.ScrollBarThickness = 3
MiscContainer.Visible = false
MiscContainer.Parent = Frame

local UIListLayout1 = Instance.new("UIListLayout")
UIListLayout1.Parent = UpdatesContainer
UIListLayout1.Padding = UDim.new(0, 5)

local UIListLayout2 = Instance.new("UIListLayout")
UIListLayout2.Parent = MiscContainer
UIListLayout2.Padding = UDim.new(0, 5)

-- Функция создания кнопок
local function CreateButton(parent, text, onClick)
    local Button = Instance.new("TextButton")
    Button.Text = text
    Button.Size = UDim2.new(0.9, 0, 0, 30)
    Button.Position = UDim2.new(0.05, 0, 0, 0)
    Button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Button.BorderColor3 = Color3.fromRGB(255, 0, 0)
    Button.BorderSizePixel = 1
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.Gotham
    Button.Parent = parent
    
    if onClick then
        Button.MouseButton1Click:Connect(onClick)
    end
    
    return Button
end

-- Раздел Updates (неактивная функция)
CreateButton(UpdatesContainer, "Test#1", function()
    warn("Эта функция не активна (тест античита)")
end)

CreateButton(UpdatesContainer, "Patch Notes v1.2")
CreateButton(UpdatesContainer, "Known Issues")

-- Раздел Misc (Fly Hack)
local flyActive = false
local flySpeed = 50

local FlyButton = CreateButton(MiscContainer, "Fly [OFF]", function()
    flyActive = not flyActive
    FlyButton.Text = flyActive and "Fly [ON]" or "Fly [OFF]"
    
    if flyActive then
        SettingsFrame.Visible = true
    else
        SettingsFrame.Visible = false
    end
end)

-- Настройки скорости флая
local SettingsFrame = Instance.new("Frame")
SettingsFrame.Size = UDim2.new(0.9, 0, 0, 80)
SettingsFrame.Position = UDim2.new(0.05, 0, 0, 35)
SettingsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
SettingsFrame.BorderSizePixel = 0
SettingsFrame.Visible = false
SettingsFrame.Parent = MiscContainer

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Text = "Скорость: " .. flySpeed
SpeedLabel.Size = UDim2.new(1, 0, 0.3, 0)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.Parent = SettingsFrame

local SpeedSlider = Instance.new("TextButton")
SpeedSlider.Text = "▲ Изменить ▼"
SpeedSlider.Size = UDim2.new(1, 0, 0.3, 0)
SpeedSlider.Position = UDim2.new(0, 0, 0.3, 0)
SpeedSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SpeedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedSlider.Font = Enum.Font.Gotham
SpeedSlider.Parent = SettingsFrame

SpeedSlider.MouseButton1Click:Connect(function()
    flySpeed = math.clamp(flySpeed + 10, 20, 150)
    SpeedLabel.Text = "Скорость: " .. flySpeed
end)

SpeedSlider.MouseButton2Click:Connect(function()
    flySpeed = math.clamp(flySpeed - 10, 20, 150)
    SpeedLabel.Text = "Скорость: " .. flySpeed
end)

-- Система флая
local function Fly()
    if flyActive and Player.Character then
        local Humanoid = Player.Character:FindFirstChild("Humanoid")
        local RootPart = Player.Character:FindFirstChild("HumanoidRootPart")
        
        if Humanoid and RootPart then
            Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            
            local cam = workspace.CurrentCamera.CFrame.LookVector
            RootPart.Velocity = Vector3.new(
                cam.X * flySpeed,
                (UIS:IsKeyDown(Enum.KeyCode.Space) and flySpeed or 0) - 
                (UIS:IsKeyDown(Enum.KeyCode.LeftShift) and flySpeed/2 or 0),
                cam.Z * flySpeed
            )
        end
    end
end

game:GetService("RunService").Heartbeat:Connect(Fly)

-- Переключение вкладок
UpdatesTab.MouseButton1Click:Connect(function()
    UpdatesContainer.Visible = true
    MiscContainer.Visible = false
    UpdatesTab.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    UpdatesTab.TextColor3 = Color3.fromRGB(0, 0, 0)
    MiscTab.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MiscTab.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

MiscTab.MouseButton1Click:Connect(function()
    UpdatesContainer.Visible = false
    MiscContainer.Visible = true
    MiscTab.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    MiscTab.TextColor3 = Color3.fromRGB(0, 0, 0)
    UpdatesTab.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    UpdatesTab.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

-- Управление видимостью
UIS.InputBegan:Connect(function(input, _)
    if input.KeyCode == Enum.KeyCode.RightControl then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

ScreenGui.Enabled = false