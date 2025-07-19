local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local GUI = Instance.new("ScreenGui")
GUI.Name = "BloodHub_Main"
GUI.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Основной контейнер
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 500)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
MainFrame.BackgroundTransparency = 0.3
MainFrame.BorderSizePixel = 0
MainFrame.Parent = GUI

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Text = "BLOODHUB v1.0"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.TextColor3 = Color3.fromRGB(255, 50, 50)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- Список вкладок
local Tabs = {
    "Functions",
    "Visuals",
    "Misc",
    "Settings"
}

-- Контейнеры для содержимого вкладок
local TabFrames = {}
local TabButtons = {}

-- Создаем вкладки
for i, tabName in ipairs(Tabs) do
    -- Кнопка вкладки
    local tabButton = Instance.new("TextButton")
    tabButton.Name = tabName
    tabButton.Text = tabName
    tabButton.Size = UDim2.new(0.24, 0, 0, 30)
    tabButton.Position = UDim2.new(0.25 * (i-1), 0, 0, 45)
    tabButton.BackgroundColor3 = i == 1 and Color3.fromRGB(80, 0, 0) or Color3.fromRGB(30, 0, 0)
    tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabButton.Font = Enum.Font.Gotham
    tabButton.Parent = MainFrame
    
    -- Контейнер содержимого вкладки
    local tabFrame = Instance.new("Frame")
    tabFrame.Name = tabName.."_Content"
    tabFrame.Size = UDim2.new(1, 0, 1, -80)
    tabFrame.Position = UDim2.new(0, 0, 0, 80)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Visible = i == 1
    tabFrame.Parent = MainFrame
    
    TabFrames[tabName] = tabFrame
    TabButtons[tabName] = tabButton
    
    -- Обработчик клика
    tabButton.MouseButton1Click:Connect(function()
        for name, frame in pairs(TabFrames) do
            frame.Visible = (name == tabName)
        end
        for name, button in pairs(TabButtons) do
            button.BackgroundColor3 = (name == tabName) and Color3.fromRGB(80, 0, 0) or Color3.fromRGB(30, 0, 0)
        end
    end)
end

-- Добавляем элементы на вкладку Functions
do
    local functionsFrame = TabFrames["Functions"]
    
    -- Fly
    local flyButton = Instance.new("TextButton")
    flyButton.Text = "Включить Fly"
    flyButton.Size = UDim2.new(0.9, 0, 0, 40)
    flyButton.Position = UDim2.new(0.05, 0, 0.05, 0)
    flyButton.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    flyButton.Parent = functionsFrame
    
    -- Noclip
    local noclipButton = Instance.new("TextButton")
    noclipButton.Text = "Включить Noclip"
    noclipButton.Size = UDim2.new(0.9, 0, 0, 40)
    noclipButton.Position = UDim2.new(0.05, 0, 0.15, 0)
    noclipButton.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    noclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    noclipButton.Parent = functionsFrame
    
    -- Speed
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Text = "Скорость: 16"
    speedLabel.Size = UDim2.new(0.6, 0, 0, 30)
    speedLabel.Position = UDim2.new(0.05, 0, 0.25, 0)
    speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedLabel.BackgroundTransparency = 1
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    speedLabel.Parent = functionsFrame
    
    local speedBox = Instance.new("TextBox")
    speedBox.Text = "16"
    speedBox.Size = UDim2.new(0.25, 0, 0, 30)
    speedBox.Position = UDim2.new(0.7, 0, 0.25, 0)
    speedBox.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
    speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedBox.Parent = functionsFrame
end

-- Добавляем элементы на вкладку Visuals
do
    local visualsFrame = TabFrames["Visuals"]
    
    local espButton = Instance.new("TextButton")
    espButton.Text = "Включить ESP"
    espButton.Size = UDim2.new(0.9, 0, 0, 40)
    espButton.Position = UDim2.new(0.05, 0, 0.05, 0)
    espButton.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    espButton.Parent = visualsFrame
    
    local chamsButton = Instance.new("TextButton")
    chamsButton.Text = "Включить Chams"
    chamsButton.Size = UDim2.new(0.9, 0, 0, 40)
    chamsButton.Position = UDim2.new(0.05, 0, 0.15, 0)
    chamsButton.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    chamsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    chamsButton.Parent = visualsFrame
end

-- Система перетаскивания
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
end)

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

-- Горячая клавиша для скрытия/показа
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        GUI.Enabled = not GUI.Enabled
    end
end)
