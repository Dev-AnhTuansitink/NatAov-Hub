local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local Enemies = workspace:FindFirstChild("Enemies")
local request_fn =
    (syn and syn.request)
    or (http and http.request)
    or http_request
    or request

local API = {
    url = "https://dichvugay.onrender.com",
    id = "c078ed5af69e",
    key = "db9b305d3c14581563487432ee6fda0cec71d4a667776e4a340bddb5a8de0436"
}

local active = {}
local sentFruit = {}

local function getFruit()
    for _,v in next, workspace:GetChildren() do
        if (v:IsA("Model") or v:IsA("Tool"))
        and v.Name:find("Fruit")
        and v.Parent
        and v:FindFirstChild("Handle") then
            return v
        end
    end
end

local function getSea()
    local id = game.PlaceId

    if id == 2753915549 or id == 85211729168715 then return 1 end
    if id == 4442272183 or id == 79091703265657 then return 2 end
    if id == 7449423635 or id == 100117331123089 then return 3 end

    return 0
end

local function send(name)
    pcall(function()
        request_fn({
            Url = API.url .. "/push",
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({
                boss = name,
                job = game.JobId,
                players = #Players:GetPlayers(),
                sea = getSea(),
                t = DateTime.now().UnixTimestampMillis
            })
        })
    end)
end

local function check(name,cond)
    local ok = false
    pcall(function() ok = cond() end)

    if ok then
        if not active[name] then
            active[name] = true
            send(name)
        end
    else
        active[name] = nil
    end
end

local function enemy(name)
    return function()
        return RS:FindFirstChild(name)
            or (Enemies and Enemies:FindFirstChild(name))
    end
end

task.spawn(function()
    while task.wait(5) do

        local sea = getSea()
        
        -- SỰ KIỆN SEA 2
        if sea == 2 then
            check("Darkbeard", enemy("Darkbeard"))
            check("CursedCaptain", enemy("Cursed Captain"))
            
            check("Factory", function()
                local currentEnemies = workspace:FindFirstChild("Enemies")
                if currentEnemies then
                    local core = currentEnemies:FindFirstChild("Core")
                    if core and core:FindFirstChild("Humanoid") and core.Humanoid.Health > 0 then
                        return true
                    end
                end
                return false
            end)

            local swordNames = {"Shisui", "Saddi", "Wando"} 
            local f = RS.Remotes.CommF_
            for i = 1, 3 do
                local swordName = swordNames[i]
                check(swordName, function()
                    local ok, res = pcall(f.InvokeServer, f, "LegendarySwordDealer", tostring(i))
                    return ok and res
                end)
            end
        end
        
        -- SỰ KIỆN SEA 3
        if sea == 3 then
            check("CakeQueen", enemy("Cake Queen"))
            check("RipIndra", enemy("Rip Indra"))
            check("DoughKing", enemy("Dough King"))
            check("CakePrince", enemy("Cake Prince"))
            
            check("PirateRaid", function()
                local CHECK_CENTER = Vector3.new(-5556.43, 314.08, -2972.08)
                local CHECK_RADIUS = 500
                local currentEnemies = workspace:FindFirstChild("Enemies")
                
                if currentEnemies then
                    for _, mob in pairs(currentEnemies:GetChildren()) do
                        if mob:IsA("Model") and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") then
                            if mob.Humanoid.Health > 0 then
                                local distanceToCenter = (mob.HumanoidRootPart.Position - CHECK_CENTER).Magnitude
                                if distanceToCenter <= CHECK_RADIUS then
                                    return true
                                end
                            end
                        end
                    end
                end
                return false
            end)

            do
                local ok, res = pcall(function()
                    return RS.Remotes.CommF_:InvokeServer("CakePrinceSpawner")
                end)
                if ok and res then
                    local len = string.len(res)
                    local killStr
                    if len == 88 then killStr = string.sub(res, 39, 41)
                    elseif len == 87 then killStr = string.sub(res, 39, 40)
                    elseif len == 86 then killStr = string.sub(res, 39, 39)
                    end
                    local killCount = tonumber(killStr)
                    if killCount and killCount <= 50 then
                        send("NearCakePrince")
                    end
                end
            end
            
            check("TyrantOfTheSkies", enemy("Tyrant of the Skies"))
            check("SoulReaper", enemy("Soul Reaper"))
            
            check("ElitePirate", function()
                local elite =
                    RS:FindFirstChild("Diablo")
                    or RS:FindFirstChild("Deandre")
                    or RS:FindFirstChild("Urban")
                    or (Enemies and Enemies:FindFirstChild("Diablo"))
                    or (Enemies and Enemies:FindFirstChild("Deandre"))
                    or (Enemies and Enemies:FindFirstChild("Urban"))

                if elite then
                    return true
                end

                return false
            end)

            local loc = workspace:FindFirstChild("_WorldOrigin")
            loc = loc and loc:FindFirstChild("Locations")

            if loc then
                check("MirageIsland", function()
                    return loc:FindFirstChild("Mirage Island")
                end)

                check("KitsuneIsland", function()
                    return loc:FindFirstChild("Kitsune Island")
                end)

                check("PrehistoricIsland", function()
                    return loc:FindFirstChild("Prehistoric Island")
                end)
            end

            local sky = Lighting:FindFirstChild("Sky")
            if sky then
                local moon = sky.MoonTextureId

                check("FullMoon", function()
                    return moon == "http://www.roblox.com/asset/?id=9709149431"
                end)

                check("NearFullMoon", function()
                    return moon == "http://www.roblox.com/asset/?id=9709149052"
                end)
            end
        end
        
        -- SỰ KIỆN CHUNG (FRUIT TRÁI ÁC QUỶ)
        local f = getFruit()
        if f and not sentFruit[f] then
            sentFruit[f] = true
            send("fruit") -- Đã đổi từ "SpawnedFruit" sang "fruit"
        end
    end
end)
