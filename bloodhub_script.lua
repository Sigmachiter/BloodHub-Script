-- BloodHub v1.1 | Universal Roblox GUI
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- 🔧 Settings
local Settings = {
    FlySpeed = 50,
    JumpHeight = 100,
    Noclip = false,
    Fly = false,
    SuperJump = false,
    ESP = false,
    Skeleton = false
}

-- 🎨 GUI Creation
local BloodHub = Instance.new("ScreenGui")
BloodHub.Name = "BloodHub"
BloodHub.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = BloodHub
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderColor3 = Color3.fromRGB(255, 0, 50)
MainFrame.BorderSizePixel = 2
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.Size = UDim2.new(0, 350, 0, 450)
MainFrame.ClipsDescendants = true

-- 🔹 Rounded Corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- 📌 Tabs
local Tabs = Instance.new("Frame")
Tabs.Name = "Tabs"
Tabs.Parent = MainFrame
Tabs.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
Tabs.Size = UDim2.new(0, 100, 0, 450)

-- 🔹 Tab Buttons
local function CreateTab(Name, Position)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = Name
    TabButton.Parent = Tabs
    TabButton.Text = Name
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.Position = Position
    TabButton.Size = UDim2.new(0, 100, 0, 40)
    TabButton.BackgroundTransparency = 0.7
    return TabButton
end

local InfoTab = CreateTab("Info", UDim2.new(0, 0, 0, 0))
local FunctionsTab = CreateTab("Functions", UDim2.new(0, 0, 0, 50))
local MiscTab = CreateTab("Misc", UDim2.new(0, 0, 0, 100))

-- 📜 Info Tab
local InfoFrame = Instance.new("ScrollingFrame")
InfoFrame.Parent = MainFrame
InfoFrame.Size = UDim2.new(0, 250, 0, 450)
InfoFrame.Position = UDim2.new(0, 100, 0, 0)
InfoFrame.Visible = false
InfoFrame.BackgroundTransparency = 1

local InfoText = Instance.new("TextLabel")
InfoText.Parent = InfoFrame
InfoText.Text = "BloodHub v1.1\nby @ws3eqr\n\nChanges:\n- Added Fly\n- Noclip\n- ESP"
InfoText.TextColor3 = Color3.fromRGB(255, 255, 255)

-- 🛠️ Functions Tab
local FunctionsFrame = Instance.new("Frame")
FunctionsFrame.Parent = MainFrame
FunctionsFrame.Size = UDim2.new(0, 250, 0, 450)
FunctionsFrame.Position = UDim2.new(0, 100, 0, 0)
FunctionsFrame.Visible = false

-- 🔘 Fly Toggle
local FlyToggle = Instance.new("TextButton")
FlyToggle.Parent = FunctionsFrame
FlyToggle.Text = "Fly [OFF]"
FlyToggle.Size = UDim2.new(0, 200, 0, 40)
FlyToggle.Position = UDim2.new(0, 25, 0, 20)
FlyToggle.MouseButton1Click:Connect(function()
    Settings.Fly = not Settings.Fly
    FlyToggle.Text = Settings.Fly and "Fly [ON]" or "Fly [OFF]"
end)

-- 🔘 Noclip Toggle
local NoclipToggle = Instance.new("TextButton")
NoclipToggle.Parent = FunctionsFrame
NoclipToggle.Text = "Noclip [OFF]"
NoclipToggle.Size = UDim2.new(0, 200, 0, 40)
NoclipToggle.Position = UDim2.new(0, 25, 0, 70)
NoclipToggle.MouseButton1Click:Connect(function()
    Settings.Noclip = not Settings.Noclip
    NoclipToggle.Text = Settings.Noclip and "Noclip [ON]" or "Noclip [OFF]"
end)

-- 🔄 Super Jump
local SuperJumpToggle = Instance.new("TextButton")
SuperJumpToggle.Parent = FunctionsFrame
SuperJumpToggle.Text = "Super Jump [OFF]"
SuperJumpToggle.Size = UDim2.new(0, 200, 0, 40)
SuperJumpToggle.Position = UDim2.new(0, 25, 0, 120)
SuperJumpToggle.MouseButton1Click:Connect(function()
    Settings.SuperJump = not Settings.SuperJump
    Humanoid.JumpPower = Settings.SuperJump and 100 or 50
    SuperJumpToggle.Text = Settings.SuperJump and "Super Jump [ON]" or "Super Jump [OFF]"
end)

-- 🎚️ Fly Speed Slider
local FlySpeedSlider = Instance.new("TextLabel")
FlySpeedSlider.Parent = FunctionsFrame
FlySpeedSlider.Text = "Fly Speed: " .. Settings.FlySpeed
FlySpeedSlider.Size = UDim2.new(0, 200, 0, 30)
FlySpeedSlider.Position = UDim2.new(0, 25, 0, 180)

local FlySpeedValue = Instance.new("TextBox")
FlySpeedValue.Parent = FunctionsFrame
FlySpeedValue.PlaceholderText = "Speed"
FlySpeedValue.Size = UDim2.new(0, 100, 0, 30)
FlySpeedValue.Position = UDim2.new(0, 25, 0, 210)
FlySpeedValue.Text = tostring(Settings.FlySpeed)
FlySpeedValue.FocusLost:Connect(function()
    Settings.FlySpeed = tonumber(FlySpeedValue.Text) or 50
    FlySpeedSlider.Text = "Fly Speed: " .. Settings.FlySpeed
end)

-- 🌌 Misc Tab
local MiscFrame = Instance.new("Frame")
MiscFrame.Parent = MainFrame
MiscFrame.Size = UDim2.new(0, 250, 0, 450)
MiscFrame.Position = UDim2.new(0, 100, 0, 0)
MiscFrame.Visible = false

-- 🔘 Remove GUI
local RemoveButton = Instance.new("TextButton")
RemoveButton.Parent = MiscFrame
RemoveButton.Text = "Destroy BloodHub"
RemoveButton.Size = UDim2.new(0, 200, 0, 40)
RemoveButton.Position = UDim2.new(0, 25, 0, 20)
RemoveButton.MouseButton1Click:Connect(function()
    BloodHub:Destroy()
end)

-- 🔘 Transparency Slider
local TransparencySlider = Instance.new("TextLabel")
TransparencySlider.Parent = MiscFrame
TransparencySlider.Text = "Transparency: " .. MainFrame.BackgroundTransparency
TransparencySlider.Size = UDim2.new(0, 200, 0, 30)
TransparencySlider.Position = UDim2.new(0, 25, 0, 70)

local TransparencyValue = Instance.new("TextBox")
TransparencyValue.Parent = MiscFrame
TransparencyValue.PlaceholderText = "0-1"
TransparencyValue.Size = UDim2.new(0, 100, 0, 30)
TransparencyValue.Position = UDim2.new(0, 25, 0, 100)
TransparencyValue.Text = tostring(MainFrame.BackgroundTransparency)
TransparencyValue.FocusLost:Connect(function()
    local Value = tonumber(TransparencyValue.Text) or 0.1
    MainFrame.BackgroundTransparency = math.clamp(Value, 0, 1)
    TransparencySlider.Text = "Transparency: " .. MainFrame.BackgroundTransparency
end)

-- 🔄 Tab Switching
InfoTab.MouseButton1Click:Connect(function()
    InfoFrame.Visible = true
    FunctionsFrame.Visible = false
    MiscFrame.Visible = false
end)

FunctionsTab.MouseButton1Click:Connect(function()
    InfoFrame.Visible = false
    FunctionsFrame.Visible = true
    MiscFrame.Visible = false
end)

MiscTab.MouseButton1Click:Connect(function()
    InfoFrame.Visible = false
    FunctionsFrame.Visible = false
    MiscFrame.Visible = true
end)

-- ✈️ Fly Logic
RunService.Stepped:Connect(function()
    if Settings.Fly then
        local Root = Character:FindFirstChild("HumanoidRootPart")
        if Root then
            local FlyDirection = Vector3.new(0, 0, 0)
            if UIS:IsKeyDown(Enum.KeyCode.W) then FlyDirection += Root.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then FlyDirection -= Root.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then FlyDirection -= Root.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then FlyDirection += Root.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then FlyDirection += Vector3.new(0, 1, 0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then FlyDirection += Vector3.new(0, -1, 0) end
            
            FlyDirection = FlyDirection.Unit * Settings.FlySpeed
            Root.Velocity = FlyDirection
            Humanoid:ChangeState(Enum.HumanoidStateType.Flying)
        end
    end
end)

-- 🚷 Noclip Logic
RunService.Stepped:Connect(function()
    if Settings.Noclip and Character then
        for _, Part in pairs(Character:GetDescendants()) do
            if Part:IsA("BasePart") then
                Part.CanCollide = false
            end
        end
    end
end)

-- 💀 Skeleton ESP (Optional)
if Settings.Skeleton then
    -- (Add ESP logic if desired)
end
