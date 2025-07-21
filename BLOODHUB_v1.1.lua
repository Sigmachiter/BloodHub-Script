--// BLOODHUB v1.1 | Author: ws3eqr

local uis = game:GetService("UserInputService")
local plrs = game:GetService("Players")
local rs = game:GetService("RunService")
local lp = plrs.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()

pcall(function() game.CoreGui.BLOODHUB:Destroy() end)

local sg = Instance.new("ScreenGui", game.CoreGui)
sg.Name = "BLOODHUB"
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 520, 0, 360)
main.Position = UDim2.new(0.5, -260, 0.5, -180)
main.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
main.BorderSizePixel = 0
main.Visible = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)
Instance.new("UIGradient", main).Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 0, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 0, 0))
}

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "BLOODHUB v1.1"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.new(1, 0, 0)
title.BackgroundTransparency = 1

-- Toggle GUI
local guiVisible = true
uis.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.RightControl then
		guiVisible = not guiVisible
		sg.Enabled = guiVisible
	end
end)

-- Tabs
local tabs = Instance.new("Frame", main)
tabs.Size = UDim2.new(0, 160, 1, -40)
tabs.Position = UDim2.new(0, 0, 0, 40)
tabs.BackgroundTransparency = 1

local function createButton(name, y, callback)
	local b = Instance.new("TextButton", tabs)
	b.Size = UDim2.new(1, -10, 0, 30)
	b.Position = UDim2.new(0, 5, 0, y)
	b.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
	b.Font = Enum.Font.Gotham
	b.TextColor3 = Color3.new(1, 1, 1)
	b.TextSize = 16
	b.Text = name
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
	b.MouseButton1Click:Connect(callback)
end

-- Feature States
local flying = false
local flySpeed = 2
local noclip = false
local flyBV = nil

-- Info
createButton("Info", 0, function()
	print("BLOODHUB v1.1 by ws3eqr")
end)

-- Fly with toggle and speed slider
createButton("Fly (Toggle)", 35, function()
	flying = not flying
	if flying then
		if not flyBV then
			flyBV = Instance.new("BodyVelocity")
			flyBV.MaxForce = Vector3.new(1e5, 1e5, 1e5)
			flyBV.Parent = char:WaitForChild("HumanoidRootPart")
		end
		rs:BindToRenderStep("FlyControl", Enum.RenderPriority.Character.Value, function()
			if flying and flyBV then
				local dir = Vector3.zero
				if uis:IsKeyDown(Enum.KeyCode.W) then dir += lp:GetMouse().Hit.LookVector end
				if uis:IsKeyDown(Enum.KeyCode.S) then dir -= lp:GetMouse().Hit.LookVector end
				if uis:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
				if uis:IsKeyDown(Enum.KeyCode.LeftShift) then dir -= Vector3.new(0,1,0) end
				flyBV.Velocity = dir.Unit * flySpeed
			end
		end)
	else
		rs:UnbindFromRenderStep("FlyControl")
		if flyBV then flyBV:Destroy() flyBV = nil end
	end
end)

-- Noclip toggle
createButton("Noclip (Toggle)", 70, function()
	noclip = not noclip
	rs.Stepped:Connect(function()
		if noclip and char then
			for _, p in pairs(char:GetDescendants()) do
				if p:IsA("BasePart") then p.CanCollide = false end
			end
		end
	end)
end)

-- Dupe
createButton("Dupe Item", 105, function()
	for _, i in pairs(lp.Backpack:GetChildren()) do
		local c = i:Clone()
		c.Parent = lp.Backpack
	end
end)

-- FOV
createButton("Set FOV", 140, function()
	workspace.CurrentCamera.FieldOfView = 120
end)

-- Speed Toggle
local speedEnabled = false
createButton("Speedhack", 175, function()
	speedEnabled = not speedEnabled
	char:WaitForChild("Humanoid").WalkSpeed = speedEnabled and 50 or 16
end)

-- Super Jump Toggle
local jumpEnabled = false
createButton("Super Jump", 210, function()
	jumpEnabled = not jumpEnabled
	char:WaitForChild("Humanoid").JumpPower = jumpEnabled and 90 or 50
end)

-- MISC
createButton("MISC / Transparency", 245, function()
	main.BackgroundTransparency = 0.3
end)

-- Fly Speed Slider (basic)
local flySlider = Instance.new("TextBox", main)
flySlider.Size = UDim2.new(0, 200, 0, 30)
flySlider.Position = UDim2.new(0, 170, 0, 40)
flySlider.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
flySlider.PlaceholderText = "Fly Speed (e.g. 5)"
flySlider.Text = ""
flySlider.Font = Enum.Font.Gotham
flySlider.TextColor3 = Color3.new(1,1,1)
flySlider.TextSize = 16
Instance.new("UICorner", flySlider).CornerRadius = UDim.new(0, 6)

flySlider.FocusLost:Connect(function()
	local val = tonumber(flySlider.Text)
	if val and val >= 1 and val <= 100 then
		flySpeed = val
		flySlider.PlaceholderText = "Fly Speed set to " .. tostring(val)
	else
		flySlider.Text = ""
	end
end)
