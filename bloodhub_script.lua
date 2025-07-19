-- BloodHub v1.0 by @ws3eqr
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- GUI
local BloodHub = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Tabs = Instance.new("Frame")
local Information = Instance.new("TextLabel")
local Functions = Instance.new("TextButton")
local Misc = Instance.new("TextButton")

-- Настройки
BloodHub.Name = "BloodHub"
BloodHub.Parent = game.CoreGui

MainFrame.Name = "MainFrame"
MainFrame.Parent = BloodHub
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
MainFrame.BorderSizePixel = 2
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.ClipsDescendants = true

-- Tabs
Tabs.Name = "Tabs"
Tabs.Parent = MainFrame
Tabs.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
Tabs.Size = UDim2.new(0, 100, 0, 400)

Information.Name = "Information"
Information.Parent = Tabs
Information.Text = "Информация о изменениях..."
Information.TextColor3 = Color3.fromRGB(255, 255, 255)

Functions.Name = "Functions"
Functions.Parent = Tabs
Functions.Text = "Функции"
Functions.TextColor3 = Color3.fromRGB(255, 255, 255)
Functions.MouseButton1Click:Connect(function()
    -- Активация функций
end)

Misc.Name = "Misc"
Misc.Parent = Tabs
Misc.Text = "Дополнительно"
Misc.TextColor3 = Color3.fromRGB(255, 255, 255)
Misc.MouseButton1Click:Connect(function()
    -- Настройки прозрачности и удаление
end)

-- Функции
local FlyEnabled = false
local FlySpeed = 50
local NoclipEnabled = false
local SuperJumpEnabled = false
local JumpHeight = 100

-- Fly
UIS.InputBegan:Connect(function(Input)
    if FlyEnabled then
        if Input.KeyCode == Enum.KeyCode.Space then
            -- Летим вверх
        elseif Input.KeyCode == Enum.KeyCode.LeftShift then
            -- Летим вниз
        end
    end
end)

-- Noclip
game:GetService("RunService").Stepped:Connect(function()
    if NoclipEnabled then
        Player.Character.Humanoid:ChangeState(11)
    end
end)

-- Супер-прыжок
Player.CharacterAdded:Connect(function(Char)
    Char:WaitForChild("Humanoid").JumpPower = JumpHeight
end)

-- Misc: Удаление GUI
local function RemoveGUI()
    BloodHub:Destroy()
end
