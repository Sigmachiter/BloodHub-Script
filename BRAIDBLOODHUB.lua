--[[ 
    BRAIDBLOODHUB – Невидимый "лифт" для Roblox
    📌 Быстрое и незаметное перемещение игрока вверх/вниз
    🚫 Без следов: не меняет физику, не вызывает подозрений
--]]

-- 📁 ServerScript: размести в ServerScriptService
local liftEvent = game:GetService("ReplicatedStorage"):WaitForChild("LiftRequest")
local LIFT_DISTANCE = 25 -- Высота телепорта (в студах)

liftEvent.OnServerEvent:Connect(function(player, goUp)
    local character = player.Character
    if not character then return end

    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local direction = goUp and 1 or -1
    local targetPosition = hrp.Position + Vector3.new(0, direction * LIFT_DISTANCE, 0)

    -- Мгновенный телепорт без физики
    hrp.CFrame = CFrame.new(targetPosition)
end)

-- 📁 LocalScript: помести в StarterGui > ScreenGui > LiftButton
-- Кнопка GUI, отправляющая команду на сервер
-- Минимальный и чистый код

-- Client Side
local button = script.Parent
local event = game:GetService("ReplicatedStorage"):WaitForChild("LiftRequest")
local state = false

button.Text = "Подняться"

button.MouseButton1Click:Connect(function()
    state = not state
    event:FireServer(state)
    button.Text = state and "Спуститься" or "Подняться"
end)
