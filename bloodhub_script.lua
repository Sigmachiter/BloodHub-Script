```lua
--// BLOODHUB v1.0 | Author: ws3eqr

local uis = game:GetService("UserInputService")
local plrs = game:GetService("Players")
local lp = plrs.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()

pcall(function() game.CoreGui.BLOODHUB:Destroy() end)

local sg = Instance.new("ScreenGui", game.CoreGui)
sg.Name = "BLOODHUB"
sg.ResetOnSpawn = false

local guiVisible = true
uis.InputBegan:Connect(function(i,g)
	if g then return end
	if i.KeyCode == Enum.KeyCode.RightControl then
		guiVisible = not guiVisible
		sg.Enabled = guiVisible
	end
end)

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 470, 0, 320)
frame.Position = UDim2.new(0.5, -235, 0.5, -160)
frame.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local grad = Instance.new("UIGradient", frame)
grad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(90,0,0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(10,0,0))
}
grad.Rotation = 45

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "BLOODHUB v1.0"
title.TextColor3 = Color3.fromRGB(255, 0, 0)
title.TextSize = 22
title.Font = Enum.Font.GothamBlack
title.BackgroundTransparency = 1

local tabNames = {"Information", "Functions", "MISC"}
local tabButtons, tabFrames = {}, {}
local currentTab = nil

local function createTabButton(name, i)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(0, 130, 0, 30)
	b.Position = UDim2.new(0, 10 + ((i - 1) * 150), 0, 45)
	b.BackgroundColor3 = Color3.fromRGB(50,0,0)
	b.Text = name
	b.Font = Enum.Font.Gotham
	b.TextSize = 16
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
	tabButtons[name] = b
	return b
end

local function createTabFrame(name)
	local f = Instance.new("Frame", frame)
	f.Size = UDim2.new(1, -20, 1, -90)
	f.Position = UDim2.new(0, 10, 0, 85)
	f.BackgroundTransparency = 1
	f.Visible = false
	tabFrames[name] = f
	return f
end

local function switchTab(name)
	for t,f in pairs(tabFrames) do f.Visible = false end
	if tabFrames[name] then tabFrames[name].Visible = true end
end

for i, name in ipairs(tabNames) do
	local b = createTabButton(name, i)
	local f = createTabFrame(name)
	b.MouseButton1Click:Connect(function() switchTab(name) end)
end

do
	local info = tabFrames["Information"]
	local l = Instance.new("TextLabel", info)
	l.Size = UDim2.new(1, 0, 1, 0)
	l.Text = "BLOODHUB v1.0\nAuthor: ws3eqr\n\nPatch Notes:\n- Initial UI\n- Added all features\n- Blood gradient style"
	l.TextWrapped = true
	l.TextYAlignment = Enum.TextYAlignment.Top
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.Font = Enum.Font.Gotham
	l.TextSize = 16
	l.TextColor3 = Color3.new(1,1,1)
	l.BackgroundTransparency = 1
end

do
	local misc = tabFrames["MISC"]

	local transp = Instance.new("TextButton", misc)
	transp.Size = UDim2.new(0, 200, 0, 30)
	transp.Position = UDim2.new(0, 10, 0, 10)
	transp.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
	transp.Text = "Menu Transparency"
	transp.TextColor3 = Color3.new(1, 1, 1)
	transp.Font = Enum.Font.Gotham
	transp.TextSize = 14
	Instance.new("UICorner", transp).CornerRadius = UDim.new(0, 8)

	transp.MouseButton1Click:Connect(function()
		frame.BackgroundTransparency = frame.BackgroundTransparency == 0 and 0.4 or 0
	end)

	local disable = Instance.new("TextButton", misc)
	disable.Size = UDim2.new(0, 200, 0, 30)
	disable.Position = UDim2.new(0, 10, 0, 50)
	disable.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
	disable.Text = "Disable BLOODHUB"
	disable.TextColor3 = Color3.new(1, 1, 1)
	disable.Font = Enum.Font.Gotham
	disable.TextSize = 14
	Instance.new("UICorner", disable).CornerRadius = UDim.new(0, 8)

	disable.MouseButton1Click:Connect(function()
		sg:Destroy()
	end)
end

local function createButton(parent, txt, pos, callback)
	local btn = Instance.new("TextButton", parent)
	btn.Size = UDim2.new(0, 200, 0, 30)
	btn.Position = pos
	btn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
	btn.Text = txt
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	btn.MouseButton1Click:Connect(callback)
	return btn
end

do
	local funcs = tabFrames["Functions"]
	local y = 10

	local flying = false
	local flySpeed = 50
	local flyGui = nil

	local function FlyFunction()
		if not flying then
			flying = true
			local bp = Instance.new("BodyPosition")
			bp.MaxForce = Vector3.new(1e5, 1e5, 1e5)
			bp.P = 1e4
			bp.Position = char.HumanoidRootPart.Position
			bp.Parent = char.HumanoidRootPart

			local bv = Instance.new("BodyGyro", char.HumanoidRootPart)
			bv.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
			bv.P = 1e4
			bv.CFrame = char.HumanoidRootPart.CFrame

			local conn
			conn = game:GetService("RunService").RenderStepped:Connect(function()
				local cam = workspace.CurrentCamera
				local dir = Vector3.new()
				if uis:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
				if uis:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
				if uis:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
				if uis:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
				bp.Position = char.HumanoidRootPart.Position + dir.Unit * flySpeed
				bv.CFrame = cam.CFrame
			end)

			local flyMenu = Instance.new("TextBox", funcs)
			flyMenu.PlaceholderText = "Fly Speed (default 50)"
			flyMenu.Size = UDim2.new(0, 200, 0, 30)
			flyMenu.Position = UDim2.new(0, 230, 0, y)
			flyMenu.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
			flyMenu.TextColor3 = Color3.new(1, 1, 1)
			flyMenu.Font = Enum.Font.Gotham
			flyMenu.TextSize = 14
			Instance.new("UICorner", flyMenu).CornerRadius = UDim.new(0, 8)
			flyGui = flyMenu

			flyMenu.FocusLost:Connect(function()
				local val = tonumber(flyMenu.Text)
				if val then flySpeed = math.clamp(val, 1, 300) end
			end)

			return function()
				conn:Disconnect()
				bp:Destroy()
				bv:Destroy()
				flying = false
				if flyGui then flyGui:Destroy() end
			end
		end
	end

	local stopFly = nil
	createButton(funcs, "Toggle Fly", UDim2.new(0, 10, 0, y), function()
		if flying then
			if stopFly then stopFly() end
		else
			stopFly = FlyFunction()
		end
	end)
	y += 40

	local noclip = false
	local noclipConn = nil
	createButton(funcs, "Toggle Noclip", UDim2.new(0, 10, 0, y), function()
		noclip = not noclip
		if noclip then
			noclipConn = game:GetService("RunService").Stepped:Connect(function()
				for _, part in ipairs(char:GetDescendants()) do
					if part:IsA("BasePart") then part.CanCollide = false end
				end
			end)
		elseif noclipConn then
			noclipConn:Disconnect()
			noclipConn = nil
			for _, part in ipairs(char:GetDescendants()) do
				if part:IsA("BasePart") then part.CanCollide = true end
			end
		end
	end)
	y += 40

	createButton(funcs, "Visual Dupe Item", UDim2.new(0, 10, 0, y), function()
		local tool = lp.Character:FindFirstChildOfClass("Tool")
		if tool then
			local clone = tool:Clone()
			clone.Parent = lp.Backpack
		end
	end)
	y += 40

	createButton(funcs, "Set FOV", UDim2.new(0, 10, 0, y), function()
		local val = tonumber(game:GetService("StarterGui"):PromptInput("Enter FOV:"))
		if val then
			workspace.CurrentCamera.FieldOfView = val
		end
	end)
	y += 40

	createButton(funcs, "Set WalkSpeed", UDim2.new(0, 10, 0, y), function()
		local val = tonumber(game:GetService("StarterGui"):PromptInput("Speed 0-100:"))
		if val then
			char.Humanoid.WalkSpeed = math.clamp(val, 0, 100)
		end
	end)
	y += 40

	createButton(funcs, "Set Super Jump", UDim2.new(0, 10, 0, y), function()
		char.Humanoid.JumpPower = 75
	end)
end

switchTab("Information")
```
