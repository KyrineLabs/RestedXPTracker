local addonName          = ...
local LDB                = LibStub:GetLibrary("LibDataBroker-1.1")
local LDBIcon            = LibStub("LibDBIcon-1.0")

RestedTrackerDB          = RestedTrackerDB or {}
RestedTrackerSettings    = RestedTrackerSettings or { showAllRealms = false }

local wasResting         = false
local CLASS_ICON_TCOORDS = CLASS_ICON_TCOORDS

local function GetRealm()
    local realm = GetRealmName()
    return realm and realm:gsub("%s+", "") or "UnknownRealm"
end -- GetRealm

local function GetUserInfo()
    local name, realm = UnitName("player"), GetRealm()
    if not name or not realm then
        return nil, nil
    end
    return name, realm:gsub("%s+", "")
end -- GetUserInfo

local function SaveRestedXP()
    local name, realm = GetUserInfo()
    local xp, maxXP = UnitXP("player"), UnitXPMax("player")
    local restedXP = GetXPExhaustion() or 0
    local restedPercent = (restedXP / maxXP) * 100

    RestedTrackerDB[realm][name] = {
        class = select(2, UnitClass("player")),
        level = UnitLevel("player"),
        xp = xp,
        maxXP = maxXP,
        restedXP = restedXP,
        restedXPPercent = restedPercent,
        wasResting = wasResting,
        lastUpdate = date("%Y-%m-%d %H:%M:%S")
    }
end -- SaveRestedXP

local function UpdateOfflineRestedXP()
    for realm, chars in pairs(RestedTrackerDB) do
        for name, data in pairs(chars) do
            if data.lastLogout and data.restedXPPercent then
                local now = time()
                local elapsed = now - data.lastLogout
                local hours = elapsed / 3600
                local gainRate = data.wasResting and 0.625 or 0.15625
                local gain = hours * gainRate
                data.restedXPPercent = math.min((data.restedXPPercent or 0) + gain, 150)
            end
        end
    end
end

local function UpdateRestingStatus()
    wasResting = IsResting()
    local name, realm = GetUserInfo()
    RestedTrackerDB[realm][name].wasResting = wasResting
end -- UpdateRestingStatus

local function GetClassIconTextureCoords(class)
    return unpack(CLASS_ICON_TCOORDS[class] or {})
end

local function EnsureCharTable()
    local name, realm = GetUserInfo()
    RestedTrackerDB[realm] = RestedTrackerDB[realm] or {}
    RestedTrackerDB[realm][name] = RestedTrackerDB[realm][name] or {}
    return name, realm
end -- EnsureCharTable

local dataobj = LDB:NewDataObject("RestedTracker", {
    type = "data source",
    text = "Repos",
    icon = "Interface\\AddOns\\RestedTracker\\icon.tga",
    OnTooltipShow = function(tooltip)
        tooltip:AddLine("Rested XP Tracker")
        tooltip:AddLine("Affichage : " .. (RestedTrackerSettings.showAllRealms and "Tous les royaumes" or "Royaume actuel"))
        tooltip:AddLine(" ")

        -- get Realm
        local currentRealm = GetRealm()

        -- for each character in all realm
        for realm, chars in pairs(RestedTrackerDB) do
            if RestedTrackerSettings.showAllRealms or realm == currentRealm then
                -- 1. Récupérer les persos dans une table temporaire
                local charList = {}
                for name, data in pairs(chars) do
                    if (data.level or 0) > 2 and (data.level or 0) < 60 then -- Filtre les persos de niveau > 2
                        table.insert(charList, { name = name, data = data })
                    end
                end
                -- 2. Trier par restedXPPercent décroissant
                table.sort(charList, function(a, b)
                    return (tonumber(a.data.restedXPPercent) or 0) > (tonumber(b.data.restedXPPercent) or 0)
                end)
                -- 3. Afficher la liste triée
                for _, entry in ipairs(charList) do
                    local name, data = entry.name, entry.data
                    local class = data.class or "UNKNOWN"
                    local texCoords = { GetClassIconTextureCoords(class) }
                    local icon = "|TInterface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES:16:16:0:0:256:256:" ..
                        math.floor(texCoords[1]*256) .. ":" .. math.floor(texCoords[2]*256) .. ":" ..
                        math.floor(texCoords[3]*256) .. ":" .. math.floor(texCoords[4]*256) .. "|t "
                    local color = "|cffffff00"
                    local percent = tonumber(data.restedXPPercent) or 0

                    if percent >= 150 then
                        color = "|cff00ff00" -- vert foncé
                    elseif percent >= 125 then
                        color = "|cff80ff00" -- vert clair
                    elseif percent >= 75 then
                        color = "|cffffff00" -- jaune
                    elseif percent >= 25 then
                        color = "|cffff8000" -- orange
                    else
                        color = "|cffff0000" -- rouge
                    end

                    tooltip:AddDoubleLine(
                        icon .. name .. (RestedTrackerSettings.showAllRealms and " - " .. realm or "") .. " (Lvl " .. (data.level or "?") .. ")",
                        color .. string.format("%.1f%%", percent) .. "|r"
                    )
                end
            end
        end

        tooltip:AddLine(" ")
        tooltip:AddLine("|cffaaaaaaClic droit : basculer affichage royaume|r")
    end,
    OnClick = function(_, button)
        if button == "RightButton" then
            RestedTrackerSettings.showAllRealms = not RestedTrackerSettings.showAllRealms
            print("RestedTracker: Affichage " .. (RestedTrackerSettings.showAllRealms and "tous les royaumes" or "royaume actuel uniquement"))
        end
    end
}) -- dataobj

-- <<< MAIN ADDON CODE >>>
local f                  = CreateFrame("Frame")

f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("PLAYER_XP_UPDATE")
f:RegisterEvent("UPDATE_EXHAUSTION")
f:RegisterEvent("PLAYER_UPDATE_RESTING")
f:RegisterEvent("PLAYER_LOGOUT")

f:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_ENTERING_WORLD" then
        -- Ensure the character table exists before saving rested XP
        local name, realm = EnsureCharTable()
        -- set new values in DB
        SaveRestedXP()
        -- Update the restedXP status
        UpdateRestingStatus()
        -- Update offline rested XP for all characters
        UpdateOfflineRestedXP()
        -- Register the data object with LDBIcon if not already registered
        if not LDBIcon:IsRegistered("RestedTracker") then
            LDBIcon:Register("RestedTracker", dataobj, { hide = false, minimapPos = 200 })
        end
    elseif event == "PLAYER_XP_UPDATE" or event == "UPDATE_EXHAUSTION" then
        SaveRestedXP()
    elseif event == "PLAYER_UPDATE_RESTING" then
        UpdateRestingStatus()
    elseif event == "PLAYER_LOGOUT" then
        -- Ensure the character table exists before saving logout time
        local name, realm = EnsureCharTable()
        -- Save the last logout time for the current player
        RestedTrackerDB[realm][name].lastLogout = time()
     end
end
)
