-- MM2 ULTIMATE MENU v3.0 [good]
-- Запускай один раз. Все функции активируются через GUI.

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local replicated = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")

-- Создаём главное окно (ScreenGui)
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 480)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
title.Text = "MM2 ULTRA MENU [good]"
title.TextColor3 = Color3.fromRGB(255, 200, 50)
title.TextScaled = true
title.Font = Enum.Font.Bold
title.Parent = mainFrame

-- Контейнер для кнопок
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -40)
scroll.Position = UDim2.new(0, 5, 0, 35)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 0, 600)
scroll.ScrollBarThickness = 6
scroll.Parent = mainFrame

local function createButton(text, callback, yPos, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = color or Color3.fromRGB(60, 60, 80)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.SourceSansBold
    btn.BorderSizePixel = 0
    btn.Parent = scroll
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- [[ 1. Кнопка "Толкнуть" (красная при активации) ]]
local pushActive = false
local pushBtn = createButton("ТОЛКНУТЬ (вкл/выкл)", function()
    pushActive = not pushActive
    pushBtn.BackgroundColor3 = pushActive and Color3.fromRGB(200, 30, 30) or Color3.fromRGB(60, 60, 80)
end, 5)

-- Логика толчка при подходе
game.Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        while char and char:FindFirstChild("HumanoidRootPart") do
            if pushActive and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (char.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if dist < 8 then
                    local vel = Instance.new("BodyVelocity")
                    vel.Velocity = (char.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Unit * 150
                    vel.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                    vel.Parent = char.HumanoidRootPart
                    game:GetService("Debris"):AddItem(vel, 0.3)
                end
            end
            runService.Heartbeat:Wait()
        end
    end)
end)

-- [[ 2. Очистка инвентаря у всех, кто использует скрипт ]]
createButton("ОЧИСТИТЬ ИНВЕНТАРЬ (всі)", function()
    for _, plr in pairs(game.Players:GetPlayers()) do
        local inv = plr:FindFirstChild("Data") or plr:FindFirstChild("Inventory")
        if inv then
            for _, item in pairs(inv:GetChildren()) do
                item:Destroy()
            end
        end
        -- Також чистимо ефекти
        if plr.Character then
            for _, obj in pairs(plr.Character:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Attachment") or obj:IsA("Accessory") then
                    obj:Destroy()
                end
            end
        end
    end
end, 50)

-- [[ 3. Показувати вбивцю та шерифа ]]
createButton("ПОКАЗАТИ РОЛІ", function()
    for _, plr in pairs(game.Players:GetPlayers()) do
        local role = plr:FindFirstChild("Role") or plr:FindFirstChild("Team")
        if role then
            local name = role.Value or role.Name
            if name == "Murderer" or name == "Sheriff" then
                local bill = Instance.new("BillboardGui")
                bill.Size = UDim2.new(0, 100, 0, 30)
                bill.Adornee = plr.Character and plr.Character:FindFirstChild("Head")
                local label = Instance.new("TextLabel", bill)
                label.Size = UDim2.new(1, 0, 1, 0)
                label.Text = name:upper()
                label.TextColor3 = name == "Murderer" and Color3.fromRGB(255,0,0) or Color3.fromRGB(0,200,255)
                label.BackgroundTransparency = 1
                bill.Parent = plr.Character
            end
        end
    end
end, 95)

-- [[ 4. Безсмертя ]]
createButton("БЕЗСМЕРТЯ (вкл)", function()
    player.Character.Humanoid.MaxHealth = math.huge
    player.Character.Humanoid.Health = math.huge
    player.Character:BreakJointsOnDeath = false
end, 140)

-- [[ 5. Повзунок швидкості до 100 ]]
local speedLabel = Instance.new("TextLabel", scroll)
speedLabel.Size = UDim2.new(0.9, 0, 0, 20)
speedLabel.Position = UDim2.new(0.05, 0, 0, 185)
speedLabel.Text = "ШВИДКІСТЬ: 16"
speedLabel.TextColor3 = Color3.fromRGB(255,255,255)
speedLabel.BackgroundTransparency = 1
speedLabel.TextScaled = true

local speedSlider = Instance.new("TextBox", scroll)
speedSlider.Size = UDim2.new(0.7, 0, 0, 25)
speedSlider.Position = UDim2.new(0.15, 0, 0, 210)
speedSlider.BackgroundColor3 = Color3.fromRGB(80,80,100)
speedSlider.Text = "16"
speedSlider.TextColor3 = Color3.fromRGB(255,255,255)
speedSlider.ClearTextOnFocus = false
speedSlider.Parent = scroll

speedSlider.FocusLost:Connect(function()
    local val = tonumber(speedSlider.Text)
    if val and val >= 1 and val <= 100 then
        player.Character.Humanoid.WalkSpeed = val
        speedLabel.Text = "ШВИДКІСТЬ: " .. val
    else
        speedSlider.Text = "16"
    end
end)

-- [[ 6. Політ ]]
local flyActive = false
createButton("ПОЛІТ (вкл/викл)", function()
    flyActive = not flyActive
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if flyActive and hrp then
        local bv = Instance.new("BodyVelocity")
        bv.Velocity = Vector3.new(0, 10, 0)
        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bv.Parent = hrp
        runService.RenderStepped:Connect(function()
            if flyActive and bv.Parent then
                bv.Velocity = Vector3.new(0, 10, 0) + (mouse.Hit.Position - hrp.Position).Unit * 20
            end
        end)
    end
end, 260)

-- [[ 7. Збирати монетки по карті ]]
createButton("АВТО-ЗБІР МОНЕТ", function()
    for _, coin in pairs(workspace:GetDescendants()) do
        if coin.Name:lower():find("coin") or coin:IsA("Part") and coin.BrickColor == BrickColor.Yellow() then
            coin.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-2)
            wait(0.05)
        end
    end
end, 310)

-- [[ 8. Вбивати всіх незалежно від ролей (вбивця/шериф вбивають всіх) ]]
createButton("ВБИВАТИ ВСІХ (режим)", function()
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("Humanoid") then
            plr.Character.Humanoid.Health = 0
        end
    end
end, 360)

-- [[ 9. Приховати GUI ]]
createButton("ЗГОРНУТИ", function()
    mainFrame.Visible = not mainFrame.Visible
end, 410)

print("[good] Меню завантажено. Використовуй кнопки.")
