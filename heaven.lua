-- ============================================================
--  BLOX Gank Server Monitor  |  Discord: @bloxgank
-- ============================================================

local HttpService       = game:GetService("HttpService")
local Players           = game:GetService("Players")
local TextChatService    = game:GetService("TextChatService")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")
local CoreGui            = game:GetService("CoreGui")
local TweenService       = game:GetService("TweenService")
local Workspace          = game:GetService("Workspace")

local WEBHOOK_URL         = ""
local WEBHOOK_STATS       = "" -- NOTE: dipertahankan sebagai fallback URL buat "Check Player On Server"
                                -- kalau WEBHOOK_CHECKPLAYER kosong. Embed rekap otomatis "Server Stats"
                                -- yang dulu numpang di sini SUDAH DIHAPUS sesuai request.
local WEBHOOK_FISH        = ""
local WEBHOOK_EVENT       = ""
local WEBHOOK_MUTASI      = ""
local WEBHOOK_CHECKPLAYER = ""
local WEBHOOK_GALATAMA    = "" -- webhook khusus leaderboard Galatama. Kosong = fallback ke WEBHOOK_FISH lalu WEBHOOK_URL.
local WEBHOOK_AVATAR      = ""
local PROXY               = "https://square-haze-a007.remediashop.workers.dev"
local SCRIPT_ACTIVE       = false
local EVENT_NOTIF_ENABLED = true -- toggle ON/OFF khusus notifikasi Event Hunt

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
local EMOJI_RUBY       = "<a:ruby:1517740619794092153>"
local EMOJI_LEGENDARY  = "<a:apiijo:1517778951223902239>"
local EMOJI_TREASURE   = "<a:treasure:1517740647119847516>"
local EMOJI_MEGALODON  = "<a:megablink:1517740677814030437>" -- masih dipakai di EventHuntData yang di-comment (Dark/Megalodon Hunt), jaga-jaga buat reaktivasi
local EMOJI_THUNDER    = "<a:thunder:1517730620250390589>"
local EMOJI_CRYSTAL    = "<a:ruby:1517740619794092153>" -- NOTE: sama persis dgn EMOJI_RUBY, cek lagi apakah emoji crystal-nya beneran ini
local EMOJI_EVENTTAG   = "📢"
local EMOJI_JOIN       = "<a:join:1517738095917924372>"
local EMOJI_LEAVE      = "<a:leave:1517738147914711190>"
local EMOJI_NOTBACK    = "<a:jam:1517740557445894194>"
local EMOJI_CHECK      = "🔍"
local EMOJI_LOCATION   = "📍"
local SEP = EMOJI_SEPARATOR

-- ============================================================
--  MEMBER LIST
-- ============================================================

local MemberList = {
    { username = "zupzupzuppasup",    display = "KEPALASPPGDKIJAKARTA", id = "766292778501275678" },
    { username = "natadecxco",        display = "natarebus",            id = "638355599574171668" },
    { username = "kdryvka",           display = "YIYA",                 id = "1312729486067761162" },
    { username = "cjmin131",          display = "Karaadino",            id = "1506715872612585606" },
    { username = "x_ibo21",           display = "wowo",                 id = "954296542406246400" },
    { username = "evosudin",          display = "Bluuism",              id = "875656564931956766" },
    { username = "minxing_kim",       display = "Minxing",              id = "484295718765461515" },
    { username = "w4terhyacinth",     display = "waterrr",              id = "1309945598409048076" },
    { username = "rexlepwz",          display = "Reeamore",             id = "1205780304753725492" },
    { username = "dekadekadekk",      display = "dekadee",              id = "692735562817470494" },
    { username = "ceriseciscake",     display = "ciscake",              id = "786950836034994216" },
    { username = "mnikndy",           display = "prettyv",              id = "1478607686345035880" },
    { username = "BEJOD06",           display = "MasW",                 id = "1222390041951600640" },
    { username = "flucidious",        display = "fluc",                 id = "279691238494699530" },
    { username = "nahaaa01",          display = "naffz",                id = "1392909983678595244" },
    { username = "AcidReign07",       display = "kiixlau",              id = "1393120438594437161" },
    { username = "minyaktalon9990",   display = "Revv2",                id = "870201488218157107" },
    { username = "alleThetwin",       display = "LikeAvillain",         id = "870201488218157107" },
    { username = "fzallzall",         display = "Ziell",                id = "462346945441038337" },
    { username = "cecillionz1",       display = "ceceyy",               id = "1404117087303110877" },
    { username = "zeylith162",        display = "vexara",               id = "1284490745515999282" },
    { username = "theromantasy",      display = "star",                 id = "1461593359318650880" },
    { username = "choalyn_2",         display = "Alyn_ikaa",            id = "1467390946357416060" },
    { username = "Matchafav17",       display = "Macaaa",               id = "1478634976990859304" },
    { username = "0_Aurorain",        display = "Aurorain",             id = "574581489912643603" },
    { username = "cobadulumogaseru",  display = "lah",                  id = "1451975194397638676" },
    { username = "fuxwing",           display = "hanna",                id = "1284490745515999282" },
    { username = "renjunundip",       display = "aleale",               id = "1428266616763977811" },
    { username = "iloafieus",         display = "mavis",                id = "1440589079086628998" },
    { username = "i95jminn",          display = "azkara",               id = "1506715872612585606" },
    { username = "trianayaa23",       display = "tiarkive",             id = "1425223281686085713" },
    { username = "longisimusdorsii",  display = "strawberry",           id = "1506324307423526913" },
    { username = "Thismeann",         display = "Oceann",               id = "1463858926394015838" },
    { username = "hynad27",           display = "jisoo",                id = "1217043654909366323" },
    { username = "Bintanggg_1111",    display = "niss",                 id = "574581489912643603" },
    { username = "Baeforlife",        display = "Jaemin_choa",          id = "1467390946357416060" },
    { username = "hawaish01",         display = "ilywaa",               id = "1392909983678595244" },
    { username = "kathzeu",           display = "katzu",                id = "669806652375040022" },
    { username = "tantecungkring",    display = "Lavvy",                id = "757111417919766648" },
    { username = "prada2296",         display = "Prada",                id = "1461862687343378468" },
    { username = "bluesjjong",        display = "raxye",                id = "1205780304753725492" },
    { username = "Rambo_4200",        display = "RTBxRamboMYST",        id = "1472822553830621362" },
    { username = "PumpPump369",       display = "PumpPump",             id = "602890650345537555" },
    { username = "Rainoruby",         display = "rain",                 id = "1395401789561507952" },
    { username = "Reinoruby",         display = "ujan",                 id = "1395401789561507952" },
    { username = "Binxxx22",          display = "BinxPVNK77",           id = "952992106421579796" },
    { username = "Lacherve",          display = "RaraPVNK77",           id = "952992106421579796" },
    { username = "biruneptunus",      display = "BiruKC",               id = "962866204203167774" },
    { username = "univastic",         display = "ciel",                 id = "1356280326548230274" },
    { username = "Rambo_4209",        display = "SHOPEFOOD",            id = "1472822553830621362" },
    { username = "ZatzaMMay",         display = "TuyulGomenarai",       id = "892353508160970773" },
    { username = "WaifunyaGomenarai", display = "aci",                  id = "892353508160970773" },
    { username = "furinyawn",         display = "cipii",                id = "1312729486067761162" },
    { username = "bbackburney",       display = "neyyina",              id = "1443066200945852477" },
    { username = "Leale716",          display = "Leaa",                 id = "1408658812424028182" },
    { username = "aca_ri17",          display = "ricarica",             id = "1471486371377053768" },
    { username = "keyrannn1",         display = "key",                  id = "1458430632370769972" },
    { username = "cccaciaa",          display = "chacia",               id = "1427694245455859715" },
    { username = "Ninym_22N",         display = "Chipii",               id = "688544588830343274" },
    { username = "23Skuy2",           display = "BLAZE",                id = "786950836034994216" },
    { username = "waynecalloipe",     display = "ubuungi",              id = "1407648190580133948" },
    { username = "odegaard030",       display = "Kyye",                 id = "1427694245455859715" },
    { username = "zielsalvatore",     display = "salva",                id = "1205780304753725492" },
    { username = "Roikiee1",          display = "Roikiee1",             id = "1447227099206385745" },
    { username = "Mhrshina",          display = "shina",                id = "1125668364489080933" },
    { username = "we4thernnoon",      display = "weather",              id = "1125668364489080933" },
    { username = "andokecheh",        display = "AS×ABMystique_1",      id = "1395401789561507952" },
    { username = "zakeykim",          display = "moonkim",              id = "1391744350714855425" },
    { username = "moonlqghts",        display = "moonkim",              id = "1391744350714855425" },
    { username = "dipyyy",            display = "karyawandripy",        id = "454238781168418826" },
    { username = "caribbeanight",     display = "holly",                id = "869841474332811274" },
    { username = "luwepol",           display = "pakmala",              id = "757111417919766648" },
    { username = "rykalys06",         display = "bebew06",              id = "1488495609961906247" },
    { username = "thewtrmlnz",        display = "karinateary",          id = "1450346429867622480" },
    { username = "pwetyyrlie",        display = "lalaloveu",            id = "1402311023918059520" },
    { username = "Uwellll2",          display = "narumi",               id = "1395401789561507952" },
    { username = "callmeflaviaa",     display = "Piaa",                 id = "757111417919766648" },
    { username = "valalily",          display = "valalily",             id = "706512230627278908" },
    { username = "princekudoo",       display = "shinichi",             id = "757609752149754027" },
    { username = "pettrichoor",       display = "sugengspakbor",        id = "977807235906404422" },
    { username = "nicika204",         display = "ikaa",                 id = "1414865637829906544" },
    { username = "velorisee",         display = "velorisee",            id = "692735562817470494" },
    { username = "userrxyz2",         display = "alaydf",               id = "1425223281686085713" },
    { username = "worldofwis",        display = "FUNxWis",              id = "1185617757446873199" },
    { username = "Ipungkerta7",       display = "Faruq83NXS",           id = "719154955943936090" },
    { username = "Hyrooboy99",        display = "481HyrooSalvatore",    id = "1309945598409048076" },
    { username = "ch0colveuuu",       display = "chocoo",               id = "1410918804036390995" },
    { username = "Th3SwordIsReal",    display = "Yor",                  id = "370151022628175872" },
    { username = "Blckwv3",           display = "Blackwave",            id = "494856245023604736" },
    { username = "sheenaraa13",       display = "shennn",               id = "1427694245455859715" },
    { username = "TalonGiveMeSecret86", display = "Ajudanipung01",      id = "719154955943936090" },
    { username = "Gomenarai",         display = "Gomenarai",            id = "892353508160970773" },
    { username = "ninindiy",          display = "cookiedy",             id = "1414865637829906544" },
    { username = "OliverBMTH98",      display = "Olive",                id = "870201488218157107" },
    { username = "cherryibloss0m",    display = "calaa",                id = "1408407306579869820" },
    { username = "Avochildoo",        display = "Avo",                  id = "1203622473955024896" },
    { username = "raisamaysha",       display = "raisa",                id = "638355599574171668" },
    { username = "sotyaimoet00",      display = "rawr",                 id = "638355599574171668" },
    { username = "archivistie",       display = "archie",               id = "1138846592800129057" },
    { username = "ichinoese",         display = "adza",                 id = "1138846592800129057" },
    { username = "loryn2509",         display = "oyiN",                 id = "1138846592800129057" },
    { username = "xxxkidbloxian1",    display = "coco",                 id = "1138846592800129057" },
    { username = "aumiora",           display = "acil",                 id = "1138846592800129057" },
}

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
    "Elemental Tempestray", "Glacial Serpent", "Caustic Maw", "Coral Reaper",
    "Sunken Hadalith", "Trench Warden", "Caeruleum Razerback", "Two-headed shark", "Ragnarex",
}

local ForgottenList = {
    "Sea Eater", "Thunderzilla", "Iridesca", "Frostbite Leviathan", "Fluorivane",
    "Cerulean Dragon", "Crystalline Behemoth", "Trench Warden", "Ragnarex",
}

local MutasiList = {
    "Noob", "Fairy Dust", "Holographic", "Gemstone", "Fire", "Color Burn",
    "BloodMoon", "Binary", "Lightning", "Disco", "Festive", "Radioactive", "Moon Fragment", "Abyssal",
    -- FIX 6: Aurora & Midnight itu mutasi beneran (sama kayak Abyssal), makanya harus tetap ada di sini.
    -- Masalahnya BUKAN di list ini, tapi di cara deteksi prefix-nya -- lihat MutasiFalsePositiveSpecies di bawah.
    "Aurora", "Midnight",
    -- TODO: kalo mau nambahin "Albino" tinggal masukin string-nya di sini, contoh: "Albino",
}

-- FIX 6: nama SPESIES ikan yang kebetulan diawali kata yang sama kayak nama mutasi beneran
-- (Abyssal Maw Angler, Aurora Grouper, dst). Bedanya sama FIX 4 lama: dulu whitelist ini
-- dicek pakai EXACT match ke seluruh nama ikan, jadi gagal kalau ada kata tambahan di depan
-- (contoh "STONE Aurora Manatee", "Big Aurora Narwhal" -- ada prefix mutasi/qualifier beneran
-- di depan nama spesiesnya). Sekarang FindMutasi akan MEMBUANG dulu substring nama spesies ini
-- dari teks sebelum nyari kata mutasi, jadi sisa "STONE"/"Big" itu yang dicek ke MutasiList,
-- bukan kata "Aurora"/"Abyssal"/"Midnight" yang nempel di nama spesiesnya sendiri.
local MutasiFalsePositiveSpecies = {
    "abyssal maw angler",
    "aurora grouper",
    "aurora starfish",
    "aurora narwhal",
    "aurora manatee",
    "aurora buterfly fish",
    "midnight star squid",
}

local LegendaryCrystalList = {
    "Blue Sea Dragon", "Star Snail", "Cute Dumbo", "Blossom Jelly", "Bioluminescent Octopus",
}

-- ============================================================
--  GALATAMA EVENT — POINT BASED
-- ============================================================

local GalatamaFishPoints = {
    ["Sea Eater"]                = 25000,
    ["Fluorivane"]               = 15000,
    ["Deepsea Monster Axolotl"]  = 2000,
    ["Runic Enchant Stone"]      = 1200,
}

-- Bonus poin mutasi (2 tier). Mutasi di luar list ini (termasuk Big & Shiny) = tidak dihitung.
local GalatamaMutasiPoints = {
    ["sandy"]       = 1000,
    ["ghost"]       = 1000,
    ["stone"]       = 1000,
    ["corrupt"]     = 1000,
    ["gold"]        = 1000,
    ["frozen"]      = 1000,
    ["midnight"]    = 1000,
    ["fairy dust"]  = 10000,
    ["gemstone"]    = 10000,
    ["lightning"]   = 10000,
    ["radioactive"] = 10000,
    ["fire"]        = 10000,
    ["aurora"]      = 10000,
}

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
    ["Glacial Serpent"]           = "1 in 6M",
    ["Elemental Tempestray"]      = "1 in 1M",
    ["Dark Megalodon"]            = "1 in 8M",
    ["Caustic Maw"]               = "1 in 4M",
    ["Coral Reaper"]              = "1 in 6M",
    ["Sunken Hadalith"]           = "1 in ??",
    ["Trench Warden"]             = "1 in 15M",
    ["Caeruleum Razerback"]       = "1 in 3M",
    -- FIX (rapihkan): key ini sebelumnya "two-headed shark" (t kecil), padahal SecretFishList
    -- & FishImageURL pakai "Two-headed shark" (T besar) -- akibatnya field Chance di embed
    -- selalu nongol "Unknown" walau datanya ada, gara-gara lookup case-sensitive gak ketemu.
    ["Two-headed shark"]          = "1 in 3M",
    ["Ragnarex"]                  = "1 in 35M",
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
    ["Leviathan"]                = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Leviathan.png",
    ["Rainbow Comet Shark"]      = "https://raw.githubusercontent.com/revkatomy-max/asset-id/main/Rainbow%20Comet%20Shark.png",
    ["Ruby Gemstone"]            = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/1.png",
    ["Glacial Serpent"]          = "https://raw.githubusercontent.com/revkatomy-max/new-pisit-image/main/81.png",
    ["Machodon"]                 = "https://raw.githubusercontent.com/revkatomy-max/pisit-image/main/42.png",
    ["Crystal"]                  = "https://raw.githubusercontent.com/revkatomy-max/new-pisit-image/main/crystal.png",
    ["treasure hunt"]            = "https://raw.githubusercontent.com/revkatomy-max/new-pisit-image/main/treasure.png",
    ["Caustic Maw"]              = "https://raw.githubusercontent.com/revkatomy-max/new-pisit-image/main/97.png",
    ["Aurora"]                   = "https://raw.githubusercontent.com/revkatomy-max/new-pisit-image/main/99.png",
    ["Coral Reaper"]             = "https://raw.githubusercontent.com/revkatomy-max/new-pisit-image/main/Coral%20Reaper.png",
    ["Trench Warden"]            = "https://raw.githubusercontent.com/revkatomy-max/new-pisit-image/main/Trench%20Warden.png",
    ["Caeruleum Razerback"]      = "https://raw.githubusercontent.com/revkatomy-max/new-pisit-image/main/cureleam%20barbak%20(1).png",
    ["Two-headed shark"]         = "https://raw.githubusercontent.com/revkatomy-max/new-pisit-image/main/Two-headed%20shark.png",
    ["Ragnarex"]                 = "https://raw.githubusercontent.com/revkatomy-max/new-pisit-image/main/104.png",
    ["sc mariana new"]           = "https://raw.githubusercontent.com/revkatomy-max/new-pisit-image/main/106.png",
}

-- Helper case-insensitive buat ambil URL gambar ikan. Ini nyegah kejadian kayak bug
-- "two-headed shark" -- kalau ada typo beda huruf besar/kecil antara SecretFishList/
-- ForgottenList/dll dengan key di FishImageURL, gambar tetap ketemu selama nama dasarnya sama.
local FishImageURLLower = {}
for k, v in pairs(FishImageURL) do
    FishImageURLLower[string.lower(k)] = v
end

local function GetFishImageURL(baseName)
    if not baseName then return nil end
    return FishImageURL[baseName] or FishImageURLLower[string.lower(baseName)]
end

-- ============================================================
--  EVENT HUNT DATABASE
--  Megalodon Hunt, Dark Megalodon Hunt, dan Aurora Borealis DINONAKTIFKAN
--  sesuai request. Sekarang tinggal Treasure Hunt dan Thunderzilla Hunt
--  aja yang bakal kirim notif event. Entry lama dibiarin ke-comment
--  biar gampang diaktifin lagi kalau perlu.
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
    --[[ dinonaktifkan -- Dark Megalodon Hunt
    {
        textTriggers = { "dark megalodon hunt", "dark megalodon" },
        title        = "🌑 Dark Megalodon Hunt Dimulai!",
        description  = "Dark Mega guys " .. EMOJI_MEGALODON,
        color        = 2303786,
        emoji        = "🌑",
        thumbUrl     = FishImageURL["Dark Megalodon"],
    },
    ]]
    --[[ dinonaktifkan -- Megalodon Hunt
    {
        textTriggers = { "megalodon hunt" },
        title        = EMOJI_MEGALODON .. " Megalodon Hunt Dimulai!",
        description  = "Mega gusy 🎣",
        color        = 3447003,
        emoji        = "🦈",
        thumbUrl     = FishImageURL["Megalodon"],
    },
    ]]
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
    --[[ dinonaktifkan -- Aurora Borealis
    {
        textTriggers = { "aurora borealis", "aurora event" },
        title        = "💫 Aurora Borealis!",
        description  = "cantiknyooo",
        color        = 9055202,
        emoji        = "💫",
        thumbUrl     = FishImageURL["Aurora"],
    },
    ]]
}

local EventCooldown = {}

-- ============================================================
--  STATE / CACHE
-- ============================================================

local MentionCache    = {}
local FishImageCache  = {}
local AvatarCache     = {}
local LeaveTimers     = {}
local PlayerStats     = {}
local GalatamaStats   = {} -- [userId] = { name = ..., totalPoints = 0, catches = { [fishBaseName] = { count, totalPoints } } }
local PlayerNameToId  = {}
local SpawnPointCache = {} -- {name, position} hasil scan folder "!!! SPAWN LOCATIONS"

-- ============================================================
--  SAVE CONFIG
-- ============================================================

local CONFIG_FILE = "bloxgank_config.json"

local function SaveConfig(joinUrl, fishUrl, statsUrl, eventUrl, mutasiUrl, checkplayerUrl, galatamaUrl)
    if not writefile then return end
    pcall(function()
        writefile(CONFIG_FILE, HttpService:JSONEncode({
            webhook_join        = joinUrl        or "",
            webhook_fish        = fishUrl        or "",
            webhook_stats       = statsUrl       or "",
            webhook_event       = eventUrl       or "",
            webhook_mutasi      = mutasiUrl      or "",
            webhook_checkplayer = checkplayerUrl or "",
            webhook_galatama    = galatamaUrl    or "",
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

-- Format angka besar jadi singkatan K/M/B (mis. 4500000 -> "4.5M"), buat embed Check Player
local function FormatNumber(n)
    n = tonumber(n)
    if not n then return "N/A" end
    local sign = n < 0 and "-" or ""
    n = math.abs(n)
    if n >= 1000000000 then return sign .. string.format("%.1fB", n / 1000000000)
    elseif n >= 1000000 then return sign .. string.format("%.1fM", n / 1000000)
    elseif n >= 1000     then return sign .. string.format("%.0fK", n / 1000)
    else return sign .. tostring(n) end
end

-- Format angka poin Galatama dengan pemisah ribuan, contoh: 25000 -> "25,000 pts"
local function FormatPoints(n)
    n = math.floor(n or 0)
    local sign = ""
    if n < 0 then sign = "-"; n = -n end
    local s = tostring(n)
    local formatted = s:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
    return sign .. formatted .. " pts"
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
--  MENTION HELPERS
-- ============================================================

local function BuildMentionCache(rbxName, rbxDisplay)
    for _, member in ipairs(MemberList) do
        local uLower = string.lower(member.username)
        local dLower = string.lower(member.display)
        if string.lower(rbxName) == uLower    or string.lower(rbxDisplay) == dLower
        or string.lower(rbxName) == dLower    or string.lower(rbxDisplay) == uLower then
            MentionCache[string.lower(rbxName)]    = member.id
            MentionCache[string.lower(rbxDisplay)] = member.id
        end
    end
end

local function GetMention(robloxName)
    if not robloxName then return "" end
    local lower = string.lower(robloxName)
    if MentionCache[lower] then return "<@" .. MentionCache[lower] .. ">" end
    for _, member in ipairs(MemberList) do
        if string.lower(member.username) == lower or string.lower(member.display) == lower then
            return "<@" .. member.id .. ">"
        end
    end
    return ""
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

-- FIX 3: FindMutasi sebelumnya gagal detect kalau nama mutasi ada di UJUNG string
-- (contoh fish name "Dead Zombie Shark Frozen" -> "Frozen" di ujung, afterPos jadi
-- string kosong sehingga "afterOk" dulu selalu false). Sekarang end-of-string dihitung valid juga.
local function FindMutasi(fishName)
    local lower = string.lower(fishName)

    -- FIX 6: buang dulu substring nama SPESIES (bukan exact match seluruh nama ikan lagi),
    -- supaya kata mutasi asli (Abyssal/Aurora/Midnight) yang nempel di nama spesies gak
    -- ketauan sebagai mutasi, TAPI kata di depan/belakangnya (mutasi beneran, mis. "Stone",
    -- "Fire", dst -- kalau ada) tetap bisa kedetect karena sisa teksnya tetap dicek di bawah.
    for _, species in ipairs(MutasiFalsePositiveSpecies) do
        local s = string.find(lower, species, 1, true)
        if s then
            local beforeOk = (s == 1) or (lower:sub(s - 1, s - 1) == " ")
            local afterPos = s + #species
            local afterOk  = (afterPos > #lower) or (lower:sub(afterPos, afterPos) == " ")
            if beforeOk and afterOk then
                lower = Trim((lower:sub(1, s - 1) .. " " .. lower:sub(afterPos + 1)):gsub("%s+", " "))
                break
            end
        end
    end
    if lower == "" then return nil end

    for _, mutasiName in ipairs(MutasiList) do
        local mutasiLower = string.lower(mutasiName)
        local s = string.find(lower, mutasiLower, 1, true)
        if s then
            local beforeOk = (s == 1) or (lower:sub(s - 1, s - 1) == " ")
            local afterPos = s + #mutasiLower
            local afterOk  = (afterPos > #lower) or (lower:sub(afterPos, afterPos) == " ")
            if beforeOk and afterOk then
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

-- Cari poin bonus mutasi Galatama. Return 0 kalau mutasi kosong, Big/Shiny, atau tidak dikenal.
local function GetGalatamaMutasiPoints(mutasi)
    if not mutasi or mutasi == "" then return 0, nil end
    local ml = mutasi:lower()
    for name, pts in pairs(GalatamaMutasiPoints) do
        if ml == name then return pts, mutasi end
    end
    return 0, nil
end

local function FindGalatamaFish(baseName)
    if not baseName then return nil end
    local lower = baseName:lower()
    for name, _ in pairs(GalatamaFishPoints) do
        if lower == name:lower() then return name end
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
--  CHECK PLAYER ON SERVER
--  Ambil Caught & Map (lokasi) dari leaderstats tiap player,
--  plus scan Server Luck & timer sisa dari teks GUI game.
-- ============================================================

-- Cari child dengan nama tertentu di dalam sebuah container (leaderstats, dll).
local function FindValueByName(container, names)
    if not container then return nil end
    for _, n in ipairs(names) do
        local child = container:FindFirstChild(n)
        if child then return child end
    end
    return nil
end

-- Cari ke SELURUH descendant instance (bukan cuma leaderstats) buat nama yang match,
-- dipakai sebagai fallback kalau statnya ternyata gak ada di leaderstats.
local function FindValueRecursive(instance, names)
    if not instance then return nil end
    local wanted = {}
    for _, n in ipairs(names) do wanted[string.lower(n)] = true end
    for _, desc in ipairs(instance:GetDescendants()) do
        if wanted[string.lower(desc.Name)] then
            local ok = pcall(function() return desc.Value end)
            if ok then return desc end
        end
    end
    return nil
end

-- Cari value Map/Location di dalam WORKSPACE, bukan cuma di dalam Player itu sendiri.
-- Beberapa game nyimpen data per-player di folder terpisah di workspace
-- (misal workspace.PlayerName.Map), bukan di leaderstats.
local function FindPlayerValueInWorkspace(player, names)
    if not player then return nil end

    -- pola umum #1: ada folder di workspace yang namanya SAMA PERSIS kayak nama player
    local playerFolder = Workspace:FindFirstChild(player.Name)
    if playerFolder then
        local direct = FindValueByName(playerFolder, names)
        if direct then return direct end
        local nested = FindValueRecursive(playerFolder, names)
        if nested then return nested end
    end

    -- pola umum #2: scan seluruh descendant workspace, cari instance yang namanya
    -- match, TAPI cuma dianggap valid kalau salah satu leluhurnya juga ada nama playernya
    -- (biar gak ketuker sama punya player lain).
    local lowerPlayerName = string.lower(player.Name)
    local wanted = {}
    for _, n in ipairs(names) do wanted[string.lower(n)] = true end

    for _, desc in ipairs(Workspace:GetDescendants()) do
        if wanted[string.lower(desc.Name)] then
            local ok = pcall(function() return desc.Value end)
            if ok then
                local anc = desc.Parent
                while anc and anc ~= Workspace do
                    if string.lower(anc.Name) == lowerPlayerName then return desc end
                    anc = anc.Parent
                end
            end
        end
    end

    return nil
end

-- ============================================================
--  NEAREST SPAWN LOCATION (fallback lokasi player)
--  Game ini gak nge-track lokasi player lewat stat, jadi kita
--  hitung sendiri: cari SpawnLocation terdekat dari posisi
--  HumanoidRootPart player. Posisi character direplikasi ke semua
--  client jadi ini reliable, beda sama data privat semacam stat.
-- ============================================================

local SPAWN_FOLDER_NAME  = "!!! SPAWN LOCATIONS"
local SPAWN_MAX_DISTANCE = 400 -- studs, di atas ini dianggap "Unknown Area"

local function CacheSpawnLocations()
    SpawnPointCache = {}
    local folder = Workspace:FindFirstChild(SPAWN_FOLDER_NAME)
    if not folder then
        warn("[BLOX Gank DEBUG] Folder '" .. SPAWN_FOLDER_NAME .. "' tidak ditemukan di Workspace!")
        return
    end

    for _, obj in ipairs(folder:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find("spawn", 1, true) then
            local lowerName = obj.Name:lower()
            local areaName

            if lowerName == "spawnlocation" or lowerName == "spawn" then
                -- struktur aslinya "!!! SPAWN LOCATIONS" > "<Nama Area>" > "SpawnLocation"
                -- (part-nya sendiri namanya generik "SpawnLocation"), jadi nama area
                -- diambil dari PARENT folder-nya, bukan dari nama part itu sendiri.
                areaName = obj.Parent and obj.Parent.Name or nil
            else
                -- fallback lama: kalau part-nya bernama "Copper Canyon SpawnLocation"
                areaName = obj.Name:gsub("%s*[Ss]pawn[Ll]ocation%s*$", "")
            end

            areaName = areaName and Trim(areaName) or nil
            if areaName and areaName ~= "" then
                table.insert(SpawnPointCache, { name = areaName, position = obj.Position })
            end
        end
    end

    print("[BLOX Gank DEBUG] CacheSpawnLocations: ketemu " .. #SpawnPointCache .. " spawn point.")
    for _, sp in ipairs(SpawnPointCache) do
        print("    [SPAWN POINT] " .. sp.name .. " @ " .. tostring(sp.position))
    end
end

-- Cari nama area terdekat dari posisi karakter player.
local function GetNearestSpawnArea(player)
    if #SpawnPointCache == 0 then return nil end
    local char = player and player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    local charPos = root.Position
    local nearestName, nearestDist = nil, math.huge

    for _, sp in ipairs(SpawnPointCache) do
        local dist = (charPos - sp.position).Magnitude
        if dist < nearestDist then
            nearestDist = dist
            nearestName = sp.name
        end
    end

    if nearestName and nearestDist <= SPAWN_MAX_DISTANCE then
        return nearestName
    end
    return nil -- terlalu jauh dari spawn manapun, gak yakin lokasinya
end

-- Ambil nilai Caught & Map dari leaderstats player (nama stat asli:
-- Pemain / caught, dan lokasi disimpan di stat "Map").
local function GetPlayerStatsAndLocation(player)
    local caught, location = "N/A", "N/A"
    if not player then return caught, location end
    local ls = player:FindFirstChild("leaderstats")

    local caughtStat = FindValueByName(ls, { "caught", "Caught" })
    if caughtStat then caught = FormatNumber(caughtStat.Value) end

    -- Urutan pencarian Map: leaderstats -> seluruh descendant player -> workspace -> attribute -> NEAREST SPAWN (fallback terakhir)
    local locStat = FindValueByName(ls, { "Map", "map", "Location", "Zone" })
        or FindValueRecursive(player, { "Map", "map", "Location", "Zone" })
        or FindPlayerValueInWorkspace(player, { "Map", "map", "Location", "Zone" })
    if locStat then
        location = tostring(locStat.Value)
    else
        -- coba baca dari Attribute (bukan child Instance)
        local attrLoc = player:GetAttribute("Map") or player:GetAttribute("map")
            or player:GetAttribute("Location") or player:GetAttribute("Zone")
        if attrLoc ~= nil then
            location = tostring(attrLoc)
        else
            -- fallback terakhir -- game ini gak nge-track lokasi lewat stat,
            -- jadi hitung sendiri dari posisi player vs SpawnLocation terdekat.
            local nearest = GetNearestSpawnArea(player)
            if nearest then location = nearest .. " (est.)" end
        end
    end

    return caught, location
end

-- NOTE: ini scanner HEURISTIK (nebak dari pola teks), karena Server Luck &
-- End Server Luck cuma ada di GUI game (bukan value/stat). Kalau hasilnya
-- kosong/salah, cek langsung teks GUI game-nya dan sesuaikan pattern di bawah ini.
local function ScanServerLuckInfo()
    local luckValue, luckEnds = nil, nil
    local pg = Players.LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return luckValue, luckEnds end

    for _, v in ipairs(pg:GetDescendants()) do
        if v:IsA("TextLabel") or v:IsA("TextButton") then
            local t = v.Text or ""
            if t ~= "" then
                if not luckValue then
                    local m = t:match("[Ll]uck.-x%s*(%d+)") or t:match("x%s*(%d+).-[Ll]uck")
                    if m then luckValue = m end
                end
                if not luckEnds then
                    local h, m2, s = t:match("(%d+)h%s*(%d+)m%s*(%d+)s")
                    if h then luckEnds = h .. "h " .. m2 .. "m " .. s .. "s" end
                end
            end
        end
        if luckValue and luckEnds then break end
    end

    return luckValue, luckEnds
end

-- Susun deskripsi embed persis format "Check Player On Server"
local function BuildPlayerCheckDescription()
    local players = Players:GetPlayers()
    local lines = {}

    table.insert(lines, "Total player aktif: **" .. #players .. "**")
    table.insert(lines, "")

    for _, p in ipairs(players) do
        local caught, location = GetPlayerStatsAndLocation(p)
        table.insert(lines, string.format(
            "• **%s** - 🐟 Caught: %s - %s %s",
            p.Name, caught, EMOJI_LOCATION, location
        ))
    end

    table.insert(lines, "")
    local luckVal, luckEnds = ScanServerLuckInfo()
    table.insert(lines, "• **Server Luck** : x" .. (luckVal or "?"))
    table.insert(lines, "• **End Server Luck** : Ends: " .. (luckEnds or "?"))
    table.insert(lines, "")
    table.insert(lines, "Updated: " .. os.date("%d/%m/%Y %H:%M:%S"))

    return table.concat(lines, "\n")
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
    if not requestFunc then
        warn("[BLOX Gank DEBUG] PostWebhook gagal: gak ketemu request function (syn.request/http.request/http_request/fluxus.request/request semuanya nil). Executor lo mungkin gak support salah satu dari itu.")
        return
    end
    if url == "" then
        warn("[BLOX Gank DEBUG] PostWebhook gagal: url webhook KOSONG (\"\"). Cek input webhooknya udah keisi belum pas klik START MONITORING.")
        return
    end
    task.spawn(function()
        local ok, err = pcall(function()
            local res = requestFunc({
                Url     = url,
                Method  = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body    = HttpService:JSONEncode(body),
            })
            local status = res and (res.StatusCode or res.status_code)
            if status and (status < 200 or status >= 300) then
                warn("[BLOX Gank DEBUG] Webhook response bukan 2xx! Status: " .. tostring(status) .. " | Body: " .. tostring(res.Body or res.body))
            end
        end)
        if not ok then
            warn("[BLOX Gank DEBUG] PostWebhook ERROR pas request: " .. tostring(err))
        end
    end)
end

local function BuildContent(mention, captionType)
    if not mention or mention == "" then return nil end
    local m = Trim(mention)
    if captionType == "secret" or captionType == "forgotten" then return "Hari hari bersyukur " .. m
    elseif captionType == "leave"   then return "ke disconect ya? " .. m
    elseif captionType == "join"    then return "alhamdulilah kembali " .. m
    elseif captionType == "notback" then return "lah kok ngilang " .. m
    elseif captionType == "mutasi"  then return "cek mutasinya " .. m
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

-- Webhook khusus mutasi list, terpisah dari webhook secret fish.
-- Fallback: kalau WEBHOOK_MUTASI kosong -> pakai WEBHOOK_FISH -> kalau itu juga kosong pakai WEBHOOK_URL.
local function SendMutasiWebhook(title, description, color, fields, imageUrl, thumbUrl, mention, captionType)
    local url = (WEBHOOK_MUTASI ~= "") and WEBHOOK_MUTASI
        or ((WEBHOOK_FISH ~= "") and WEBHOOK_FISH or WEBHOOK_URL)
    if url == "" then return end
    local f = {}
    for _, v in ipairs(fields) do table.insert(f, v) end
    PostWebhook(url, {
        username   = "BLOX Gank Mutasi",
        avatar_url = WEBHOOK_AVATAR,
        content    = BuildContent(mention, captionType),
        embeds     = { BuildEmbed(title, description, color, f, imageUrl, thumbUrl, "BLOX Gank Mutasi List") },
    })
end

-- Webhook "Check Player On Server" -- kirim daftar semua player + coin + lokasi + server luck.
-- Fallback: kalau WEBHOOK_CHECKPLAYER kosong -> pakai WEBHOOK_STATS -> kalau itu juga kosong pakai WEBHOOK_URL.
local function SendPlayerCheckWebhook()
    local url = (WEBHOOK_CHECKPLAYER ~= "") and WEBHOOK_CHECKPLAYER
        or ((WEBHOOK_STATS ~= "") and WEBHOOK_STATS or WEBHOOK_URL)

    print("[BLOX Gank DEBUG] SendPlayerCheckWebhook dipanggil. WEBHOOK_CHECKPLAYER='" .. tostring(WEBHOOK_CHECKPLAYER)
        .. "' WEBHOOK_STATS='" .. tostring(WEBHOOK_STATS) .. "' WEBHOOK_URL='" .. tostring(WEBHOOK_URL)
        .. "' -> dipakai: '" .. tostring(url) .. "'")

    if url == "" then
        warn("[BLOX Gank DEBUG] SendPlayerCheckWebhook batal: gak ada webhook valid sama sekali (checkplayer/stats/join semuanya kosong).")
        return
    end

    local description = BuildPlayerCheckDescription()
    print("[BLOX Gank DEBUG] Deskripsi embed panjangnya " .. tostring(#description) .. " karakter")
    PostWebhook(url, {
        username   = "BLOX Gank",
        avatar_url = WEBHOOK_AVATAR,
        embeds     = { BuildEmbed(
            EMOJI_CHECK .. " Check Player On Server " .. Players.LocalPlayer.Name,
            description,
            TierColors.Join,
            {},
            nil, nil,
            "BLOX Gank Check Player"
        )},
    })
end

-- ============================================================
--  GALATAMA LEADERBOARD
-- ============================================================

local function SendGalatamaLeaderboard()
    local leaderData = {}
    for _, gs in pairs(GalatamaStats) do
        if (gs.totalPoints or 0) > 0 then
            local catchLines = {}
            for fishName, catchData in pairs(gs.catches) do
                local count = catchData.count or 0
                local p     = catchData.totalPoints or 0
                table.insert(catchLines, fishName .. " x" .. count .. " (" .. FormatPoints(p) .. ")")
            end
            table.insert(leaderData, {
                name        = gs.name,
                totalPoints = gs.totalPoints,
                catchStr    = #catchLines > 0 and table.concat(catchLines, "\n") or "-",
            })
        end
    end
    if #leaderData == 0 then return end
    table.sort(leaderData, function(a, b) return a.totalPoints > b.totalPoints end)

    local medals = { "🥇", "🥈", "🥉" }
    local fields = {}
    for i, entry in ipairs(leaderData) do
        if i > 10 then break end
        local medal = medals[i] or ("#" .. i)
        table.insert(fields, {
            name   = medal .. " " .. entry.name .. " — ⚖️ " .. FormatPoints(entry.totalPoints),
            value  = entry.catchStr,
            inline = false,
        })
    end

    local url = (WEBHOOK_GALATAMA ~= "") and WEBHOOK_GALATAMA
        or ((WEBHOOK_FISH ~= "") and WEBHOOK_FISH or WEBHOOK_URL)
    if url == "" then return end

    PostWebhook(url, {
        username   = "BLOX Gank Galatama",
        avatar_url = WEBHOOK_AVATAR,
        embeds     = { BuildEmbed(
            "🏆 LEADERBOARD GALATAMA",
            "```\nIkan: Sea Eater (25,000) | Fluorivane (15,000) | Deepsea Monster Axolotl (2,000) | Runic Enchant Stone (1,200)\nBonus Mutasi: Sandy/Ghost/Stone/Corrupt/Gold/Frozen/Midnight +1,000 | Fairy Dust/Gemstone/Lightning/Radioactive/Fire/Aurora +10,000\nBig & Shiny: tidak dihitung\n```",
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
--  Event aktif sekarang: Treasure Hunt, Thunderzilla Hunt, & Crystal Event.
--  Filter relevansi cek keyword "hunt" ATAU "crystal" sebelum masuk ke
--  pengecekan trigger detail per-event di bawah.
-- ============================================================

local _hookedLabels = {}

-- Edge-trigger per-label: notif cuma dikirim sekali pas teks label itu PERTAMA KALI
-- berubah dari "gak match trigger" jadi "match trigger". Selama label itu masih
-- nampilin teks yang match (misal ada countdown "Ends in 04:32" yang update tiap
-- detik), gak akan re-trigger. EVENT_COOLDOWN_SECONDS + EventCooldown dibiarin
-- sebagai pengaman tambahan (misal ada 2 label GUI berbeda buat event yang sama).
local LabelEventState = {} -- [label] = { [eventTitle] = true/false (match state terakhir) }

local function ProcessEventText(text, label)
    if not SCRIPT_ACTIVE then return end
    if not EVENT_NOTIF_ENABLED then return end
    if not text or text == "" then return end
    local lower = text:lower()

    local isRelevant = lower:find("hunt") or lower:find("crystal")

    local state = LabelEventState[label]
    if not state then
        state = {}
        LabelEventState[label] = state
    end

    for _, evData in ipairs(EventHuntData) do
        local matched = false
        if isRelevant then
            for _, trigger in ipairs(evData.textTriggers) do
                if lower:find(trigger, 1, true) then matched = true; break end
            end
        end

        local wasMatched = state[evData.title] or false
        state[evData.title] = matched

        -- kirim CUMA pas transisi OFF -> ON (event baru mulai), bukan tiap kali teks berubah
        if matched and not wasMatched then
            local now = os.time()
            if (now - (EventCooldown[evData.title] or 0)) >= EVENT_COOLDOWN_SECONDS then
                EventCooldown[evData.title] = now
                SendEventWebhook(evData, text)
            end
        end
    end
end

local function HookLabel(label)
    if _hookedLabels[label] then return end
    _hookedLabels[label] = true
    ProcessEventText(label.Text, label)
    label:GetPropertyChangedSignal("Text"):Connect(function()
        ProcessEventText(label.Text, label)
    end)
    -- bersihin state pas label ke-destroy, biar gak numpuk memory kalau GUI sering bikin/hapus label
    label.AncestryChanged:Connect(function(_, parent)
        if not parent then LabelEventState[label] = nil end
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

    local targetPlayer = FindPlayer(data.player)
    local uid = (targetPlayer and targetPlayer.UserId)
             or PlayerNameToId[string.lower(data.player)]
    local avatarUrl = GetAvatarUrlById(uid)

    if uid then
        if not PlayerStats[uid] then
            PlayerStats[uid] = { catchCount = 0, secretList = {}, joinTime = os.time(), name = data.player }
        end
        PlayerStats[uid].catchCount = PlayerStats[uid].catchCount + 1
    end

    local legendaryBase = FindLegendaryCrystal(data.fish)
    if legendaryBase then
        local imageUrl = GetFishImageURL(legendaryBase) or (FishImageCache[legendaryBase] and (PROXY .. "/asset/" .. FishImageCache[legendaryBase]))
        SendFishWebhook(EMOJI_LEGENDARY .. " Crystalized Legendary!", " " .. EMOJI_MUTASI, TierColors.Legendary, {
            { name = SEP .. " Pemain", value = "**" .. data.player .. "**", inline = true },
            { name = SEP .. " Item",   value = "**" .. data.fish .. "**",   inline = true },
            { name = SEP .. " Berat",  value = "**" .. data.weight .. "**", inline = true },
        }, nil, imageUrl, nil, "secret")
        return
    end

    local rubyBase = FindRuby(data.fish)
    if rubyBase then
        local imageUrl = GetFishImageURL(rubyBase) or (FishImageCache[rubyBase] and (PROXY .. "/asset/" .. FishImageCache[rubyBase]))
        SendFishWebhook(EMOJI_RUBY .. " Ruby Gemstone!", "Goceng" .. EMOJI_RUBY, TierColors.Ruby, {
            { name = SEP .. " Pemain", value = "**" .. data.player .. "**", inline = true },
            { name = SEP .. " Item",   value = "**" .. data.fish .. "**",   inline = true },
            { name = SEP .. " Berat",  value = "**" .. data.weight .. "**", inline = true },
        }, nil, imageUrl, nil, "secret")
        return
    end

    local baseName, mutasi = FindSecretFish(data.fish)
    if baseName then
        local imageUrl = GetFishImageURL(baseName) or (FishImageCache[baseName] and (PROXY .. "/asset/" .. FishImageCache[baseName]))
        local isForgotten = false
        for _, name in ipairs(ForgottenList) do
            if string.lower(baseName) == string.lower(name) then isForgotten = true; break end
        end
        if uid and PlayerStats[uid] then
            PlayerStats[uid].secretList[baseName] = (PlayerStats[uid].secretList[baseName] or 0) + 1
        end
        local chanceInfo  = FishChanceData[baseName] or "Unknown"
        local mutasiField = mutasi and (EMOJI_MUTASI .. " *" .. mutasi .. "*") or "—"
        local fields = {
            { name = SEP .. " Pemain", value = "**" .. data.player .. "**", inline = true },
            { name = SEP .. " Ikan",   value = "**" .. data.fish .. "**",   inline = true },
            { name = SEP .. " Berat",  value = "**" .. data.weight .. "**", inline = true },
            { name = SEP .. " Mutasi", value = mutasiField,                  inline = true },
            { name = SEP .. " Chance", value = chanceInfo,                   inline = true },
        }

        -- Galatama point scoring
        local galBase = FindGalatamaFish(baseName)
        if galBase and uid then
            if not GalatamaStats[uid] then
                GalatamaStats[uid] = { name = data.player, totalPoints = 0, catches = {} }
            end
            local basePoints = GalatamaFishPoints[galBase]
            local mutasiBonus, bonusLabel = GetGalatamaMutasiPoints(mutasi)
            local totalAdded = basePoints + mutasiBonus

            GalatamaStats[uid].totalPoints = GalatamaStats[uid].totalPoints + totalAdded
            if not GalatamaStats[uid].catches[galBase] then
                GalatamaStats[uid].catches[galBase] = { count = 0, totalPoints = 0 }
            end
            GalatamaStats[uid].catches[galBase].count       = GalatamaStats[uid].catches[galBase].count + 1
            GalatamaStats[uid].catches[galBase].totalPoints = GalatamaStats[uid].catches[galBase].totalPoints + totalAdded

            local totalNow = GalatamaStats[uid].totalPoints

            local galDesc
            if mutasiBonus > 0 then
                galDesc = "**+" .. FormatPoints(totalAdded) .. "**"
                    .. " (" .. FormatPoints(basePoints) .. " base + " .. FormatPoints(mutasiBonus) .. " bonus mutasi 🌀 *" .. (bonusLabel or mutasi) .. "*)"
                    .. "\ntotal: **" .. FormatPoints(totalNow) .. "**"
            else
                galDesc = "**+" .. FormatPoints(totalAdded) .. "**"
                if mutasi then galDesc = galDesc .. " *(mutasi " .. mutasi .. " — no bonus)*" end
                galDesc = galDesc .. "\ntotal: **" .. FormatPoints(totalNow) .. "**"
            end

            table.insert(fields, { name = "⚖️ Galatama", value = galDesc, inline = false })
        end

        if isForgotten then
            SendFishWebhook(EMOJI_FORGOTTEN .. " Forgotten Tier Detected!", " " .. EMOJI_FORGOTTEN, TierColors.Forgotten, fields, nil, imageUrl, GetMention(data.player), "forgotten")
        else
            SendFishWebhook(EMOJI_NOTIF .. " Secret Fish Detected!", " ", TierColors.Secret, fields, nil, imageUrl, GetMention(data.player), "secret")
        end
        return
    end

    -- Mutasi (di luar secret fish) dikirim ke webhook mutasi sendiri, tanpa mention.
    local mutasiDetected = FindMutasi(data.fish)
    if not mutasiDetected then return end

    if uid and PlayerStats[uid] then
        PlayerStats[uid].mutasiCount = (PlayerStats[uid].mutasiCount or 0) + 1
    end

    SendMutasiWebhook(
        EMOJI_MUTASI .. " Mutasi Terdeteksi!", "", TierColors.Mutasi,
        {
            { name = SEP .. " Pemain", value = "**" .. data.player .. "**",            inline = true },
            { name = SEP .. " Ikan",   value = "**" .. data.fish .. "**",              inline = true },
            { name = SEP .. " Berat",  value = "**" .. data.weight .. "**",            inline = true },
            { name = SEP .. " Mutasi", value = EMOJI_MUTASI .. " " .. mutasiDetected,  inline = true },
        },
        nil, avatarUrl, nil, "mutasi"
    )
end

-- ============================================================
--  BACKPACK MONITOR
-- ============================================================

local function WatchBackpack(bp)
    bp.ChildAdded:Connect(function(item)
        task.wait(0.1)
        local baseName = FindSecretFish(item.Name)
        if baseName and not GetFishImageURL(baseName) and not FishImageCache[baseName] then
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

            -- Command manual buat trigger "Check Player On Server" kapan aja.
            -- Ketik !checkplayer di chat game buat langsung kirim ke webhook.
            local lowerText = Trim(string.lower(text))
            if lowerText == "!checkplayer" then
                SendPlayerCheckWebhook()
            elseif lowerText == "!galatamalb" then
                SendGalatamaLeaderboard()
            end
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
                local trimmedMsg = Trim(lowerMsg)
                if trimmedMsg == "!checkplayer" then
                    SendPlayerCheckWebhook()
                elseif trimmedMsg == "!galatamalb" then
                    SendGalatamaLeaderboard()
                end
            end)
        end
    end
end

-- ============================================================
--  START MONITORING
-- ============================================================

local function StartMonitoring()
    CacheSpawnLocations() -- scan folder "!!! SPAWN LOCATIONS" sekali di awal monitoring

    local allPlayers = Players:GetPlayers()
    local names      = {}
    for _, p in ipairs(allPlayers) do table.insert(names, p.Name) end

    SendWebhook(EMOJI_STARTER .. " Monitor Started", "Server monitor sudah aktif", TierColors.Join, {
        { name = SEP .. " Host",          value = "**" .. Players.LocalPlayer.Name .. "**",     inline = true  },
        { name = SEP .. " Total Player",  value = "**" .. tostring(#allPlayers) .. "** orang",   inline = true  },
        { name = SEP .. " Daftar Player", value = "```\n" .. table.concat(names, ", ") .. "```", inline = false },
    })

    HookChat()
    StartEventMonitor()

    -- NOTE: webhook "Check Player On Server" cuma kekirim kalau di-trigger manual
    -- (klik tombol CHECK PLAYER di panel, atau ketik "!checkplayer" di chat game).
    -- Gak ada loop auto-send / rekap otomatis lagi.

    for _, p in ipairs(allPlayers) do
        WatchForFish(p)
        AvatarCache[p.UserId]                       = GetAvatarUrlById(p.UserId)
        PlayerStats[p.UserId]                       = { catchCount = 0, secretList = {}, joinTime = os.time(), name = p.Name }
        PlayerNameToId[string.lower(p.Name)]        = p.UserId
        PlayerNameToId[string.lower(p.DisplayName)] = p.UserId
        BuildMentionCache(p.Name, p.DisplayName)
    end

    Players.PlayerAdded:Connect(function(player)
        if not SCRIPT_ACTIVE then return end
        LeaveTimers[player.UserId] = nil
        PlayerStats[player.UserId] = { catchCount = 0, secretList = {}, joinTime = os.time(), name = player.Name }
        PlayerNameToId[string.lower(player.Name)]        = player.UserId
        PlayerNameToId[string.lower(player.DisplayName)] = player.UserId
        BuildMentionCache(player.Name, player.DisplayName)
        task.spawn(function()
            task.wait(1)
            AvatarCache[player.UserId] = GetAvatarUrlById(player.UserId)
            SendWebhook(EMOJI_JOIN .. " Player Joined Server", "welcam", TierColors.Join, {
                { name = SEP .. " Username",     value = "**" .. player.Name .. "**",                     inline = true },
                { name = SEP .. " Total Player", value = "**" .. tostring(#Players:GetPlayers()) .. "**", inline = true },
            }, nil, AvatarCache[player.UserId], GetMention(player.Name), "join")
        end)
        WatchForFish(player)
    end)

    Players.PlayerRemoving:Connect(function(player)
        if not SCRIPT_ACTIVE then return end
        local pName      = player.Name
        local pId        = player.UserId
        local avatarUrl  = AvatarCache[pId] or GetAvatarUrlById(pId)
        local totalNow   = #Players:GetPlayers() - 1
        local mentionStr = GetMention(pName)

        AvatarCache[pId]                    = nil
        PlayerStats[pId]                    = nil
        PlayerNameToId[string.lower(pName)] = nil
        for k, v in pairs(PlayerNameToId) do if v == pId then PlayerNameToId[k] = nil end end
        MentionCache[string.lower(pName)]   = nil

        SendWebhook(EMOJI_LEAVE .. " Player Left Server", "Salah satu pemain keluar server.", TierColors.Leave, {
            { name = SEP .. " Username",     value = "**" .. pName .. "**",              inline = true },
            { name = SEP .. " Total Player", value = "**" .. tostring(totalNow) .. "**", inline = true },
        }, nil, avatarUrl, mentionStr, "leave")

        LeaveTimers[pId] = true
        task.spawn(function()
            task.wait(600)
            if LeaveTimers[pId] then
                LeaveTimers[pId] = nil
                local notBackContent = BuildContent(mentionStr, "notback")
                PostWebhook(WEBHOOK_URL, {
                    username   = "BLOX Gank",
                    avatar_url = WEBHOOK_AVATAR,
                    content    = notBackContent,
                    embeds     = { BuildEmbed(EMOJI_NOTBACK .. " Player Tidak Kembali", "Pemain ini belum balik lagi ke server, semoga aman ya~", TierColors.NotBack, {
                        { name = SEP .. " Username", value = "**" .. pName .. "**",               inline = true },
                        { name = SEP .. " Info",     value = "Tidak kembali selama **10 menit**", inline = true },
                    }, avatarUrl, nil, "BLOX Gank Webhook") },
                })
            end
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

    -- Webhook inputs + toggle ditaruh di ScrollingFrame + UIListLayout supaya otomatis
    -- nyusun elemen berurutan tanpa nabrak, dan bisa di-scroll kalau kepanjangan.
    -- Tombol aksi (CHECK PLAYER / START) tetap fixed di bawah, di luar scroll,
    -- biar selalu keliatan & gampang dijangkau.
    local FRAME_H = 430
    local frame = Instance.new("Frame")
    frame.Name             = "Main"
    frame.Size             = UDim2.new(0, 300, 0, FRAME_H)
    frame.AnchorPoint       = Vector2.new(0.5, 0.5)
    frame.Position          = UDim2.new(0.5, 0, 0.5, 0)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BorderSizePixel  = 0
    frame.ClipsDescendants = true
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

    local title = Instance.new("TextLabel")
    title.Text = "🎣 BLOX Gank Monitor"; title.Size = UDim2.new(1, -80, 1, 0); title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1; title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold; title.TextSize = 13; title.TextXAlignment = Enum.TextXAlignment.Left; title.Parent = topBar

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

    minBtn.MouseButton1Click:Connect(function()
        frame.Visible = false
    end)

    -- ============================================================
    --  FLOATING LOGO INDICATOR
    -- ============================================================
    local floatLogo = Instance.new("ImageButton")
    floatLogo.Name             = "BloxGankFloatLogo"
    floatLogo.Size             = UDim2.new(0, 46, 0, 46)
    floatLogo.Position         = UDim2.new(0, 20, 0, 90)
    floatLogo.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    floatLogo.Image            = BRAND_ICON
    floatLogo.ScaleType        = Enum.ScaleType.Crop
    floatLogo.BorderSizePixel  = 0
    floatLogo.ZIndex           = 5
    floatLogo.Parent           = gui
    Instance.new("UICorner", floatLogo).CornerRadius = UDim.new(1, 0)

    local floatStroke = Instance.new("UIStroke")
    floatStroke.Color     = Color3.fromRGB(50, 50, 50)
    floatStroke.Thickness = 2
    floatStroke.Parent    = floatLogo

    local floatStatusDot = Instance.new("Frame")
    floatStatusDot.Size             = UDim2.new(0, 14, 0, 14)
    floatStatusDot.Position         = UDim2.new(1, -14, 1, -14)
    floatStatusDot.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    floatStatusDot.BorderSizePixel  = 0
    floatStatusDot.ZIndex           = 6
    floatStatusDot.Parent           = floatLogo
    Instance.new("UICorner", floatStatusDot).CornerRadius = UDim.new(1, 0)

    local floatStatusDotStroke = Instance.new("UIStroke")
    floatStatusDotStroke.Color     = Color3.fromRGB(20, 20, 20)
    floatStatusDotStroke.Thickness = 2
    floatStatusDotStroke.Parent    = floatStatusDot

    local floatPulseTween = nil
    local function SetFloatStatus(active)
        floatStatusDot.BackgroundColor3 = active and Color3.fromRGB(0, 220, 100) or Color3.fromRGB(255, 60, 60)
        floatStroke.Color               = active and Color3.fromRGB(0, 220, 100) or Color3.fromRGB(50, 50, 50)
        if floatPulseTween then floatPulseTween:Cancel(); floatPulseTween = nil end
        floatStroke.Transparency = 0
        if active then
            floatPulseTween = TweenService:Create(
                floatStroke,
                TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
                { Transparency = 0.55, Thickness = 3 }
            )
            floatPulseTween:Play()
        else
            floatStroke.Thickness = 2
        end
    end
    SetFloatStatus(false)

    local floatDragging, floatDragStart, floatStartPos, floatMoved = false, nil, nil, false

    floatLogo.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            floatDragging  = true
            floatMoved     = false
            floatDragStart = input.Position
            floatStartPos  = floatLogo.Position
        end
    end)

    floatLogo.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            floatDragging = false
            if not floatMoved then
                frame.Visible = not frame.Visible
            end
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if floatDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - floatDragStart
            if math.abs(delta.X) > 3 or math.abs(delta.Y) > 3 then floatMoved = true end
            floatLogo.Position = UDim2.new(
                floatStartPos.X.Scale, floatStartPos.X.Offset + delta.X,
                floatStartPos.Y.Scale, floatStartPos.Y.Offset + delta.Y
            )
        end
    end)

    closeBtn.MouseButton1Click:Connect(function()
        TweenService:Create(frame, TweenInfo.new(0.15), { Size = UDim2.new(0,300,0,0), BackgroundTransparency=1 }):Play()
        task.wait(0.2); gui:Destroy()
    end)

    local function HoverTween(btn, hoverColor, baseColor)
        btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.1), { BackgroundColor3 = hoverColor }):Play() end)
        btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.1), { BackgroundColor3 = baseColor  }):Play() end)
    end
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

    -- ============================================================
    --  SCROLLABLE CONTENT AREA (webhook inputs + toggle)
    -- ============================================================
    local BOTTOM_BLOCK_H = 108 -- tinggi area tombol aksi di bawah (fixed, di luar scroll)
    local SCROLL_Y        = 64

    local content = Instance.new("ScrollingFrame")
    content.Name                   = "Content"
    content.Position               = UDim2.new(0, 0, 0, SCROLL_Y)
    content.Size                   = UDim2.new(1, 0, 0, FRAME_H - SCROLL_Y - BOTTOM_BLOCK_H)
    content.BackgroundTransparency = 1
    content.BorderSizePixel        = 0
    content.ScrollBarThickness     = 3
    content.ScrollBarImageColor3   = Color3.fromRGB(80, 80, 80)
    content.CanvasSize             = UDim2.new(0, 0, 0, 0)
    content.Parent                 = frame

    local listLayout = Instance.new("UIListLayout")
    listLayout.FillDirection = Enum.FillDirection.Vertical
    listLayout.SortOrder     = Enum.SortOrder.LayoutOrder
    listLayout.Padding       = UDim.new(0, 4)
    listLayout.Parent        = content

    -- "AutomaticCanvasSize" gak semua executor/game client dukung, jadi canvas size
    -- dihitung MANUAL tiap kali AbsoluteContentSize berubah -- kompatibel di executor manapun.
    local function UpdateCanvasSize()
        content.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
    end
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvasSize)

    local listPad = Instance.new("UIPadding")
    listPad.PaddingLeft   = UDim.new(0, 12)
    listPad.PaddingRight  = UDim.new(0, 12)
    listPad.PaddingTop    = UDim.new(0, 4)
    listPad.PaddingBottom = UDim.new(0, 6)
    listPad.Parent        = content

    local function MakeLabel(text)
        local lbl = Instance.new("TextLabel")
        lbl.Text = text; lbl.Size = UDim2.new(1, 0, 0, 14)
        lbl.BackgroundTransparency = 1; lbl.TextColor3 = Color3.fromRGB(130,130,130)
        lbl.Font = Enum.Font.Gotham; lbl.TextSize = 10; lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = content
        return lbl
    end

    local function MakeInput(placeholder)
        local box = Instance.new("TextBox")
        box.PlaceholderText = placeholder; box.Size = UDim2.new(1, 0, 0, 28)
        box.BackgroundColor3 = Color3.fromRGB(35,35,35); box.TextColor3 = Color3.fromRGB(220,220,220)
        box.PlaceholderColor3 = Color3.fromRGB(100,100,100); box.Font = Enum.Font.Gotham; box.TextSize = 10
        box.ClearTextOnFocus = false; box.BorderSizePixel = 0; box.Text = ""
        box.TextXAlignment = Enum.TextXAlignment.Left; box.ClipsDescendants = true; box.Parent = content
        Instance.new("UICorner", box).CornerRadius = UDim.new(0,6)
        local pad = Instance.new("UIPadding", box); pad.PaddingLeft = UDim.new(0,8); pad.PaddingRight = UDim.new(0,8)
        return box
    end

    -- Toggle row: label kiri + switch kanan dalam satu baris ringkas.
    local function MakeToggleRow(labelText, defaultOn, onChange)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 22)
        row.BackgroundTransparency = 1
        row.Parent = content

        local lbl = Instance.new("TextLabel")
        lbl.Text = labelText; lbl.Size = UDim2.new(1, -44, 1, 0)
        lbl.BackgroundTransparency = 1; lbl.TextColor3 = Color3.fromRGB(130,130,130)
        lbl.Font = Enum.Font.Gotham; lbl.TextSize = 10; lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = row

        local bg = Instance.new("Frame")
        bg.Size = UDim2.new(0,36,0,18); bg.Position = UDim2.new(1,-36,0.5,-9)
        bg.BackgroundColor3 = Color3.fromRGB(60,60,60); bg.BorderSizePixel = 0; bg.Parent = row
        Instance.new("UICorner", bg).CornerRadius = UDim.new(1,0)

        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0,14,0,14); knob.Position = UDim2.new(0,2,0.5,-7)
        knob.BackgroundColor3 = Color3.fromRGB(200,200,200); knob.BorderSizePixel = 0; knob.Parent = bg
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

        local hitbox = Instance.new("TextButton")
        hitbox.Size = UDim2.new(0,36,0,18); hitbox.Position = UDim2.new(1,-36,0.5,-9)
        hitbox.BackgroundTransparency = 1; hitbox.Text = ""; hitbox.BorderSizePixel = 0; hitbox.Parent = row

        local state = false
        local function setState(enabled)
            state = enabled
            TweenService:Create(knob, TweenInfo.new(0.15), {
                Position         = enabled and UDim2.new(0,20,0.5,-7) or UDim2.new(0,2,0.5,-7),
                BackgroundColor3 = enabled and Color3.fromRGB(0,220,100) or Color3.fromRGB(200,200,200),
            }):Play()
            TweenService:Create(bg, TweenInfo.new(0.15), {
                BackgroundColor3 = enabled and Color3.fromRGB(0,100,50) or Color3.fromRGB(60,60,60),
            }):Play()
            lbl.TextColor3 = enabled and Color3.fromRGB(0,220,100) or Color3.fromRGB(130,130,130)
            if onChange then onChange(enabled) end
        end

        hitbox.MouseButton1Click:Connect(function() setState(not state) end)
        setState(defaultOn)

        return { setState = setState, getState = function() return state end, hitbox = hitbox }
    end

    MakeLabel("👋 Webhook Join / Leave")
    local inputJoin  = MakeInput("Paste webhook join/leave...")
    MakeLabel("🐋 Webhook Secret Fish")
    local inputFish  = MakeInput("Paste webhook secret fish...")
    MakeLabel("📊 Webhook Stats (fallback Check Player)")
    local inputStats = MakeInput("Paste webhook stats...")
    MakeLabel("🎯 Webhook Event Hunt (Role Nelayan)")
    local inputEvent = MakeInput("Kosong = pakai webhook join/leave...")
    MakeLabel("🧬 Webhook Mutasi List")
    local inputMutasi = MakeInput("Kosong = pakai webhook secret fish...")
    MakeLabel(EMOJI_CHECK .. " Webhook Check Player")
    local inputCheckplayer = MakeInput("Kosong = pakai webhook stats...")
    MakeLabel("⚖️ Webhook Galatama")
    local inputGalatama = MakeInput("Kosong = pakai webhook secret fish...")

    local saveEnabled = false
    local saveToggle = MakeToggleRow("💾 Simpan Config", false, function(enabled)
        saveEnabled = enabled
    end)

    -- Toggle ON/OFF khusus buat notifikasi Event Hunt (treasure/thunderzilla/crystal).
    -- Gak ngaruh ke fitur lain, bisa diubah kapan aja termasuk pas monitoring udah aktif.
    local eventToggle = MakeToggleRow("🔔 Notif Event Hunt", true, function(enabled)
        EVENT_NOTIF_ENABLED = enabled
    end)

    if savedConfig then
        if savedConfig.webhook_join        and savedConfig.webhook_join        ~= "" then inputJoin.Text        = savedConfig.webhook_join        end
        if savedConfig.webhook_fish        and savedConfig.webhook_fish        ~= "" then inputFish.Text        = savedConfig.webhook_fish        end
        if savedConfig.webhook_stats       and savedConfig.webhook_stats       ~= "" then inputStats.Text       = savedConfig.webhook_stats       end
        if savedConfig.webhook_event       and savedConfig.webhook_event       ~= "" then inputEvent.Text       = savedConfig.webhook_event       end
        if savedConfig.webhook_mutasi      and savedConfig.webhook_mutasi      ~= "" then inputMutasi.Text      = savedConfig.webhook_mutasi      end
        if savedConfig.webhook_checkplayer and savedConfig.webhook_checkplayer ~= "" then inputCheckplayer.Text = savedConfig.webhook_checkplayer end
        if savedConfig.webhook_galatama    and savedConfig.webhook_galatama    ~= "" then inputGalatama.Text    = savedConfig.webhook_galatama    end
        saveToggle.setState(true)
    end

    -- ============================================================
    --  TOMBOL AKSI (fixed di bawah, di luar scroll area)
    -- ============================================================
    local BTN_Y1 = FRAME_H - BOTTOM_BLOCK_H          -- CHECK PLAYER
    local BTN_Y2 = BTN_Y1 + 26 + 6                    -- GALATAMA LB
    local BTN_Y3 = BTN_Y2 + 26 + 6                    -- START MONITORING

    local checkBtn = Instance.new("TextButton")
    checkBtn.Text = EMOJI_CHECK .. " CHECK PLAYER"; checkBtn.Size = UDim2.new(1,-24,0,26); checkBtn.Position = UDim2.new(0,12,0,BTN_Y1)
    checkBtn.BackgroundColor3 = Color3.fromRGB(45,45,45); checkBtn.TextColor3 = Color3.fromRGB(220,220,220)
    checkBtn.Font = Enum.Font.GothamBold; checkBtn.TextSize = 11; checkBtn.BorderSizePixel = 0; checkBtn.Parent = frame
    Instance.new("UICorner", checkBtn).CornerRadius = UDim.new(0,6)
    HoverTween(checkBtn, Color3.fromRGB(65,65,65), Color3.fromRGB(45,45,45))

    checkBtn.MouseButton1Click:Connect(function()
        if not SCRIPT_ACTIVE then
            checkBtn.Text = "⚠️ Start monitoring dulu"
            task.wait(1.5)
            checkBtn.Text = EMOJI_CHECK .. " CHECK PLAYER"
            return
        end
        SendPlayerCheckWebhook()
        checkBtn.Text = "✅ Terkirim!"
        task.wait(1.2)
        checkBtn.Text = EMOJI_CHECK .. " CHECK PLAYER"
    end)

    local galatamaBtn = Instance.new("TextButton")
    galatamaBtn.Text = "⚖️ GALATAMA LB"; galatamaBtn.Size = UDim2.new(1,-24,0,26); galatamaBtn.Position = UDim2.new(0,12,0,BTN_Y2)
    galatamaBtn.BackgroundColor3 = Color3.fromRGB(45,45,45); galatamaBtn.TextColor3 = Color3.fromRGB(220,220,220)
    galatamaBtn.Font = Enum.Font.GothamBold; galatamaBtn.TextSize = 11; galatamaBtn.BorderSizePixel = 0; galatamaBtn.Parent = frame
    Instance.new("UICorner", galatamaBtn).CornerRadius = UDim.new(0,6)
    HoverTween(galatamaBtn, Color3.fromRGB(65,65,65), Color3.fromRGB(45,45,45))

    galatamaBtn.MouseButton1Click:Connect(function()
        if not SCRIPT_ACTIVE then
            galatamaBtn.Text = "⚠️ Start monitoring dulu"
            task.wait(1.5)
            galatamaBtn.Text = "⚖️ GALATAMA LB"
            return
        end
        SendGalatamaLeaderboard()
        galatamaBtn.Text = "✅ Terkirim!"
        task.wait(1.2)
        galatamaBtn.Text = "⚖️ GALATAMA LB"
    end)

    local startBtn = Instance.new("TextButton")
    startBtn.Text = "START MONITORING"; startBtn.Size = UDim2.new(1,-24,0,34); startBtn.Position = UDim2.new(0,12,0,BTN_Y3)
    startBtn.BackgroundColor3 = Color3.fromRGB(0,180,100); startBtn.TextColor3 = Color3.fromRGB(255,255,255)
    startBtn.Font = Enum.Font.GothamBold; startBtn.TextSize = 12; startBtn.BorderSizePixel = 0; startBtn.Parent = frame
    startBtn.TextScaled  = true
    startBtn.TextWrapped = false
    local startBtnSizeConstraint = Instance.new("UITextSizeConstraint")
    startBtnSizeConstraint.MaxTextSize = 12
    startBtnSizeConstraint.Parent      = startBtn
    local startBtnPad = Instance.new("UIPadding", startBtn)
    startBtnPad.PaddingLeft  = UDim.new(0,6)
    startBtnPad.PaddingRight = UDim.new(0,6)
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
        if inputFish.Text:find("discord.com/api/webhooks")        then WEBHOOK_FISH        = inputFish.Text        end
        if inputStats.Text:find("discord.com/api/webhooks")       then WEBHOOK_STATS       = inputStats.Text       end
        if inputEvent.Text:find("discord.com/api/webhooks")       then WEBHOOK_EVENT       = inputEvent.Text       end
        if inputMutasi.Text:find("discord.com/api/webhooks")      then WEBHOOK_MUTASI      = inputMutasi.Text      end
        if inputCheckplayer.Text:find("discord.com/api/webhooks") then WEBHOOK_CHECKPLAYER = inputCheckplayer.Text end
        if inputGalatama.Text:find("discord.com/api/webhooks")    then WEBHOOK_GALATAMA    = inputGalatama.Text    end

        if saveEnabled then SaveConfig(WEBHOOK_URL, WEBHOOK_FISH, WEBHOOK_STATS, WEBHOOK_EVENT, WEBHOOK_MUTASI, WEBHOOK_CHECKPLAYER, WEBHOOK_GALATAMA) end

        SCRIPT_ACTIVE = true
        statusDot.BackgroundColor3 = Color3.fromRGB(0,220,100)
        statusLabel.Text           = "Aktif — Monitoring..."
        statusLabel.TextColor3     = Color3.fromRGB(0,220,100)
        startBtn.Text              = "✅ MONITORING AKTIF"
        startBtn.BackgroundColor3  = Color3.fromRGB(30,30,30)

        SetFloatStatus(true)

        for _, box in ipairs({ inputJoin, inputFish, inputStats, inputEvent, inputMutasi, inputCheckplayer, inputGalatama }) do
            box.TextEditable = false
        end
        saveToggle.hitbox.Active = false
        -- NOTE: eventToggle SENGAJA tetap aktif setelah monitoring jalan,
        -- biar notif Event Hunt bisa di-ON/OFF kapan aja tanpa stop monitoring.

        StartMonitoring()
    end)
end

-- ============================================================
--  INIT
-- ============================================================

local uiOk, uiErr = pcall(CreateUI)
if not uiOk then
    warn("[BLOX Gank] Gagal bikin UI: " .. tostring(uiErr))
end
