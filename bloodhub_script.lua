local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

-- Скрытая инициализация
local function SecureInit()
    local PlayerService = game:GetService("Players")
    local LocalPlayer = PlayerService.LocalPlayer
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    
    return {
        Player = LocalPlayer,
        Character = Character,
        Humanoid = Character:WaitForChild("Humanoid"),
        RootPart = Character:WaitForChild("HumanoidRootPart")
    }
end

local Env = SecureInit()

-- Стелс-меню (появляется по клавише F5)
local function CreateStealthUI()
    local CoreGui = game:GetService("CoreGui")
    for _, obj in ipairs(CoreGui:GetChildren()) do
        if obj:GetAttribute("BloodHubStealth") then
            obj:Destroy()
        end
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Enabled = false
    ScreenGui.DisplayOrder = 100
    ScreenGui:SetAttribute("BloodHubStealth", true)
    ScreenGui.Parent = CoreGui

    -- Псевдо-легальный интерфейс
    local MainFrame = Instance.new("Frame")
    MainFrame.BackgroundTransparency = 0.95
    MainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    MainFrame.Size = UDim2.new(0, 320, 0, 0)
    MainFrame.Position = UDim2.new(0.5, -160, 0, 10)
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    local function ToggleUI()
        ScreenGui.Enabled = not ScreenGui.Enabled
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {
            Size = ScreenGui.Enabled and UDim2.new(0, 320, 0, 400) or UDim2.new(0, 320, 0, 0)
        }):Play()
    end

    game:GetService("UserInputService").InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.F5 then
            ToggleUI()
        end
    end)

    -- Псевдо-заголовок (маскировка под системное уведомление)
    local Notification = Instance.new("TextLabel")
    Notification.Text = "Системное уведомление #"..math.random(1000,9999)
    Notification.TextColor3 = Color3.new(0.7, 0.7, 0.7)
    Notification.Size = UDim2.new(1, 0, 0, 30)
    Notification.BackgroundTransparency = 1
    Notification.Parent = MainFrame

    -- Функции реализованы через легальные коллбеки
    return {
        Toggle = ToggleUI,
        Frame = MainFrame
    }
end

local UI = CreateStealthUI()

-- Антидетектные функции
local function DuplicateTool()
    task.spawn(function()
        local tool = Env.Character:FindFirstChildOfClass("Tool")
        if tool then
            local clone = tool:Clone()
            clone.Parent = Env.Player.Backpack
            
            -- Маскировка под сетевой пакет
            local event = Instance.new("RemoteEvent")
            event.Name = HttpService:GenerateGUID(false)
            event.Parent = game:GetService("ReplicatedStorage")
            event:FireServer("ItemDuplication", tool:GetFullName())
            event:Destroy()
        end
    end)
end

local function HumanoidFly()
    local flyActive = false
    return function()
        flyActive = not flyActive
        if flyActive then
            -- Физический флай без BodyVelocity
            local conn
            conn = game:GetService("RunService").Heartbeat:Connect(function()
                if not flyActive then conn:Disconnect() return end
                Env.RootPart.Velocity = Vector3.new(0, 0, 0)
                Env.RootPart.CFrame = Env.RootPart.CFrame + Vector3.new(0, 0.2, 0)
            end)
        end
    end
end

local function AdvancedNoclip()
    local noclipActive = false
    local conn
    
    local function ProcessDescendants(obj)
        for _, child in ipairs(obj:GetDescendants()) do
            if child:IsA("BasePart") then
                child.CanCollide = not noclipActive
            end
        end
    end

    return function()
        noclipActive = not noclipActive
        if conn then conn:Disconnect() end
        
        if noclipActive then
            ProcessDescendants(Env.Character)
            conn = Env.Character.DescendantAdded:Connect(ProcessDescendants)
        end
    end
end

local function BunnyHop()
    local bhopActive = false
    return function()
        bhopActive = not bhopActive
        while bhopActive do
            if Env.Humanoid.FloorMaterial ~= Enum.Material.Air then
                Env.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                task.wait(0.1)
            end
            task.wait()
        end
    end
end

-- Инициализация через легальное событие
game:GetService("ReplicatedStorage").ChildAdded:Connect(function(child)
    if child.Name == "BloodHub_Init" then
        child:Destroy()
        
        -- Создание скрытых кнопок
        local function AddStealthButton(yPos, text, callback)
            task.spawn(function()
                local btn = Instance.new("TextButton")
                btn.Text = " "
                btn.Size = UDim2.new(0.9, 0, 0, 40)
                btn.Position = UDim2.new(0.05, 0, 0, yPos)
                btn.BackgroundTransparency = 0.95
                btn.Parent = UI.Frame
                
                local label = Instance.new("TextLabel")
                label.Text = text
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.TextColor3 = Color3.new(0.8, 0.8, 0.8)
                label.Parent = btn
                
                btn.MouseButton1Click:Connect(callback)
            end)
        end

        AddStealthButton(40, "Дублировать предмет", DuplicateTool)
        AddStealthButton(90, "Режим полета", HumanoidFly())
        AddStealthButton(140, "Сквозь стены", AdvancedNoclip())
        AddStealthButton(190, "Банни-хоп", BunnyHop())
        AddStealthButton(240, "Скорость ходьбы", function()
            Env.Humanoid.WalkSpeed = 100
        end)
        AddStealthButton(290, "Супер прыжок", function()
            Env.Humanoid.JumpPower = 100
            Env.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end)
        AddStealthButton(340, "Спин-бот", function()
            while true do
                Env.RootPart.CFrame *= CFrame.Angles(0, math.rad(30), 0)
                task.wait()
            end
        end)
    end
end)

-- Скрытая активация
local initSignal = Instance.new("RemoteEvent")
initSignal.Name = "BloodHub_Init"
initSignal.Parent = game:GetService("ReplicatedStorage")
initSignal:FireServer()
initSignal:Destroy()
