--// BLOODHUB v1.0 | Author: ws3eqr

local uis = game:GetService("UserInputService")
local plrs = game:GetService("Players")
local lp = plrs.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()

pcall(function() game.CoreGui.BLOODHUB:Destroy() end)

local sg = Instance.new("ScreenGui", game.CoreGui)
sg.Name = "BLOODHUB"
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 500, 0, 320)
main.Position = UDim2.new(0.5, -250, 0.5, -160)
main.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
main.BorderSizePixel = 0
main.Visible = true

local uiCorner = Instance.new("UICorner", main)
uiCorner.CornerRadius = UDim.new(0, 12)

local grad = Instance.new("UIGradient", main)
grad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 0, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 0, 0))
}

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "BLOODHUB v1.0"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.new(1, 0, 0)
title.BackgroundTransparency = 1

-- Toggle GUI with RightControl
local guiVisible = true
uis.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.RightControl then
		guiVisible = not guiVisible
		sg.Enabled = guiVisible
	end
end)

-- Tabs + functionality
local tabs = Instance.new("Frame", main)
tabs.Size = UDim2.new(0, 150, 1, -40)
tabs.Position = UDim2.new(0, 0, 0, 40)
tabs.BackgroundTransparency = 1

local function createButton(name, yPos, callback)
	local btn = Instance.new("TextButton", tabs)
	btn.Size = UDim2.new(1, -10, 0, 30)
	btn.Position = UDim2.new(0, 5, 0, yPos)
	btn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
	btn.Font = Enum.Font.Gotham
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.TextSize = 16
	btn.Text = name
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	btn.MouseButton1Click:Connect(callback)
end

-- Function Implementations
createButton("Info", 0, function()
	print("BLOODHUB loaded. Author: ws3eqr. Version: 1.0.")
end)

createButton("Fly", 35, function()
	local flying = false
	local speed = 2
	local bv = Instance.new("BodyVelocity")
	bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
	bv.Velocity = Vector3.zero
	bv.Parent = char:WaitForChild("HumanoidRootPart")

	flying = true
	game:GetService("RunService").RenderStepped:Connect(function()
		if flying then
			local moveVec = Vector3.zero
			if uis:IsKeyDown(Enum.KeyCode.W) then moveVec += lp:GetMouse().Hit.LookVector end
			if uis:IsKeyDown(Enum.KeyCode.S) then moveVec -= lp:GetMouse().Hit.LookVector end
			bv.Velocity = moveVec.Unit * speed
		end
	end)
end)

createButton("Noclip", 70, function()
	local nc = true
	game:GetService("RunService").Stepped:Connect(function()
		if nc and char then
			for _, part in pairs(char:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
		end
	end)
end)

createButton("Dupe", 105, function()
	for _, item in pairs(lp.Backpack:GetChildren()) do
		local clone = item:Clone()
		clone.Parent = lp.Backpack
	end
end)

createButton("FOV", 140, function()
	local fov = 120
	game.Workspace.CurrentCamera.FieldOfView = fov
end)

createButton("Speedhack", 175, function()
	char:WaitForChild("Humanoid").WalkSpeed = 50
end)

createButton("Super Jump", 210, function()
	char:WaitForChild("Humanoid").JumpPower = 90
end)

createButton("MISC", 245, function()
	main.BackgroundTransparency = 0.3
end)
