-- ============================================================
--  BLOX Gank Server Monitor  |  Discord: @bloxgank
-- ============================================================

local HttpService        = game:GetService("HttpService")
local Players            = game:GetService("Players")
local TextChatService    = game:GetService("TextChatService")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")
local CoreGui            = game:GetService("CoreGui")
local TweenService       = game:GetService("TweenService")

local WEBHOOK_URL    = ""
local WEBHOOK_STATS  = ""
local WEBHOOK_FISH   = ""
local WEBHOOK_EVENT  = ""
local WEBHOOK_AVATAR = ""
local PROXY          = "https://square-haze-a007.remediashop.workers.dev"
local SCRIPT_ACTIVE  = false

local EVENT_COOLDOWN_SECONDS = 120
local ROLE_NELAYAN_ID        = "1465243405591380023"

local BRAND_NAME        = "BLOX GANK"
local BRAND_ICON        = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/blox%20logo.png"
local BRAND_FOOTER_TEXT = "BLOX GANK • Server Monitor"

local TierColors = {
    Secret    = 1752220,
    Forgotten = 15263976,
    Ruby      = 16753920,
    Legendary = 3407871,
    Mutasi    = 16776960,
    Join      = 65280,
    Leave     = 16729344,
    NotBack   = 16711680,
}

local EMOJI_NOTIF     = "<a:notif:1517730648545034390>"
local EMOJI_SEPARATOR = "<a:arrow:1517730055323652106>"
local EMOJI_STARTER   = "<a:mancing:1517730589091041433>"
local EMOJI_FORGOTTEN = "<a:wiu:1517740584763265094>"
local EMOJI_MUTASI    = "<a:mutasi:1517730565225447616>"
local EMOJI_RUBY      = "<a:ruby:1517740619794092153>"
local EMOJI_LEGENDARY = "<a:apiijo:1517778951223902239>"
local EMOJI_TREASURE  = "<a:treasure:1517740647119847516>"
local EMOJI_MEGALODON = "<a:megablink:1517740677814030437>"
local EMOJI_THUNDER   = "<a:thunder:1517730620250390589>"
local EMOJI_CRYSTAL   = "<a:ruby:1517740619794092153>"
local EMOJI_EVENTTAG  = "📢"
local EMOJI_JOIN      = "<a:join:1517738095917924372>"
local EMOJI_LEAVE     = "<a:leave:1517738147914711190>"
local EMOJI_NOTBACK   = "<a:jam:1517740557445894194>"
local EMOJI_SERVER    = "<a:muter:1517778915836563596>"
local SEP = EMOJI_SEPARATOR

-- ============================================================
--  DATABASE
-- ============================================================

local SecretFishList = {
    "Crystal Crab", "Orca", "Zombie Shark", "Zombie Megalodon", "Dead Zombie Shark",
    "Blob Shark", "Ghost Shark", "Skeleton Narwhal", "Ghost Worm Fish", "Worm Fish",
    "Megalodon", "1x1x1x1 Comet Shark", "Bloodmoon Whale", "Lochness Monster",
    "Monster Shark", "Eerie Shark", "Great Whale", "Frostborn Shark", "Thin Armor Shark",
    "Scare", "Queen Crab", "King Crab", "Cryoshade Glider", "Panther Eel",
    "Giant Squid", "Depthseeker Ray", "Robot Kraken", "Mosasaur Shark", "King Jelly",
    "Bone Whale", "Elshark Gran Maja", "Elpirate Gran Maja", "Ancient Whale",
    "Gladiator Shark", "Ancient Lochness Monster", "Talon Serpent", "Hacker Shark",
    "ElRetro Gran Maja", "Strawberry Choc Megalodon", "Krampus Shark",
    "Emerald Winter Whale", "Winter Frost Shark", "Icebreaker Whale", "Leviathan",
    "Pirate Megalodon", "Viridis Lurker", "Cursed Kraken", "Ancient Magma Whale",
    "Rainbow Comet Shark", "Love Nessie", "Broken Heart Nessie",
    "Mutant Runic Koi", "Ketupat Whale", "Cosmic Mutant Shark", "Strawberry Orca",
    "Bonemaw Tyrant", "Deepsea Monster Axolotl", "Blocky Lochness Monster", "Aurelion",
    "Runic Enchant Stone", "Frogalloon", "Coral Whale", "Flame Tyrant", "Withering Core",
    "Sea Eater", "Thunderzilla", "Iridesca", "Frostbite Leviathan", "Fluorivane",
    "Cerulean Dragon", "Machodon", "Scorching Veinmaw", "Crystalline Behemoth",
    "Frostmoon Whale", "Crystal Goliath", "Eggy Enchant Stone", "Dark Megalodon",
    "Elemental Tempestray", "Glacial Serpent", "Caustic Maw",
}

local ForgottenList = {
    "Sea Eater", "Thunderzilla", "Iridesca", "Frostbite Leviathan", "Fluorivane", "Cerulean Dragon", "Crystalline Behemoth",
}

local MutasiList = {
    "Noob", "Fairy Dust", "Holographic", "Gemstone", "Fire", "Color Burn", "Frozen",
    "Galaxy", "BloodMoon", "Binary", "Lightning", "Disco", "Festive", "Radioactive", "Moon Fragment",
}

local LegendaryCrystalList = {
    "Blue Sea Dragon", "Star Snail", "Cute Dumbo", "Blossom Jelly", "Bioluminescent Octopus",
}

-- ============================================================
--  GALATAMA EVENT — WEIGHT BASED
-- ============================================================

local GalatamaFishList = {
    "Crystal Goliath",
    "Crystalline Behemoth",
    "Frostborn Shark",
}

local MutasiNoBonus             = { "big", "shiny" }
local GALATAMA_MUTASI_BONUS_KG  = 1000

-- ============================================================
--  FISH CHANCE & IMAGE
-- ============================================================

local FishChanceData = {
    ["Crystal Crab"]              = "1 in 750K",
    ["Orca"]                      = "1 in 1.5M",
    ["Zombie Shark"]              = "1 in 250K",
    ["Zombie Megalodon"]          = "1 in 4M",
    ["Dead Zombie Shark"]         = "1 in 500K",
    ["Blob Shark"]                = "1 in 250K",
    ["Ghost Shark"]               = "1 in 500K",
    ["Skeleton Narwhal"]          = "1 in 600K",
    ["Ghost Worm Fish"]           = "1 in 1M",
    ["Worm Fish"]                 = "1 in 3M",
    ["Megalodon"]                 = "1 in 4M",
    ["1x1x1x1 Comet Shark"]       = "1 in 4M",
    ["Bloodmoon Whale"]           = "1 in 5M",
    ["Lochness Monster"]          = "1 in 3M",
    ["Monster Shark"]             = "1 in 2.5M",
    ["Eerie Shark"]               = "1 in 250K",
    ["Great Whale"]               = "1 in 900K",
    ["Frostborn Shark"]           = "1 in 500K",
    ["Thin Armor Shark"]          = "1 in 300K",
    ["Scare"]                     = "1 in 3M",
    ["Queen Crab"]                = "1 in 800K",
    ["King Crab"]                 = "1 in 1.2M",
    ["Cryoshade Glider"]          = "1 in 450K",
    ["Panther Eel"]               = "1 in 750K",
    ["Giant Squid"]               = "1 in 800K",
    ["Depthseeker Ray"]           = "1 in 1.2M",
    ["Robot Kraken"]              = "1 in 3.5M",
    ["Mosasaur Shark"]            = "1 in 800K",
    ["King Jelly"]                = "1 in 1.5M",
    ["Bone Whale"]                = "1 in 2M",
    ["Elshark Gran Maja"]         = "1 in 4M",
    ["Elpirate Gran Maja"]        = "1 in 4M",
    ["ElRetro Gran Maja"]         = "1 in 4M",
    ["Ancient Whale"]             = "1 in 2.75M",
    ["Gladiator Shark"]           = "1 in 1M",
    ["Ancient Lochness Monster"]  = "1 in 3M",
    ["Talon Serpent"]             = "1 in 3M",
    ["Hacker Shark"]              = "1 in 2M",
    ["Strawberry Choc Megalodon"] = "1 in 4M",
    ["Krampus Shark"]             = "1 in 1M",
    ["Emerald Winter Whale"]      = "1 in 1.5M",
    ["Winter Frost Shark"]        = "1 in 3M",
    ["Icebreaker Whale"]          = "1 in 4M",
    ["Cursed Kraken"]             = "1 in 3M",
    ["Pirate Megalodon"]          = "1 in 4M",
    ["Leviathan"]                 = "1 in 5M",
    ["Viridis Lurker"]            = "1 in 1.4M",
    ["Ancient Magma Whale"]       = "1 in 5M",
    ["Mutant Runic Koi"]          = "1 in ??",
    ["Cosmic Mutant Shark"]       = "1 in 2M",
    ["Strawberry Orca"]           = "1 in 3M",
    ["Bonemaw Tyrant"]            = "1 in 2.5M",
    ["Rainbow Comet Shark"]       = "1 in ??",
    ["Love Nessie"]               = "1 in ??",
    ["Broken Heart Nessie"]       = "1 in ??",
    ["Sea Eater"]                 = "1 in 25M",
    ["Thunderzilla"]              = "1 in 30M",
    ["Iridesca"]                  = "1 in 25M",
    ["Eggy Enchant Stone"]        = "1 in 100K",
    ["Deepsea Monster Axolotl"]   = "1 in 2M",
    ["Blocky Lochness Monster"]   = "1 in 3M",
    ["Frostbite Leviathan"]       = "1 in 12M",
    ["Aurelion"]                  = "1 in 3M",
    ["Runic Enchant Stone"]       = "1 in 1.5M",
    ["Frogalloon"]                = "1 in 1.5M",
    ["Fluorivane"]                = "1 in 15M",
    ["Coral Whale"]               = "1 in 2M",
    ["Flame Tyrant"]              = "1 in 5M",
    ["Cerulean Dragon"]           = "1 in 25M",
    ["Withering Core"]            = "1 in 3M",
    ["Machodon"]                  = "1 in 10M",
    ["Crystalline Behemoth"]      = "1 in 20M",
    ["Frostmoon Whale"]           = "1 in 5M",
    ["Crystal Goliath"]           = "1 in 3M",
    ["Ketupat Whale"]             = "1 in ??",
    ["Scorching Veinmaw"]         = "1 in 5M",
    ["Glacial Serpent"]           = "1 in 3M",
    ["Elemental Tempestray"]      = "1 in 1M",
    ["Dark Megalodon"]            = "1 in 8M",
    ["Caustic Maw"]               = "1 in 4M",
}

local NP = "https://raw.githubusercontent.com/revkatomy-max/new-pisit-image/main/"

local FishImageURL = {
    ["Frostborn Shark"]          = NP .. "9.png",
    ["Crystal Goliath"]          = NP .. "11.png",
    ["Crystalline Behemoth"]     = NP .. "10.png",
    ["Elemental Tempestray"]     = NP .. "13.png",
    ["Dark Megalodon"]           = NP .. "14.png",
    ["Withering Core"]           = NP .. "16.png",
    ["Flame Tyrant"]             = NP .. "17.png",
    ["Scorching Veinmaw"]        = NP .. "18.png",
    ["Cerulean Dragon"]          = NP .. "19.png",
    ["King Crab"]                = NP .. "21.png",
    ["Queen Crab"]               = NP .. "22.png",
    ["Panther Eel"]              = NP .. "23.png",
    ["Cryoshade Glider"]         = NP .. "24.png",
    ["Giant Squid"]              = NP .. "25.png",
    ["Depthseeker Ray"]          = NP .. "26.png",
    ["Robot Kraken"]             = NP .. "27.png",
    ["Ghost Shark"]              = NP .. "29.png",
    ["Skeleton Narwhal"]         = NP .. "30.png",
    ["Blob Shark"]               = NP .. "31.png",
    ["Worm Fish"]                = NP .. "32.png",
    ["Cosmic Mutant Shark"]      = NP .. "33.png",
    ["Megalodon"]                = NP .. "34.png",
    ["Bloodmoon Whale"]          = NP .. "36.png",
    ["Frostmoon Whale"]          = NP .. "37.png",
    ["Thunderzilla"]             = NP .. "38.png",
    ["Thin Armor Shark"]         = NP .. "40.png",
    ["Scare"]                    = NP .. "41.png",
    ["Lochness Monster"]         = NP .. "43.png",
    ["Ancient Magma Whale"]      = NP .. "44.png",
    ["Crystal Crab"]             = NP .. "46.png",
    ["Orca"]                     = NP .. "47.png",
    ["Eerie Shark"]              = NP .. "49.png",
    ["Monster Shark"]            = NP .. "50.png",
    ["Eggy Enchant Stone"]       = NP .. "52.png",
    ["Strawberry Orca"]          = NP .. "53.png",
    ["Iridesca"]                 = NP .. "54.png",
    ["Frogalloon"]               = NP .. "56.png",
    ["Blocky Lochness Monster"]  = NP .. "57.png",
    ["Aurelion"]                 = NP .. "58.png",
    ["Frostbite Leviathan"]      = NP .. "59.png",
    ["Runic Enchant Stone"]      = NP .. "61.png",
    ["Bonemaw Tyrant"]           = NP .. "00.png",
    ["Mutant Runic Koi"]         = NP .. "62.png",
    ["Deepsea Monster Axolotl"]  = NP .. "63.png",
    ["Fluorivane"]               = NP .. "64.png",
    ["Sea Eater"]                = NP .. "65.png",
    ["Pirate Megalodon"]         = NP .. "67.png",
    ["Elpirate Gran Maja"]       = NP .. "68.png",
    ["Cursed Kraken"]            = NP .. "69.png",
    ["Mosasaur Shark"]           = NP .. "71.png",
    ["King Jelly"]               = NP .. "72.png",
    ["Gladiator Shark"]          = NP .. "75.png",
    ["Ancient Lochness Monster"] = NP .. "76.png",
    ["Elshark Gran Maja"]        = NP .. "77.png",
    ["Viridis Lurker"]           = NP .. "78.png",
    ["Bone Whale"]               = NP .. "79.png",
    ["Ancient Whale"]            = NP .. "80.png",
    ["Great Whale"]              = NP .. "82.png",
    ["Coral Whale"]              = NP .. "83.png",
    ["Love Nessie"]              = NP .. "85.png",
    ["Broken Heart Nessie"]      = NP .. "86.png",
    ["Ketupat Whale"]            = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Ketupat%20Whale.png",
    ["Leviathan"]                = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Leviathan.png",
    ["Rainbow Comet Shark"]      = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Rainbow%20Comet%20Shark.png",
    ["Ruby"]                     = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/1.png",
    ["Glacial Serpent"]          = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/SC%20baru.png",
    ["Machodon"]                 = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/42.png",
    ["Crystal"]                  = "https://raw.githubusercontent.com/revkatomy-max/new-pisit-image/main/crystal.png",
    ["treasure hunt"]            = "https://raw.githubusercontent.com/revkatomy-max/new-pisit-image/main/treasure.png",
    ["Caustic Maw"]              = "https://raw.githubusercontent.com/revkatomy-max/new-pisit-image/main/97.png",
    ["Aurora"]                   = "https://raw.githubusercontent.com/revkatomy-max/new-pisit-image/main/99.png",
}

-- ============================================================
--  EVENT HUNT DATABASE
-- ============================================================

local EventHuntData = {
    {
        textTriggers = { "treasure hunt" },
        title        = EMOJI_TREASURE .. " Treasure Hunt Dimulai!",
        description  = "katakan Peta 🗺️",
        color        = 16766720,
        emoji        = "💰",
        thumbUrl     = FishImageURL["treasure hunt"],
    },
    {
        textTriggers = { "dark megalodon hunt", "dark megalodon" },
        title        = "🌑 Dark Megalodon Hunt Dimulai!",
        description  = "Dark Mega guys " .. EMOJI_MEGALODON,
        color        = 2303786,
        emoji        = "🌑",
        thumbUrl     = FishImageURL["Dark Megalodon"],
    },
    {
        textTriggers = { "megalodon hunt" },
        title        = EMOJI_MEGALODON .. " Megalodon Hunt Dimulai!",
        description  = "Mega gusy 🎣",
        color        = 3447003,
        emoji        = "🦈",
        thumbUrl     = FishImageURL["Megalodon"],
    },
    {
        textTriggers = { "thunderzilla hunt", "thunderzilla" },
        title        = EMOJI_THUNDER .. " Thunderzilla Hunt Dimulai!",
        description  = "zilla oi " .. EMOJI_THUNDER,
        color        = 16776960,
        emoji        = "⚡",
        thumbUrl     = FishImageURL["Thunderzilla"],
    },
    {
        textTriggers = { "crystals have spawned", "crystals have", "crystal" },
        title        = EMOJI_CRYSTAL .. " Crystal Event Dimulai!",
        description  = "Crystal muncul gas nambang " .. EMOJI_CRYSTAL,
        color        = 1146986,
        emoji        = "💎",
        thumbUrl     = FishImageURL["Crystal"],
    },
    {
        textTriggers = { "aurora borealis", "aurora event" },
        title        = "💫 Aurora Borealis!",
        description  = "cantiknyooo",
        color        = 9055202,
        emoji        = "💫",
        thumbUrl     = FishImageURL["Aurora"],
    },
}

local EventCooldown = {}

-- ============================================================
--  STATE / CACHE
-- ============================================================

local FishImageCache = {}
local AvatarCache    = {}
local LeaveTimers    = {}
local PlayerStats    = {}
local PlayerNameToId = {}
local GalatamaStats  = {}
local NameStats      = {}   -- key = resolved alias (lname)

local ServerStats = {
    totalSecret    = 0,
    totalForgotten = 0,
    secretLog      = {},
    forgottenLog   = {},
    startTime      = 0,
}

-- ============================================================
--  SAVE CONFIG
-- ============================================================

local CONFIG_FILE = "bloxgank_config.json"

local function SaveConfig(joinUrl, fishUrl, statsUrl, eventUrl)
    if not writefile then return end
    pcall(function()
        writefile(CONFIG_FILE, HttpService:JSONEncode({
            webhook_join  = joinUrl  or "",
            webhook_fish  = fishUrl  or "",
            webhook_stats = statsUrl or "",
            webhook_event = eventUrl or "",
        }))
    end)
end

local function LoadConfig()
    if not readfile or not isfile then return nil end
    local ok, raw = pcall(function() return readfile(CONFIG_FILE) end)
    if not ok or not raw or raw == "" then return nil end
    local ok2, data = pcall(function() return HttpService:JSONDecode(raw) end)
    if ok2 and type(data) == "table" then return data end
    return nil
end

-- ============================================================
--  UTILITY
-- ============================================================

local function GetRequestFunc()
    return (syn and syn.request)
        or (http and http.request)
        or http_request
        or (fluxus and fluxus.request)
        or request
end

local function StripTags(str)
    return string.gsub(str, "<[^>]+>", "")
end

local function Trim(s)
    return s:match("^%s*(.-)%s*$") or s
end

local function UptimeString(seconds)
    return math.floor(seconds / 3600) .. "h " .. math.floor((seconds % 3600) / 60) .. "m"
end

local function FindPlayer(name)
    local p = Players:FindFirstChild(name)
    if p then return p end
    local lower = string.lower(name)
    for _, player in ipairs(Players:GetPlayers()) do
        if string.lower(player.Name) == lower then return player end
    end
    for _, player in ipairs(Players:GetPlayers()) do
        if string.find(string.lower(player.Name), lower, 1, true)
        or string.find(lower, string.lower(player.Name), 1, true) then
            return player
        end
    end
    return nil
end

-- ============================================================
--  WEIGHT HELPERS
-- ============================================================

local function ParseWeight(weightStr)
    if not weightStr or weightStr == "N/A" then return 0 end
    local s = weightStr:upper():gsub("%s+", "")
    local num, suffix = s:match("^([%d%.]+)([KMB]?)K?G$")
    if not num then num, suffix = s:match("^([%d%.]+)([KMB]?)") end
    if not num then return 0 end
    local val = tonumber(num) or 0
    suffix = suffix or ""
    if suffix == "K" then val = val * 1000
    elseif suffix == "M" then val = val * 1000000
    elseif suffix == "B" then val = val * 1000000000
    end
    return val
end

local function FormatWeight(kg)
    if kg >= 1000000000 then
        return string.format("%.6gB kg", kg / 1000000000)
    elseif kg >= 1000000 then
        return string.format("%.6gM kg", kg / 1000000)
    elseif kg >= 1000 then
        return string.format("%.6gK kg", kg / 1000)
    else
        return string.format("%g kg", kg)
    end
end

local function CheckGalatamaMutasiBonus(mutasi)
    if not mutasi or mutasi == "" then return false, nil end
    local ml = mutasi:lower()
    for _, excluded in ipairs(MutasiNoBonus) do
        if ml == excluded:lower() then return false, mutasi end
    end
    return true, mutasi
end

local function FindGalatamaFish(baseName)
    if not baseName then return nil end
    local lower = baseName:lower()
    for _, name in ipairs(GalatamaFishList) do
        if lower == name:lower() then return name end
    end
    return nil
end

-- ============================================================
--  DISPLAY NAME RESOLVER
-- ============================================================

local function ResolveDisplayName(name)
    -- cek exact username dulu
    local p = Players:FindFirstChild(name)
    if p then return p.Name end
    -- cek via cache displayname/username → uid → username
    local uid = PlayerNameToId[string.lower(name)]
    if uid then
        local p2 = Players:GetPlayerByUserId(uid)
        if p2 then return p2.Name end
    end
    return name  -- fallback
end

-- ============================================================
--  FISH DETECTION
-- ============================================================

local function FindSecretFish(fishName)
    local lower = string.lower(fishName)
    for _, baseName in ipairs(SecretFishList) do
        if lower == string.lower(baseName) then return baseName, nil end
    end
    local bestBase, bestLen, bestMutasi = nil, 0, nil
    for _, baseName in ipairs(SecretFishList) do
        local s = string.find(lower, string.lower(baseName), 1, true)
        if s then
            local mutasi = nil
            if s > 1 then
                mutasi = fishName:sub(1, s - 1):match("^%s*(.-)%s*$")
                if mutasi == "" then mutasi = nil end
            end
            if #baseName > bestLen then
                bestLen    = #baseName
                bestBase   = baseName
                bestMutasi = mutasi
            end
        end
    end
    return bestBase, bestMutasi
end

local function FindMutasi(fishName)
    local lower = string.lower(fishName)
    for _, mutasiName in ipairs(MutasiList) do
        local mutasiLower = string.lower(mutasiName)
        local s = string.find(lower, mutasiLower, 1, true)
        if s then
            local before = s == 1 and " " or lower:sub(s - 1, s - 1)
            local after  = lower:sub(s + #mutasiLower, s + #mutasiLower)
            if (before == " " and after == " ") or (s == 1 and after == " ") then
                return mutasiName
            end
        end
    end
    return nil
end

local function FindRuby(fishName)
    local lower = string.lower(fishName)
    if string.find(lower, "ruby") and string.find(lower, "gemstone") then return "Ruby" end
    return nil
end

local function FindLegendaryCrystal(fishName)
    local lower = string.lower(fishName)
    if not string.find(lower, "crystalized") then return nil end
    for _, name in ipairs(LegendaryCrystalList) do
        if string.find(lower, string.lower(name), 1, true) then return name end
    end
    return nil
end

local function GetFishImageId(item)
    for _, desc in ipairs(item:GetDescendants()) do
        local ok, val = pcall(function()
            if desc:IsA("SpecialMesh")                               then return desc.TextureId
            elseif desc:IsA("Decal") or desc:IsA("Texture")         then return desc.Texture
            elseif desc:IsA("ImageLabel") or desc:IsA("ImageButton") then return desc.Image
            end
            return nil
        end)
        if ok and val and val ~= "" and val ~= "rbxasset://" then
            local id = tostring(val):match("%d+")
            if id then return id end
        end
    end
    return nil
end

-- ============================================================
--  WEBHOOK SENDERS
-- ============================================================

local function BrandAuthor()
    if BRAND_ICON ~= "" then
        return { name = BRAND_NAME, icon_url = BRAND_ICON }
    end
    return { name = BRAND_NAME }
end

local function BuildEmbed(title, description, color, fields, imageUrl, thumbUrl, footerTag, author)
    local embed = {
        title       = title,
        description = description,
        color       = color,
        fields      = fields,
        footer      = { text = (footerTag or BRAND_FOOTER_TEXT) .. " " .. os.date("%d/%m/%Y %H:%M:%S") },
        timestamp   = os.date("!%Y-%m-%dT%H:%M:%SZ"),
    }
    if imageUrl then embed.image     = { url = imageUrl } end
    if thumbUrl then embed.thumbnail = { url = thumbUrl } end
    embed.author = author or BrandAuthor()
    return embed
end

local function PostWebhook(url, body)
    local requestFunc = GetRequestFunc()
    if not requestFunc or url == "" then return end
    task.spawn(function()
        pcall(function()
            requestFunc({
                Url     = url,
                Method  = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body    = HttpService:JSONEncode(body),
            })
        end)
    end)
end

local function BuildContent(mention, captionType)
    if not mention or mention == "" then return nil end
    local m = Trim(mention)
    if captionType == "secret" or captionType == "forgotten" then return "Hari hari bersyukur " .. m
    elseif captionType == "leave"   then return "ke disconect ya? " .. m
    elseif captionType == "join"    then return "alhamdulilah kembali " .. m
    elseif captionType == "notback" then return "lah kok ngilang " .. m
    end
    return m
end

local function SendWebhook(title, description, color, fields, imageUrl, thumbUrl, mention, captionType)
    local f = {}
    for _, v in ipairs(fields) do table.insert(f, v) end
    PostWebhook(WEBHOOK_URL, {
        username   = "BLOX Gank",
        avatar_url = WEBHOOK_AVATAR,
        content    = BuildContent(mention, captionType),
        embeds     = { BuildEmbed(title, description, color, f, imageUrl, thumbUrl) },
    })
end

local function SendFishWebhook(title, description, color, fields, imageUrl, thumbUrl, mention, captionType)
    local url = (WEBHOOK_FISH ~= "") and WEBHOOK_FISH or WEBHOOK_URL
    if url == "" then return end
    local f = {}
    for _, v in ipairs(fields) do table.insert(f, v) end
    PostWebhook(url, {
        content = BuildContent(mention, captionType),
        embeds  = { BuildEmbed(title, description, color, f, imageUrl, thumbUrl) },
    })
end

local function SendStatsWebhook(title, description, color, fields, imageUrl, thumbUrl)
    local f = {}
    for _, v in ipairs(fields) do table.insert(f, v) end
    PostWebhook(WEBHOOK_STATS, {
        embeds = { BuildEmbed(title, description, color, f, imageUrl, thumbUrl, "BLOX Gank Stats") }
    })
end

-- ============================================================
--  GALATAMA LEADERBOARD
-- ============================================================

local function SendGalatamaLeaderboard(isFinal)
    local merged = {}
    for _, gs in pairs(GalatamaStats) do
        if gs.totalWeight > 0 then
            local key = string.lower(gs.name)
            if not merged[key] or gs.totalWeight > merged[key].totalWeight then
                merged[key] = { name = gs.name, totalWeight = gs.totalWeight, catches = gs.catches }
            end
        end
    end
    for lname, ns in pairs(NameStats) do
        if (ns.totalWeight or 0) > 0 then
            if not merged[lname] then
                merged[lname] = { name = ns.name, totalWeight = ns.totalWeight or 0, catches = ns.catches }
            elseif (ns.totalWeight or 0) > merged[lname].totalWeight then
                merged[lname] = { name = ns.name, totalWeight = ns.totalWeight or 0, catches = ns.catches }
            end
        end
    end

    local leaderData = {}
    for _, gs in pairs(merged) do
        local catchLines = {}
        for fishName, catchData in pairs(gs.catches) do
            local count = catchData.count or 0
            local w     = catchData.totalWeight or 0
            table.insert(catchLines, fishName .. " x" .. count .. " (" .. FormatWeight(w) .. ")")
        end
        table.insert(leaderData, {
            name        = gs.name,
            totalWeight = gs.totalWeight,
            catchStr    = #catchLines > 0 and table.concat(catchLines, "\n") or "-",
        })
    end
    if #leaderData == 0 then return end
    table.sort(leaderData, function(a, b) return a.totalWeight > b.totalWeight end)

    local medals     = { "🥇", "🥈", "🥉" }
    local uptime     = os.time() - ServerStats.startTime
    local title      = isFinal and "🏆 LEADERBOARD FINAL GALATAMA" or "🏆 LEADERBOARD GALATAMA — UPDATE"

    local fields = {}
    for i, entry in ipairs(leaderData) do
        if i > 10 then break end
        local medal = medals[i] or ("#" .. i)
        table.insert(fields, {
            name   = medal .. " " .. entry.name .. " — ⚖️ " .. FormatWeight(entry.totalWeight),
            value  = entry.catchStr,
            inline = false,
        })
    end
    table.insert(fields, { name = SEP .. " Event",        value = "**Galatama**",                              inline = true })
    table.insert(fields, { name = SEP .. " Uptime",       value = UptimeString(uptime),                        inline = true })
    table.insert(fields, { name = SEP .. " Total Secret", value = "**" .. ServerStats.totalSecret .. "** ekor", inline = true })

    local eventUrl = (WEBHOOK_EVENT ~= "") and WEBHOOK_EVENT or WEBHOOK_URL
    PostWebhook(eventUrl, {
        embeds = { BuildEmbed(
            title,
            "```\nIkan: Crystal Goliath | Crystalline Behemoth | Frostborn Shark\nScoring: Total Weight (kg) — Bonus Mutasi (kecuali Big & Shiny): +1,000 kg\n```",
            16766720, fields, nil, nil, "BLOX Gank Galatama"
        )},
    })
end

-- ============================================================
--  EVENT WEBHOOK SENDER
-- ============================================================

local function SendEventWebhook(eventData, rawText)
    local url = (WEBHOOK_EVENT ~= "") and WEBHOOK_EVENT or WEBHOOK_URL
    if url == "" then return end
    PostWebhook(url, {
        username   = "BLOX Gank Event",
        avatar_url = WEBHOOK_AVATAR,
        content    = "<@&" .. ROLE_NELAYAN_ID .. ">",
        embeds     = { BuildEmbed(
            eventData.title,
            eventData.description,
            eventData.color,
            {
                { name = SEP .. " Host Server",  value = "**" .. Players.LocalPlayer.Name .. "**",              inline = true },
                { name = SEP .. " Total Player", value = "**" .. tostring(#Players:GetPlayers()) .. "** orang", inline = true },
                { name = SEP .. " Waktu Mulai",  value = os.date("%H:%M:%S"),                                   inline = true },
            },
            nil,
            eventData.thumbUrl,
            "BLOX Gank Event Monitor",
            { name = EMOJI_EVENTTAG .. " Event Hunt Alert", icon_url = WEBHOOK_AVATAR ~= "" and WEBHOOK_AVATAR or nil }
        )},
    })
end

-- ============================================================
--  EVENT DETECTION
-- ============================================================

local _hookedLabels = {}

local function ProcessEventText(text)
    if not SCRIPT_ACTIVE then return end
    if not text or text == "" then return end
    local lower = text:lower()

    local isRelevant = lower:find("hunt") or lower:find("started") or lower:find("crystal")
        or lower:find("spawned") or lower:find("aurora")
    if not isRelevant then return end

    for _, evData in ipairs(EventHuntData) do
        for _, trigger in ipairs(evData.textTriggers) do
            if lower:find(trigger, 1, true) then
                local now = os.time()
                if (now - (EventCooldown[evData.title] or 0)) >= EVENT_COOLDOWN_SECONDS then
                    EventCooldown[evData.title] = now
                    SendEventWebhook(evData, text)
                end
                return
            end
        end
    end
end

local function HookLabel(label)
    if _hookedLabels[label] then return end
    _hookedLabels[label] = true
    ProcessEventText(label.Text)
    label:GetPropertyChangedSignal("Text"):Connect(function()
        ProcessEventText(label.Text)
    end)
end

local function StartEventMonitor()
    task.spawn(function()
        local pg = Players.LocalPlayer:WaitForChild("PlayerGui", 30)
        if not pg then return end
        for _, v in ipairs(pg:GetDescendants()) do
            if v:IsA("TextLabel") or v:IsA("TextButton") then HookLabel(v) end
        end
        pg.DescendantAdded:Connect(function(v)
            if v:IsA("TextLabel") or v:IsA("TextButton") then
                task.wait(0)
                HookLabel(v)
            end
        end)
    end)
end

-- ============================================================
--  CHAT PARSING & DETECTION
-- ============================================================

local function ParseChat(rawMsg)
    local msg = StripTags(rawMsg)
    msg = string.gsub(msg, "^%[Server%]:%s*", "")
    local playerName, fishFull, weight = string.match(msg, "^(.-) obtained an? (.-) %(([%d%.%a]+ ?kg)%)")
    if not playerName then
        playerName, fishFull = string.match(msg, "^(.-) obtained an? (.+)")
        weight = "N/A"
    end
    if not playerName or not fishFull then return nil end
    playerName = playerName:match("%[%a+%]:%s*(.+)") or playerName
    playerName = Trim(playerName)
    weight     = weight and Trim(weight) or "N/A"
    fishFull   = fishFull:match("^(.-)%s+with a 1 in") or fishFull
    fishFull   = fishFull:match("^(.-)%s*[!%.]?$")     or fishFull
    fishFull   = Trim(fishFull)
    return { player = playerName, fish = fishFull, weight = weight }
end

local function GetAvatarUrlById(userId)
    if not userId then return nil end
    return PROXY .. "/avatar/" .. tostring(userId) .. "?t=" .. tostring(os.time())
end

local function CheckAndSend(rawMsg)
    if not SCRIPT_ACTIVE then return end
    if not string.find(string.lower(rawMsg), "obtained") then return end

    local data = ParseChat(rawMsg)
    if not data then return end

    -- Normalize DisplayName → Username
    data.player = ResolveDisplayName(data.player)

    local targetPlayer = FindPlayer(data.player)
    local uid = (targetPlayer and targetPlayer.UserId)
             or PlayerNameToId[string.lower(data.player)]
    local avatarUrl = GetAvatarUrlById(uid)

    local lname = string.lower(data.player)

    if uid then
        if not PlayerStats[uid] then
            PlayerStats[uid] = { catchCount = 0, secretList = {}, joinTime = os.time(), lastFishTime = nil, name = data.player }
        end
        PlayerStats[uid].catchCount   = PlayerStats[uid].catchCount + 1
        PlayerStats[uid].lastFishTime = os.time()
        if not GalatamaStats[uid] then
            GalatamaStats[uid] = { name = data.player, totalWeight = 0, catches = {} }
        end
    end

    -- NameStats pakai lname (resolved alias), nama update ke yang catch terakhir
    if not NameStats[lname] then
        NameStats[lname] = { name = data.player, secretList = {}, totalWeight = 0, catches = {} }
    end

    -- 1. Crystalized Legendary
    local legendaryBase = FindLegendaryCrystal(data.fish)
    if legendaryBase then
        local imageUrl = FishImageURL[legendaryBase] or (FishImageCache[legendaryBase] and (PROXY .. "/asset/" .. FishImageCache[legendaryBase]))
        SendFishWebhook(EMOJI_LEGENDARY .. " Crystalized Legendary!", " " .. EMOJI_MUTASI, TierColors.Legendary, {
            { name = SEP .. " Pemain", value = "**" .. data.player .. "**", inline = true },
            { name = SEP .. " Item",   value = "**" .. data.fish .. "**",   inline = true },
            { name = SEP .. " Berat",  value = "**" .. data.weight .. "**", inline = true },
        }, nil, imageUrl, nil, "secret")
        return
    end

    -- 2. Ruby Gemstone
    local rubyBase = FindRuby(data.fish)
    if rubyBase then
        local imageUrl = FishImageURL[rubyBase] or (FishImageCache[rubyBase] and (PROXY .. "/asset/" .. FishImageCache[rubyBase]))
        SendFishWebhook(EMOJI_RUBY .. " Ruby Gemstone!", "Goceng" .. EMOJI_RUBY, TierColors.Ruby, {
            { name = SEP .. " Pemain", value = "**" .. data.player .. "**", inline = true },
            { name = SEP .. " Item",   value = "**" .. data.fish .. "**",   inline = true },
            { name = SEP .. " Berat",  value = "**" .. data.weight .. "**", inline = true },
        }, nil, imageUrl, nil, "secret")
        return
    end

    -- 3. Secret Fish
    local baseName, mutasi = FindSecretFish(data.fish)
    if baseName then
        local imageUrl = FishImageURL[baseName] or (FishImageCache[baseName] and (PROXY .. "/asset/" .. FishImageCache[baseName]))
        local isForgotten = false
        for _, name in ipairs(ForgottenList) do
            if string.lower(baseName) == string.lower(name) then isForgotten = true; break end
        end
        if uid and PlayerStats[uid] then
            PlayerStats[uid].secretList[baseName] = (PlayerStats[uid].secretList[baseName] or 0) + 1
        end
        NameStats[lname].secretList[baseName] = (NameStats[lname].secretList[baseName] or 0) + 1

        local chanceInfo  = FishChanceData[baseName] or "Unknown"
        local mutasiField = mutasi and (EMOJI_MUTASI .. " *" .. mutasi .. "*") or "—"

        local fields = {
            { name = SEP .. " Pemain", value = "**" .. data.player .. "**", inline = true },
            { name = SEP .. " Ikan",   value = "**" .. data.fish .. "**",   inline = true },
            { name = SEP .. " Berat",  value = "**" .. data.weight .. "**", inline = true },
            { name = SEP .. " Mutasi", value = mutasiField,                  inline = true },
            { name = SEP .. " Chance", value = chanceInfo,                   inline = true },
        }

        -- Galatama weight scoring
        local galBase = FindGalatamaFish(baseName)
        if galBase then
            local rawWeight   = ParseWeight(data.weight)
            local mutasiBonus = 0
            local bonusLabel  = nil

            local eligible, label = CheckGalatamaMutasiBonus(mutasi)
            if eligible then
                mutasiBonus = GALATAMA_MUTASI_BONUS_KG
                bonusLabel  = label
            end

            local totalAdded = rawWeight + mutasiBonus

            if uid and GalatamaStats[uid] then
                GalatamaStats[uid].totalWeight = GalatamaStats[uid].totalWeight + totalAdded
                if not GalatamaStats[uid].catches[galBase] then
                    GalatamaStats[uid].catches[galBase] = { count = 0, totalWeight = 0 }
                end
                GalatamaStats[uid].catches[galBase].count       = GalatamaStats[uid].catches[galBase].count + 1
                GalatamaStats[uid].catches[galBase].totalWeight = GalatamaStats[uid].catches[galBase].totalWeight + totalAdded
            end
            NameStats[lname].totalWeight = (NameStats[lname].totalWeight or 0) + totalAdded
            if not NameStats[lname].catches[galBase] then
                NameStats[lname].catches[galBase] = { count = 0, totalWeight = 0 }
            end
            NameStats[lname].catches[galBase].count       = NameStats[lname].catches[galBase].count + 1
            NameStats[lname].catches[galBase].totalWeight = NameStats[lname].catches[galBase].totalWeight + totalAdded

            local totalNow = (uid and GalatamaStats[uid] and GalatamaStats[uid].totalWeight) or NameStats[lname].totalWeight or 0

            local galDesc
            if mutasiBonus > 0 then
                galDesc = "**+" .. FormatWeight(totalAdded) .. "**"
                    .. " (" .. FormatWeight(rawWeight) .. " weight + " .. FormatWeight(mutasiBonus) .. " bonus mutasi 🌀 *" .. (bonusLabel or mutasi) .. "*)"
                    .. "\ntotal: **" .. FormatWeight(totalNow) .. "**"
            else
                galDesc = "**+" .. FormatWeight(totalAdded) .. "**"
                if mutasi then galDesc = galDesc .. " *(mutasi " .. mutasi .. " — no bonus)*" end
                galDesc = galDesc .. "\ntotal: **" .. FormatWeight(totalNow) .. "**"
            end

            table.insert(fields, { name = "⚖️ Galatama", value = galDesc, inline = false })
        end

        if isForgotten then
            ServerStats.totalForgotten = ServerStats.totalForgotten + 1
            table.insert(ServerStats.forgottenLog, { fish = baseName, player = data.player, time = os.time() })
            SendFishWebhook(EMOJI_FORGOTTEN .. " Forgotten Tier Detected!", " " .. EMOJI_FORGOTTEN, TierColors.Forgotten, fields, nil, imageUrl, nil, "forgotten")
        else
            ServerStats.totalSecret = ServerStats.totalSecret + 1
            table.insert(ServerStats.secretLog, { fish = baseName, player = data.player, time = os.time() })
            SendFishWebhook(EMOJI_NOTIF .. " Secret Fish Detected!", " ", TierColors.Secret, fields, nil, imageUrl, nil, "secret")
        end
        return
    end

    -- 4. Mutasi non-secret
    local mutasiDetected = FindMutasi(data.fish)
    if not mutasiDetected then return end
    SendFishWebhook(
        EMOJI_MUTASI .. " Mutasi Terdeteksi!", "", TierColors.Mutasi,
        {
            { name = SEP .. " Pemain", value = "**" .. data.player .. "**",           inline = true },
            { name = SEP .. " Ikan",   value = "**" .. data.fish .. "**",             inline = true },
            { name = SEP .. " Berat",  value = "**" .. data.weight .. "**",           inline = true },
            { name = SEP .. " Mutasi", value = EMOJI_MUTASI .. " " .. mutasiDetected, inline = true },
        },
        nil, avatarUrl, nil, nil
    )
end

-- ============================================================
--  BACKPACK MONITOR
-- ============================================================

local function WatchBackpack(bp)
    bp.ChildAdded:Connect(function(item)
        task.wait(0.1)
        local baseName = FindSecretFish(item.Name)
        if baseName and not FishImageURL[baseName] and not FishImageCache[baseName] then
            local imgId = GetFishImageId(item)
            if imgId then FishImageCache[baseName] = imgId end
        end
    end)
end

local function WatchForFish(player)
    local bp = player:FindFirstChild("Backpack")
    if bp then WatchBackpack(bp) end
    player.CharacterAdded:Connect(function()
        local newBp = player:WaitForChild("Backpack", 15)
        if newBp then WatchBackpack(newBp) end
    end)
end

-- ============================================================
--  HOOK CHAT
-- ============================================================

local function HookChat()
    if TextChatService then
        TextChatService.MessageReceived:Connect(function(msg)
            local text = msg.Text or ""
            if msg.TextSource == nil then CheckAndSend(text) end
        end)
    end
    local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    if chatEvents then
        local onMessage = chatEvents:FindFirstChild("OnMessageDoneFiltering")
        if onMessage then
            onMessage.OnClientEvent:Connect(function(d)
                if not (d and d.Message) then return end
                local lowerMsg = string.lower(d.Message)
                if string.find(lowerMsg, "%[server%]") or string.find(lowerMsg, "obtained") then
                    CheckAndSend(d.Message)
                end
            end)
        end
    end
end

-- ============================================================
--  START MONITORING
-- ============================================================

local function StartMonitoring()
    ServerStats.startTime = os.time()

    local allPlayers = Players:GetPlayers()
    local names      = {}
    for _, p in ipairs(allPlayers) do table.insert(names, p.Name) end

    SendWebhook(EMOJI_STARTER .. " Monitor Started", "Server monitor sudah aktif", TierColors.Join, {
        { name = SEP .. " Host",          value = "**" .. Players.LocalPlayer.Name .. "**",     inline = true  },
        { name = SEP .. " Total Player",  value = "**" .. tostring(#allPlayers) .. "** orang",  inline = true  },
        { name = SEP .. " Daftar Player", value = "```\n" .. table.concat(names, ", ") .. "```", inline = false },
        { name = "⚖️ Scoring Galatama",   value = "Crystal Goliath | Crystalline Behemoth | Frostborn Shark\nBerdasarkan **Total Weight (kg)**\n🌀 Bonus Mutasi (kecuali Big & Shiny): **+1,000 kg**", inline = false },
    })

    HookChat()
    StartEventMonitor()

    task.spawn(function()
        while SCRIPT_ACTIVE do
            task.wait(1200)
            if not SCRIPT_ACTIVE then break end
            local uptime = os.time() - ServerStats.startTime
            local recentSecret, recentForgotten = {}, {}
            for i = math.max(1, #ServerStats.secretLog - 4), #ServerStats.secretLog do
                local e = ServerStats.secretLog[i]
                table.insert(recentSecret, e.fish .. " (" .. e.player .. ")")
            end
            for i = math.max(1, #ServerStats.forgottenLog - 4), #ServerStats.forgottenLog do
                local e = ServerStats.forgottenLog[i]
                table.insert(recentForgotten, e.fish .. " (" .. e.player .. ")")
            end
            SendStatsWebhook(EMOJI_SERVER .. " Server Stats", "Ringkasan aktivitas server", 3447003, {
                { name = SEP .. " Uptime Monitor",     value = UptimeString(uptime),                                                 inline = true  },
                { name = SEP .. " Total Secret Fish",  value = "**" .. tostring(ServerStats.totalSecret) .. "** ekor",              inline = true  },
                { name = SEP .. " Total Forgotten",    value = "**" .. tostring(ServerStats.totalForgotten) .. "** ekor",           inline = true  },
                { name = SEP .. " Secret Terakhir",    value = #recentSecret   > 0 and table.concat(recentSecret,   "\n") or "—",  inline = false },
                { name = SEP .. " Forgotten Terakhir", value = #recentForgotten > 0 and table.concat(recentForgotten, "\n") or "—", inline = false },
            })
        end
    end)

    task.spawn(function()
        while SCRIPT_ACTIVE do
            task.wait(1800)
            if SCRIPT_ACTIVE then SendGalatamaLeaderboard(false) end
        end
    end)

    for _, p in ipairs(allPlayers) do
        WatchForFish(p)
        local lname = string.lower(p.Name)
        AvatarCache[p.UserId]                       = GetAvatarUrlById(p.UserId)
        PlayerStats[p.UserId]                       = { catchCount = 0, secretList = {}, joinTime = os.time(), lastFishTime = nil, name = p.Name }
        GalatamaStats[p.UserId]                     = { name = p.Name, totalWeight = 0, catches = {} }
        NameStats[lname]                            = NameStats[lname] or { name = p.Name, secretList = {}, totalWeight = 0, catches = {} }
        PlayerNameToId[string.lower(p.Name)]        = p.UserId
        PlayerNameToId[string.lower(p.DisplayName)] = p.UserId
    end

    Players.PlayerAdded:Connect(function(player)
        if not SCRIPT_ACTIVE then return end
        local lname = string.lower(player.Name)
        LeaveTimers[player.UserId]                          = nil
        PlayerStats[player.UserId]                          = { catchCount = 0, secretList = {}, joinTime = os.time(), lastFishTime = nil, name = player.Name }
        GalatamaStats[player.UserId]                        = { name = player.Name, totalWeight = 0, catches = {} }
        NameStats[lname]                                    = NameStats[lname] or { name = player.Name, secretList = {}, totalWeight = 0, catches = {} }
        PlayerNameToId[string.lower(player.Name)]           = player.UserId
        PlayerNameToId[string.lower(player.DisplayName)]    = player.UserId
        task.spawn(function()
            task.wait(1)
            AvatarCache[player.UserId] = GetAvatarUrlById(player.UserId)
            SendWebhook(EMOJI_JOIN .. " Player Joined Server", "welcam", TierColors.Join, {
                { name = SEP .. " Username",     value = "**" .. player.Name .. "**",                     inline = true },
                { name = SEP .. " Total Player", value = "**" .. tostring(#Players:GetPlayers()) .. "**", inline = true },
            }, nil, AvatarCache[player.UserId], nil, "join")
        end)
        WatchForFish(player)
    end)

    Players.PlayerRemoving:Connect(function(player)
        if not SCRIPT_ACTIVE then return end
        local pName     = player.Name
        local pId       = player.UserId
        local avatarUrl = AvatarCache[pId] or GetAvatarUrlById(pId)
        local totalNow  = #Players:GetPlayers() - 1

        AvatarCache[pId]                    = nil
        PlayerStats[pId]                    = nil
        PlayerNameToId[string.lower(pName)] = nil
        for k, v in pairs(PlayerNameToId) do if v == pId then PlayerNameToId[k] = nil end end

        SendWebhook(EMOJI_LEAVE .. " Player Left Server", "Salah satu pemain keluar server.", TierColors.Leave, {
            { name = SEP .. " Username",     value = "**" .. pName .. "**",              inline = true },
            { name = SEP .. " Total Player", value = "**" .. tostring(totalNow) .. "**", inline = true },
        }, nil, avatarUrl, nil, "leave")

        LeaveTimers[pId] = true
        task.spawn(function()
            task.wait(600)
            if LeaveTimers[pId] then
                LeaveTimers[pId] = nil
                PostWebhook(WEBHOOK_URL, {
                    username   = "BLOX Gank",
                    avatar_url = WEBHOOK_AVATAR,
                    content    = nil,
                    embeds     = { BuildEmbed(EMOJI_NOTBACK .. " Player Tidak Kembali", "Pemain ini belum balik lagi ke server, semoga aman ya~", TierColors.NotBack, {
                        { name = SEP .. " Username", value = "**" .. pName .. "**",               inline = true },
                        { name = SEP .. " Info",     value = "Tidak kembali selama **10 menit**", inline = true },
                    }, avatarUrl, nil, "BLOX Gank Webhook") },
                })
            end
        end)
    end)

    local finalSent = false
    local function TrySendFinal()
        if finalSent or not SCRIPT_ACTIVE then return end
        finalSent = true
        SendGalatamaLeaderboard(true)
    end
    Players.LocalPlayer.AncestryChanged:Connect(function(_, parent)
        if parent == nil then TrySendFinal() end
    end)
    Players.LocalPlayer.CharacterRemoving:Connect(function()
        task.spawn(function()
            task.wait(2)
            if not Players.LocalPlayer.Parent then TrySendFinal() end
        end)
    end)
end

-- ============================================================
--  UI
-- ============================================================

local function CreateUI()
    local gui = Instance.new("ScreenGui")
    gui.Name         = "BloxGankUI"
    gui.ResetOnSpawn = false
    gui.Parent       = (gethui and gethui()) or CoreGui

    local savedConfig = LoadConfig()

    local FRAME_H = 355
    local frame = Instance.new("Frame")
    frame.Name             = "Main"
    frame.Size             = UDim2.new(0, 300, 0, FRAME_H)
    frame.Position         = UDim2.new(0.5, -150, 0.5, -120)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BorderSizePixel  = 0
    frame.Parent           = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(50, 50, 50); stroke.Thickness = 1; stroke.Parent = frame

    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 36); topBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    topBar.BorderSizePixel = 0; topBar.Parent = frame
    Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 8)

    local topBarFix = Instance.new("Frame")
    topBarFix.Size = UDim2.new(1, 0, 0, 8); topBarFix.Position = UDim2.new(0, 0, 1, -8)
    topBarFix.BackgroundColor3 = Color3.fromRGB(30, 30, 30); topBarFix.BorderSizePixel = 0; topBarFix.Parent = topBar

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Text = "🎣 BLOX Gank Monitor"; titleLbl.Size = UDim2.new(1, -80, 1, 0); titleLbl.Position = UDim2.new(0, 10, 0, 0)
    titleLbl.BackgroundTransparency = 1; titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLbl.Font = Enum.Font.GothamBold; titleLbl.TextSize = 13; titleLbl.TextXAlignment = Enum.TextXAlignment.Left; titleLbl.Parent = topBar

    local function MakeWinBtn(text, xOffset, bgColor)
        local btn = Instance.new("TextButton")
        btn.Text = text; btn.Size = UDim2.new(0, 28, 0, 22); btn.Position = UDim2.new(1, xOffset, 0.5, -11)
        btn.BackgroundColor3 = bgColor; btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold; btn.TextSize = 12; btn.BorderSizePixel = 0; btn.Parent = topBar
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
        return btn
    end

    local minBtn   = MakeWinBtn("—", -58, Color3.fromRGB(60, 60, 60))
    local closeBtn = MakeWinBtn("✕", -28, Color3.fromRGB(200, 50, 50))
    local isMinimized = false
    local fullSize = UDim2.new(0, 300, 0, FRAME_H)
    local miniSize = UDim2.new(0, 300, 0, 36)

    local function HoverTween(btn, hoverColor, baseColor)
        btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.1), { BackgroundColor3 = hoverColor }):Play() end)
        btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.1), { BackgroundColor3 = baseColor  }):Play() end)
    end

    minBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        TweenService:Create(frame, TweenInfo.new(0.2), { Size = isMinimized and miniSize or fullSize }):Play()
        minBtn.Text = isMinimized and "□" or "—"
    end)
    closeBtn.MouseButton1Click:Connect(function()
        TweenService:Create(frame, TweenInfo.new(0.15), { Size = UDim2.new(0,300,0,0), BackgroundTransparency=1 }):Play()
        task.wait(0.2); gui:Destroy()
    end)

    HoverTween(minBtn,   Color3.fromRGB(80,80,80),  Color3.fromRGB(60,60,60))
    HoverTween(closeBtn, Color3.fromRGB(230,70,70), Color3.fromRGB(200,50,50))

    local dragging, dragStart, startPos
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = frame.Position
        end
    end)
    topBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X, startPos.Y.Scale, startPos.Y.Offset+delta.Y)
        end
    end)

    local statusDot = Instance.new("Frame")
    statusDot.Size = UDim2.new(0,8,0,8); statusDot.Position = UDim2.new(0,16,0,46)
    statusDot.BackgroundColor3 = Color3.fromRGB(255,60,60); statusDot.BorderSizePixel = 0; statusDot.Parent = frame
    Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1,0)

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Text = "Tidak Aktif"; statusLabel.Size = UDim2.new(1,-40,0,20); statusLabel.Position = UDim2.new(0,30,0,38)
    statusLabel.BackgroundTransparency = 1; statusLabel.TextColor3 = Color3.fromRGB(180,180,180)
    statusLabel.Font = Enum.Font.Gotham; statusLabel.TextSize = 11
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left; statusLabel.Parent = frame

    local function MakeLabel(text, yPos)
        local lbl = Instance.new("TextLabel")
        lbl.Text = text; lbl.Size = UDim2.new(1,-24,0,14); lbl.Position = UDim2.new(0,12,0,yPos)
        lbl.BackgroundTransparency = 1; lbl.TextColor3 = Color3.fromRGB(130,130,130)
        lbl.Font = Enum.Font.Gotham; lbl.TextSize = 10; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = frame
        return lbl
    end

    local function MakeInput(placeholder, yPos)
        local box = Instance.new("TextBox")
        box.PlaceholderText = placeholder; box.Size = UDim2.new(1,-24,0,28); box.Position = UDim2.new(0,12,0,yPos)
        box.BackgroundColor3 = Color3.fromRGB(35,35,35); box.TextColor3 = Color3.fromRGB(220,220,220)
        box.PlaceholderColor3 = Color3.fromRGB(100,100,100); box.Font = Enum.Font.Gotham; box.TextSize = 10
        box.ClearTextOnFocus = false; box.BorderSizePixel = 0; box.Text = ""
        box.TextXAlignment = Enum.TextXAlignment.Left; box.ClipsDescendants = true; box.Parent = frame
        Instance.new("UICorner", box).CornerRadius = UDim.new(0,6)
        local pad = Instance.new("UIPadding", box); pad.PaddingLeft = UDim.new(0,8); pad.PaddingRight = UDim.new(0,8)
        return box
    end

    MakeLabel("👋 Webhook Join / Leave", 58)
    local inputJoin  = MakeInput("Paste webhook join/leave...", 72)
    MakeLabel("🐋 Webhook Secret Fish", 108)
    local inputFish  = MakeInput("Paste webhook secret fish...", 122)
    MakeLabel("📊 Webhook Stats", 158)
    local inputStats = MakeInput("Paste webhook stats...", 172)
    MakeLabel("🎯 Webhook Event Hunt (Role Nelayan)", 208)
    local inputEvent = MakeInput("Kosong = pakai webhook join/leave...", 222)

    local saveEnabled = false

    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0,36,0,18); toggleBg.Position = UDim2.new(1,-48,0,264)
    toggleBg.BackgroundColor3 = Color3.fromRGB(60,60,60); toggleBg.BorderSizePixel = 0; toggleBg.Parent = frame
    Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1,0)

    local toggleKnob = Instance.new("Frame")
    toggleKnob.Size = UDim2.new(0,14,0,14); toggleKnob.Position = UDim2.new(0,2,0.5,-7)
    toggleKnob.BackgroundColor3 = Color3.fromRGB(200,200,200); toggleKnob.BorderSizePixel = 0; toggleKnob.Parent = toggleBg
    Instance.new("UICorner", toggleKnob).CornerRadius = UDim.new(1,0)

    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Text = "💾 Simpan Config"; toggleLabel.Size = UDim2.new(1,-60,0,18); toggleLabel.Position = UDim2.new(0,12,0,262)
    toggleLabel.BackgroundTransparency = 1; toggleLabel.TextColor3 = Color3.fromRGB(130,130,130)
    toggleLabel.Font = Enum.Font.Gotham; toggleLabel.TextSize = 10
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left; toggleLabel.Parent = frame

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0,36,0,18); toggleBtn.Position = UDim2.new(1,-48,0,264)
    toggleBtn.BackgroundTransparency = 1; toggleBtn.Text = ""; toggleBtn.BorderSizePixel = 0; toggleBtn.Parent = frame

    local function SetToggle(enabled)
        saveEnabled = enabled
        TweenService:Create(toggleKnob, TweenInfo.new(0.15), {
            Position         = enabled and UDim2.new(0,20,0.5,-7) or UDim2.new(0,2,0.5,-7),
            BackgroundColor3 = enabled and Color3.fromRGB(0,220,100) or Color3.fromRGB(200,200,200),
        }):Play()
        TweenService:Create(toggleBg, TweenInfo.new(0.15), {
            BackgroundColor3 = enabled and Color3.fromRGB(0,100,50) or Color3.fromRGB(60,60,60),
        }):Play()
        toggleLabel.TextColor3 = enabled and Color3.fromRGB(0,220,100) or Color3.fromRGB(130,130,130)
    end

    toggleBtn.MouseButton1Click:Connect(function() SetToggle(not saveEnabled) end)

    if savedConfig then
        if savedConfig.webhook_join  and savedConfig.webhook_join  ~= "" then inputJoin.Text  = savedConfig.webhook_join  end
        if savedConfig.webhook_fish  and savedConfig.webhook_fish  ~= "" then inputFish.Text  = savedConfig.webhook_fish  end
        if savedConfig.webhook_stats and savedConfig.webhook_stats ~= "" then inputStats.Text = savedConfig.webhook_stats end
        if savedConfig.webhook_event and savedConfig.webhook_event ~= "" then inputEvent.Text = savedConfig.webhook_event end
        SetToggle(true)
    end

    local startBtn = Instance.new("TextButton")
    startBtn.Text = "START MONITORING"; startBtn.Size = UDim2.new(1,-24,0,34); startBtn.Position = UDim2.new(0,12,0,298)
    startBtn.BackgroundColor3 = Color3.fromRGB(0,180,100); startBtn.TextColor3 = Color3.fromRGB(255,255,255)
    startBtn.Font = Enum.Font.GothamBold; startBtn.TextSize = 12; startBtn.BorderSizePixel = 0; startBtn.Parent = frame
    Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0,6)
    HoverTween(startBtn, Color3.fromRGB(0,210,120), Color3.fromRGB(0,180,100))

    startBtn.MouseButton1Click:Connect(function()
        if SCRIPT_ACTIVE then return end
        if not inputJoin.Text:find("discord.com/api/webhooks") then
            startBtn.Text = "❌ WEBHOOK JOIN INVALID!"; startBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
            task.wait(2); startBtn.Text = "START MONITORING"; startBtn.BackgroundColor3 = Color3.fromRGB(0,180,100)
            return
        end

        WEBHOOK_URL = inputJoin.Text
        if inputFish.Text:find("discord.com/api/webhooks")  then WEBHOOK_FISH  = inputFish.Text  end
        if inputStats.Text:find("discord.com/api/webhooks") then WEBHOOK_STATS = inputStats.Text end
        if inputEvent.Text:find("discord.com/api/webhooks") then WEBHOOK_EVENT = inputEvent.Text end

        if saveEnabled then SaveConfig(WEBHOOK_URL, WEBHOOK_FISH, WEBHOOK_STATS, WEBHOOK_EVENT) end

        SCRIPT_ACTIVE = true
        statusDot.BackgroundColor3 = Color3.fromRGB(0,220,100)
        statusLabel.Text           = "Aktif — Monitoring..."
        statusLabel.TextColor3     = Color3.fromRGB(0,220,100)
        startBtn.Text              = "✅ MONITORING AKTIF"
        startBtn.BackgroundColor3  = Color3.fromRGB(30,30,30)

        for _, box in ipairs({ inputJoin, inputFish, inputStats, inputEvent }) do
            box.TextEditable = false
        end
        toggleBtn.Active = false

        StartMonitoring()
    end)
end

-- ============================================================
--  INIT
-- ============================================================

CreateUI()
