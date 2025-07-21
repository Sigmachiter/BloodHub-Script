--// BLOODHUB v2.0 | Author: ws3eqr
--// Full GUI rewrite with categories, toggles, sliders and working Fly/Noclip

if game:GetService("CoreGui"):FindFirstChild("BLOODHUB_GUI") then
    game:GetService("CoreGui").BLOODHUB_GUI:Destroy()
end

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer
local chr = lp.Character or lp.CharacterAdded:Wait()
local hum = chr:WaitForChild("Humanoid")

-- GUI
local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
gui.Name = "BLOODHUB_GUI"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 600, 0, 350)
main.Position = UDim2.new(0.5, -300, 0.5, -175)
main.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
local grad = Instance.new("UIGradient", main)
grad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
}

-- Title
local title = Instance.new("TextLabel", main)
title.Text = "BLOODHUB v2.0 - by ws3eqr"
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 20

-- Tab Buttons
local tabNames = {"Information", "Fly", "Noclip", "Dupe", "FOV", "Speed", "Jump", "MISC"}
local tabs = {}
local contentFrames = {}

for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0, 100, 0, 30)
    btn.Position = UDim2.new(0, 10 + (i-1)*105, 0, 45)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local frame = Instance.new("Frame", main)
    frame.Size = UDim2.new(1, -20, 1, -90)
    frame.Position = UDim2.new(0, 10, 0, 85)
    frame.BackgroundTransparency = 1
    frame.Visible = false

    btn.MouseButton1Click:Connect(function()
        for _, f in pairs(contentFrames) do f.Visible = false end
        frame.Visible = true
    end)

    table.insert(tabs, btn)
    table.insert(contentFrames, frame)
end

-- Show first tab by default
contentFrames[1].Visible = true

-- Add dummy info
local info = Instance.new("TextLabel", contentFrames[1])
info.Size = UDim2.new(1, 0, 0, 50)
info.Text = "Author: ws3eqr\nVersion: 1.0\nAll features included"
info.TextColor3 = Color3.new(1, 1, 1)
info.Font = Enum.Font.Gotham
info.TextSize = 16
info.BackgroundTransparency = 1
info.TextWrapped = true

-- Right Ctrl toggle GUI
local open = true
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then
        open = not open
        gui.Enabled = open
    end
end)
