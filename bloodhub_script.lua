-- BloodHub v2.0 by @ws3eqr | Port Computer
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Marketplace = game:GetService("MarketplaceService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- UI Library
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/wally-rblx/universal-ui/main/library.lua"))()
local mainWindow = library:CreateWindow({
    Name = "BloodHub",
    Theme = {
        Background = Color3.fromRGB(15, 15, 15),
        Accent = Color3.fromRGB(255, 40, 40),
        TextColor = Color3.white,
        RoundedCorners = true,
        Gradient = {
            Enabled = true,
            Start = Color3.fromRGB(150, 0, 0),
            End = Color3.fromRGB(50, 0, 0)
        }
    }
})

-- Tabs
local UpdateTab = mainWindow:CreateTab("Update")
local MiscTab = mainWindow:CreateTab("Misc")
local DupeTab = mainWindow:CreateTab("Dupe")
local ESPTab = mainWindow:CreateTab("ESP") -- Новая вкладка
local VisualTab = mainWindow:CreateTab("Visual") -- Новая вкладка

-- Update Logs
UpdateTab:AddLabel("v2.0 - Major Update")
UpdateTab:AddLabel("- Added ESP System")
UpdateTab:AddLabel("- Added Visual Effects")

-- Fly & Noclip (из прошлой версии)
local flyEnabled = false
local flySpeed = 50
local noclipEnabled = false
local noclipConnection = nil

-- Spinner (из прошлой версии)
local spinnerEnabled = false
local spinnerSpeed = 1
local spinnerConnection = nil

-- Dupe (из прошлой версии)
local dupeCooldown = false

-- ESP Variables
local espEnabled = false
local espBoxes = {}
local distanceEnabled = false
local playersInRange = 0

-- Visual Variables
local deepseekItems = {
    102611803,  -- Dominus
    74467790,   -- Valkyrie Helm
    231744729,  -- Korblox
    376957819,  -- Headless
    156744452,  -- Sparkle Time
    484742933,  -- Ice Crown
    251857542,  -- Golden Crown
    193742955,  -- Purple Valk
    263610220,  -- Red Sparkle
    188630135,  -- Dominus Frigidus
    70322343,   -- Dominus Empyreus
    1081583,    -- Classic Fedora
    15351339,   -- Dominus Messor
    1222136,    -- Dominus Astra
    212649529,  -- Dominus Inferno
    253530456,  -- Dominus Vespertilio
    284304405,  -- Dominus Noctis
    310252533,  -- Dominus Empyreus
    74467790,   -- Valkyrie Helm
    376957819   -- Headless
}

-- ESP Functions
local function CreateESPBox(targetPlayer)
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Color3.new(1, 0, 0)
    box.Thickness = 2
    box.Filled = false
    espBoxes[targetPlayer] = box

    local function UpdateESP()
        if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            box.Visible = false
            return
        end
        
        local rootPos = targetPlayer.Character.HumanoidRootPart.Position
        local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(rootPos)
        
        if onScreen then
            box.Size = Vector2.new(100, 200)
            box.Position = Vector2.new(screenPos.X - 50, screenPos.Y - 100)
            box.Visible = espEnabled
            
            if distanceEnabled then
                local distance = (rootPart.Position - rootPos).Magnitude
                local distanceText = string.format("%.1f m", distance)
                box.Text = distanceText
            end
        else
            box.Visible = false
        end
    end

    RunService.Heartbeat:Connect(UpdateESP)
end

local function UpdatePlayersInRange()
    playersInRange = 0
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer ~= player and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (rootPart.Position - targetPlayer.Character.HumanoidRootPart.Position).Magnitude
            if distance <= 50 then
                playersInRange = playersInRange + 1
            end
        end
    end
end

-- Visual Functions
local function SpoofItem(itemId)
    local success, itemInfo = pcall(function()
        return Marketplace:GetProductInfo(itemId)
    end)
    
    if success then
        local fakeItem = Instance.new("Part")
        fakeItem.Name = itemInfo.Name
        fakeItem.Size = Vector3.new(2, 2, 2)
        fakeItem.Position = rootPart.Position + Vector3.new(0, 5, -5)
        fakeItem.Anchored = true
        fakeItem.CanCollide = false
        fakeItem.Parent = workspace
        
        local decal = Instance.new("Decal")
        decal.Texture = "rbxassetid://" .. tostring(itemId)
        decal.Face = "Front"
        decal.Parent = fakeItem
        
        task.wait(5)
        fakeItem:Destroy()
    end
end

-- ESP Toggles
ESPTab:AddToggle("ESP Boxes", false, function(state)
    espEnabled = state
    for _, box in pairs(espBoxes) do
        box.Visible = state
    end
end)

ESPTab:AddToggle("Show Distance", false, function(state)
    distanceEnabled = state
end)

ESPTab:AddLabel("Players in 50m: " .. playersInRange)

-- Visual Functions
VisualTab:AddButton("Random Limited", function()
    local randomItem = deepseekItems[math.random(1, #deepseekItems)]
    SpoofItem(randomItem)
end)

VisualTab:AddButton("Spawn Korblox", function()
    SpoofItem(231744729) -- Korblox
end)

VisualTab:AddButton("Spawn Headless", function()
    SpoofItem(376957819) -- Headless
end)

-- Auto-ESP for all players
Players.PlayerAdded:Connect(function(targetPlayer)
    targetPlayer.CharacterAdded:Connect(function()
        CreateESPBox(targetPlayer)
    end)
end)

for _, targetPlayer in ipairs(Players:GetPlayers()) do
    if targetPlayer ~= player then
        CreateESPBox(targetPlayer)
    end
end

-- Update player count every 5 sec
while true do
    UpdatePlayersInRange()
    task.wait(5)
end

-- Footer
mainWindow:AddFooter("BloodHub v2.0 by @ws3eqr | Port Computer")
