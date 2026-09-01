-- UpgradeLevel.lua
-- Adds upgrade level information to armor and weapon tooltips

local addonName, ns = ...

-- Create AceAddon
local UpgradeLevel = LibStub("AceAddon-3.0"):NewAddon("UpgradeLevel", "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0")

-- Default database values
local defaults = {
    profile = {
        showMaxLevel = true,
        colorCode = "00ff00", -- Green color for max level text
        troubleMode = false,
        showUpgradeText = true,
        showUpgradeLevel = true,
    },
    global = {
        items = {},
        linktoitem = {},
        gameBranch = 0,
        gameVersion = 0,
        seasonID = 0,
        validSeason = false
    },
}

UpgradeLevel.vars = {
    -- gameBranch = 0,
    -- gameVersion = 0,
    -- seasonID = 0,
    validSeason = false,
    isDevMode = true,
    upgrades = {
        [970] = {
            rank = 6,
            id = "explorer",
            name = ns.L["Explorer"]
        },
        [971] = {
            rank = 5,
            id = "adventurer",
            name = ns.L["Adventurer"],
        },
        [972] = {
            rank = 4,
            id = "veteran",
            name = ns.L["Veteran"],
        },
        [973] = {
            rank = 3,
            id = "champion",
            name = ns.L["Champion"],
        },
        [974] = {
            rank = 2,
            id = "hero",
            name = ns.L["Hero"],
        },
        [975] = {
            rank = 1,
            id = "myth",
            name = ns.L["Myth"],
        },
    },
}

-- Expansion Level Details
UpgradeLevel.vars.expData = {
    -- Constant WOW_PROJECT_ID; used to fetch the expansion data which translates to WOW_PROJECT_* constants setup by Blizzard
    -- Only Retail Supported for Now
    [WOW_PROJECT_MAINLINE] = {
        -- Constant LE_EXPANSION_LEVEL_CURRENT; used to fetch the current expansion data which translates to LE_EXPANSION_LEVEL_* constants setup by Blizzard
        -- Only Midnight Supported for Now
        [LE_EXPANSION_MIDNIGHT] = {
            -- Season
            -- 18 is Midnight Season 2
            [18] = {
                maxUpgradeLevel = 975,
                maxUpgradeRank = 1,
                ranks = {
                    -- adventurer
                    [971] = {
                        levels = {
                            min = 266,
                            max = 282,
                        },
                    },
                    -- veteran
                    [972] = {
                        levels = {
                            min = 279,
                            max = 295,
                        },
                    },
                    -- champion
                    [973] = {
                        levels = {
                            min = 292,
                            max = 308,
                        },
                    },
                    -- hero
                    [974] = {
                        levels = {
                            min = 305,
                            max = 321,
                        },
                    },
                    -- myth
                    [975] = {
                        levels = {
                            min = 318,
                            max = 344,
                        },
                    },}
            },
            -- 17 is Midnight Season 1, therefore, 18 would be Midnight Season 2, and so on. Doesn't seem Blizzard has constants for these, so using raw numbers for now.
            [17] = {
                maxUpgradeLevel = 975,
                maxUpgradeRank = 1,
                ranks = {
                    [970] = {
                        -- no explorer gear; only included 970 for testing
                        levels = {
                            min = 1,
                            max = 1,
                        },
                    },
                    [971] = {
                        levels = {
                            min = 220,
                            max = 237,
                        },
                    },
                    [972] = {
                        levels = {
                            min = 233,
                            max = 250,
                        },
                    },
                    [973] = {
                        levels = {
                            min = 246,
                            max = 263,
                        },
                    },
                    [974] = {
                        levels = {
                            min = 259,
                            max = 276,
                        },
                    },
                    [975] = {
                        levels = {
                            min = 272,
                            max = 289,
                        },
                    },
                },
            },
        },
    },
}

-- Addon Initialization
function UpgradeLevel:OnInitialize()
    -- Initialize AceDB with defaults
    self.db = LibStub("AceDB-3.0"):New("UpgradeLevelDB", defaults, true)

    -- Register the event, then request the data
    self:RegisterEvent("CHALLENGE_MODE_MAPS_UPDATE", "OnMapInfoReceived")
    C_MythicPlus.RequestMapInfo()

    -- AceConfig options table
    local options = {
        name = "Upgrade Level",
        handler = UpgradeLevel,
        type = "group",
        args = {
            about = {
                name = ns.L["About"],
                type = "group",
                order = 10,
                args = {
                    description = {
                        type = "description",
                        name = ns.L["Upgrade Level adds item level information to armor and weapon tooltips."],
                        order = 1,
                    },
                    support = {
                        type = "description",
                        name = "\n" .. ns.L["To support this addon, please use on of the following methods:"],
                        order = 2,
                    },
                    patreon = {
                        type = "input",
                        get = function() return "https://www.patreon.com/Bryo" end,
                        set = function() end,
                        name = ns.L["Patreon: "],
                        width = "full",
                        order = 3,
                    },
                    buymeacoffee = {
                        type = "input",
                        get = function() return "https://www.buymeacoffee.com/mrbryo" end,
                        set = function() end,
                        name = ns.L["Buy me a Coffee: "],
                        width = "full",
                        order = 4,
                    },
                    github = {
                        type = "input",
                        get = function() return "https://github.com/mrbryo/UpgradeLevel/issues" end,
                        set = function() end,
                        name = ns.L["To report issues or request features, please visit the GitHub repository:"],
                        width = "full",
                        order = 5,
                    },
                    locale = {
                        type = "input",
                        get = function() return "https://legacy.curseforge.com/wow/addons/upgradelevel/localization" end,
                        set = function() end,
                        name = ns.L["Assist with translations or add a new language:"],
                        width = "full",
                        order = 6,
                    },
                },
            },
            general = {
                name = ns.L["General Settings"],
                type = "group",
                order = 20,
                args = {
                    showMaxLevel = {
                        type = "toggle",
                        name = ns.L["Show Max Level"],
                        desc = ns.L["Show maximum item level information in tooltips."],
                        get = function(info)
                            return UpgradeLevel.db.profile.showMaxLevel or false
                        end,
                        set = function(info, val) UpgradeLevel.db.profile.showMaxLevel = val end,
                        order = 2,
                    },
                    -- don't like how this looks in the tool tip, commenting out for now
                    -- showUpgradeLevel = {
                    --     type = "toggle",
                    --     name = "Show Upgrade Level",
                    --     desc = "Show upgrade level as a number in tooltips.",
                    --     get = function(info) return UpgradeLevel.db.profile.showUpgradeLevel or false end,
                    --     set = function(info, val) UpgradeLevel.db.profile.showUpgradeLevel = val end,
                    --     order = 3,
                    -- },
                    showUpgradeText = {
                        type = "toggle",
                        name = ns.L["Show Upgrade Text"],
                        desc = ns.L["Show upgrade level as descriptive text in tooltips."],
                        get = function(info) return UpgradeLevel.db.profile.showUpgradeText or false end,
                        set = function(info, val) UpgradeLevel.db.profile.showUpgradeText = val end,
                        order = 3,
                    },
                    colorCode = {
                        type = "color",
                        name = ns.L["Color"],
                        desc = ns.L["Color for max level and upgrade text"],
                        get = function(info) 
                            local hex = UpgradeLevel.db.profile.colorCode or "00ff00"
                            -- Convert hex to RGB values (0-1 range)
                            local r = tonumber(hex:sub(1,2), 16) / 255
                            local g = tonumber(hex:sub(3,4), 16) / 255  
                            local b = tonumber(hex:sub(5,6), 16) / 255
                            return r, g, b, 1
                        end,
                        set = function(info, r, g, b, a)
                            -- Convert RGB values (0-1 range) back to hex
                            local hex = string.format("%02x%02x%02x", 
                                math.floor(r * 255 + 0.5), 
                                math.floor(g * 255 + 0.5), 
                                math.floor(b * 255 + 0.5))
                            UpgradeLevel.db.profile.colorCode = hex
                        end,
                        order = 4,
                    },
                    troubleMode = {
                        type = "toggle",
                        name = ns.L["Trouble Shooting Mode"],
                        desc = ns.L["Enable debug/trouble mode for additional logging to the saved variables file for issue submission."],
                        get = function(info) return UpgradeLevel.db.profile.troubleMode or false end,
                        set = function(info, val) 
                            UpgradeLevel.db.profile.troubleMode = val
                            -- clear out item tables if trouble mode is off
                            if UpgradeLevel.db.profile.troubleMode == false then
                                UpgradeLevel.db.global.items = {}
                                UpgradeLevel.db.global.linktoitem = {}
                            end
                        end,
                        order = 5,
                    },
                    image = {
                        type = "description",
                        name = "|TInterface\\AddOns\\UpgradeLevel\\upgradeLevel-updated.png:238:520|t",
                        width = "full",
                        order = 6,
                    },
                },
            },
            thankyou = {
                name = ns.L["Thank You!"],
                type = "group",
                order = 30,
                args = {
                    thanks1 = {
                        type = "description",
                        name = ns.L["On Wowhead, iMX3 is the author of an article which has lots of gear information on it. With out it I'm not sure where I would find the details I need for the addon with out having to write a bunch of additional code to extrapolate over time the min and max values for gear."],
                        order = 10
                    },
                    thanks1Link = {
                        type = "input",
                        get = function() return "https://www.wowhead.com/guide/midnight/item-level-gear-upgrades-dawncrests" end,
                        set = function () end,
                        name = ns.L["Midnight Guide for Item Levels"],
                        width = "full",
                        order = 11
                    },
                    thanks1AuthorLink = {
                        type = "input",
                        get = function() return "https://www.wowhead.com/author/iMX3" end,
                        set = function() end,
                        name = ns.L["iMX3 Author Link on Wowhead"],
                        width = "full",
                        order = 12
                    }
                }
            },
            --@debug@
            troubleshoot = {
                name = ns.L["Troubleshoot"],
                type = "group",
                order = 100,
                args = {
                    disclaimer = {
                        type = "description",
                        name = "Note: English only on this tab. If any other developers join which speak/read something other than English then happy to add translation functionality.\n\nvar = value read from addon variablen\nglobal = value read from WoW global variable because addon variable was nil\nfunc = value used from a WoW function call because addon variable was nil",
                        order = 0,
                    },
                    wowProjectId = {
                        type = "input",
                        get = function()
                            local outstr = "%s (%s)"
                            if self.db.global.gameBranch == nil then
                                return (outstr):format(WOW_PROJECT_ID, "global")
                            else
                                return (outstr):format(self.db.global.gameBranch, "var")
                            end
                        end,
                        set = function() end,
                        name = ns.L["Game Branch (Project)"],
                        width = "full",
                        order = 10
                    },
                    infoWowProjectId = {
                        type = "description",
                        name = ("Game Version ID's; Retain/Mainline: %d; Classic: %d"):format(WOW_PROJECT_MAINLINE, WOW_PROJECT_CLASSIC),
                        order = 11
                    },
                    expansionId = {
                        type = "input",
                        get = function()
                            local outstr = "%s (%s)"
                            if self.db.global.gameVersion == nil then
                                return (outstr):format(LE_EXPANSION_LEVEL_CURRENT, "global")
                            else
                                return (outstr):format(self.db.global.gameVersion, "var")
                            end
                        end,
                        set = function() end,
                        name = ns.L["Expansion ID"],
                        width = "full",
                        order = 20
                    },
                    infoExpansionId = {
                        type = "description",
                        name = ("Expansion ID's; Midnight: %d; War Within: %d"):format(LE_EXPANSION_MIDNIGHT, LE_EXPANSION_WAR_WITHIN),
                        order = 21
                    },
                    curSeasonId = {
                        type = "input",
                        get = function()
                            local outstr = "%s (%s)"
                            if self.db.global.seasonID == nil then
                                return (outstr):format(C_MythicPlus.GetCurrentSeason(), "func")
                            else
                                return (outstr):format(self.db.global.seasonID, "var")
                            end
                        end,
                        set = function() end,
                        name = ns.L["Current Season ID"],
                        width = "full",
                        order = 30
                    },
                    infoCurSeasonId = {
                        type = "description",
                        name = "Midnight; S1: 17, S2: 18",
                        order = 31
                    }
                }
            }
            --@end-debug@
        },
    }

    -- Add profiles to options table now that db exists
    options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)

    -- Setup AceConfig
    LibStub("AceConfig-3.0"):RegisterOptionsTable("UpgradeLevel", options)
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("UpgradeLevel", "Upgrade Level")

    -- Register slash commands using AceConsole
    self:RegisterChatCommand("upgradelevel", "ChatCommand")
    self:RegisterChatCommand("ul", "ChatCommand")
end

-- Waiting for Map Info Update to get Game Info
function UpgradeLevel:OnMapInfoReceived()
    --@debug@
    -- for debugging
    -- self:Print("Map Info Received - Begins...")
    --@end-debug@

    -- Unregister the event since we only need to do this once on initialization; also ensures we have the necessary game info to proceed with addon setup.
    self:UnregisterEvent("CHALLENGE_MODE_MAPS_UPDATE")

    -- Get Game Branch
    self.db.global.gameBranch = WOW_PROJECT_ID

    -- Get Expansion Level
    self.db.global.gameVersion = LE_EXPANSION_LEVEL_CURRENT

    -- Get Season ID
    self.db.global.seasonID = C_MythicPlus.GetCurrentSeason()

    -- Verify Season Exists in our Data
    -- First check the game version exists...this is detecting if running retail or not.
    if self.vars.expData[self.db.global.gameBranch] then
        -- Next check if the expansion level exists...this is the actual expansion like Midnight.
        if self.vars.expData[self.db.global.gameBranch][self.db.global.gameVersion] then
            -- Finally check if the season exists for the expansion.
            if self.vars.expData[self.db.global.gameBranch][self.db.global.gameVersion][self.db.global.seasonID] then
                -- season found so set status variable to true
                self.db.global.validSeason = true
                -- no message to user since success!
            else
                self:Print(ns.L["No Data found for Season: "] .. tostring(self.db.global.seasonID) .. ns.L[" for Expansion: "] .. tostring(self.db.global.gameBranch) .. ns.L[" at Game Version: "] .. tostring(self.db.global.gameVersion))
                self.db.global.validSeason = false
            end
        else
            self:Print(ns.L["No Data found for Expansion Level: "] .. tostring(self.db.global.gameVersion) .. ns.L[" for Expansion: "] .. tostring(self.db.global.gameBranch))
        end

    else
        self:Print(ns.L["New Expansion Detected! Until updated, addon will have limited functionality."])
    end

    --@debug@
    -- for debugging
    -- self:Print("Map Info Received - Done")
    --@end-debug@
end

-- Addon Enabled Setup
function UpgradeLevel:OnEnable()
    -- Register events and set up hooks when addon is enabled
    self:SetupTooltipHooks()
    --@debug@
    -- self:Print("OnEnable Fired - SetupTooltipHooks triggered!")
    --@end-debug@
end

-- Addon Disabled Clean Up
function UpgradeLevel:OnDisable()
    -- Clean up hooks when addon is disabled
    self:UnhookAll()
    --@debug@
    -- self:Print("OnDisable Fired - UnhookAll triggered!")
    --@end-debug@
end

-- Setup Command Hooks for Tooltips to trigger AddUpgradeInfo
function UpgradeLevel:SetupTooltipHooks()
    -- Hook tooltip methods using the proper approach
    local function OnTooltipSetItem(tooltip)
        self:AddUpgradeInfo(tooltip)
    end

    -- Override the tooltip's methods
    self:SecureHook(GameTooltip, "SetBagItem", OnTooltipSetItem)
    self:SecureHook(GameTooltip, "SetInventoryItem", OnTooltipSetItem)
    self:SecureHook(GameTooltip, "SetHyperlink", OnTooltipSetItem)
    self:SecureHook(ItemRefTooltip, "SetHyperlink", OnTooltipSetItem)
end

-- Slash command handlers
function UpgradeLevel:ChatCommand(input)
    if not input or input:trim() == "" then
        -- Open config panel - use AceConfigDialog method for compatibility
        LibStub("AceConfigDialog-3.0"):Open("UpgradeLevel", "general")
    elseif input:lower() == "profile" then
        -- Open config panel - use AceConfigDialog method for compatibility
        LibStub("AceConfigDialog-3.0"):Open("UpgradeLevel", "profiles")
    elseif input:lower() == "about" then
        -- Open config panel - use AceConfigDialog method for compatibility
        LibStub("AceConfigDialog-3.0"):Open("UpgradeLevel", "about")
    elseif input:lower() == "status" then
        -- Show addon status
        self:Print(ns.L["Show Max Level: %s"]:format(UpgradeLevel.db.profile.showMaxLevel and ns.L["On"] or ns.L["Off"]))
        self:Print(ns.L["Show Upgrade Text: %s"]:format(UpgradeLevel.db.profile.showUpgradeText and ns.L["On"] or ns.L["Off"]))
        self:Print(ns.L["Color Code: %s"]:format(UpgradeLevel.db.profile.colorCode))
        self:Print(ns.L["Trouble Shooting Mode: %s"]:format(UpgradeLevel.db.profile.troubleMode and ns.L["On"] or ns.L["Off"]))
    else
        -- Show help
        self:Print(ns.L["Upgrade Level Commands:"])
        self:Print(ns.L["/ul or /upgradelevel - Open General Settings in Options"])
        self:Print(ns.L["/ul general - Open General Settings in Options"])
        self:Print(ns.L["/ul profiles - Open Profiles in Options"])
        self:Print(ns.L["/ul about - Open About in Options"])
        self:Print(ns.L["/ul status - Show current settings in main chat window."])
    end
end

-- Add Data to Tooltips
function UpgradeLevel:AddUpgradeInfo(tooltip)
    --@debug@
    -- self:Print("AddUpgradeInfo Triggered")
    --@end-debug@

    -- exist if season not found
    if not self.db.global.validSeason then
        return
    end

    -- get tooltips item link
    local _, itemLink = tooltip:GetItem()

    -- if itemLink not found, return to end function call
    if not itemLink then
        return
    end

    -- fetch the itemID from the itemLink
    local itemID = C_Item.GetItemIDForItemInfo(itemLink)

    -- fetch item info using C_Item.GetItemInfo, returned value 2 is also itemLink, no need to override what is fetched from tooltip
    local itemName, _, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, ItemTexture, sellPrice, classID, subclassID, bindType, expansionID, setID, isCraftingReagent = C_Item.GetItemInfo(itemLink)

    -- fetch item info from C_ItemUpgrade
    -- PickupItem(itemID)
    -- C_ItemUpgrade.SetItemUpgradeFromCursorItem()
    -- local itemInfo = C_ItemUpgrade.GetItemUpgradeItemInfo()
    -- ClearCursor()

    -- local itemHighWatermark = C_ItemUpgrade.GetHighWatermarkForItem(itemID)

    --@debug@
    --[[
        Nope this GetItemStats doesn't return anything I need...
    ]]
    -- get the item stats
    -- local statTbl = C_Item.GetItemStats(itemLink)
    -- if statTbl then
    --     for statID, value in pairs(statTbl) do
    --         -- print statID and value to saved variables for debugging
    --         self:Print("StatID: " .. tostring(statID) .. " Value: " .. tostring(value))
    --     end
    -- end
    --@end-debug@

    -- add to db if not already present
    if UpgradeLevel.db.profile.troubleMode == true then
        if itemID then
            -- main item table
            UpgradeLevel.db.global.items[itemID] = {
                ["C_Item-GetItemInfo"] = {
                    name = itemName,
                    quality = itemQuality,
                    level = itemLevel,
                    minLevel = itemMinLevel,
                    type = itemType,
                    subtype = itemSubType,
                    stackCount = itemStackCount,
                    equipLoc = itemEquipLoc,
                    texture = ItemTexture,
                    sellPrice = sellPrice,
                    classID = classID,
                    subclassID = subclassID,
                    bindType = bindType,
                    expansionID = expansionID,
                    setID = setID,
                    isCraftingReagent = isCraftingReagent,
                    link = itemLink,
                },
                -- ["C_ItemUpgrade-GetItemUpgradeItemInfo"] = {
                --     data = itemInfo,
                -- },
                -- ["C_ItemUpgrade-GetHighWatermarkForItem"] = {
                --     highWatermark = itemHighWatermark,
                -- }
            }
            -- for reverse lookup by itemLink to get itemID, then get the itemID from the items table
            UpgradeLevel.db.global.linktoitem[itemLink] = itemID
        end
    end

    -- if itemName not found, return to end function call
    if not itemName then
        --@debug@
        -- self:Print("Item Name Blank for item %s." .. tostring(itemID))
        --@end-debug@
        return
    end

    -- Only show for armor and weapons
    if (itemType == "Armor" or itemType == "Weapon") and (self.db.profile.showMaxLevel == true or self.db.profile.showUpgradeText == true or self.db.profile.showUpgradeLevel == true) then
        --[[ get the item upgrade information
            currentLevel: 1 to the item's maxLevel; example 1 to 8
            maxLevel: the maximum upgrade level for this item; example 8
            maxItemLevel: the maximum item level for this item at its max upgrade level; example 723
            trackString: the string identifier for the upgrade path; example Champion
            trackStringID: the numeric identifier for the upgrade path; example 973
        ]]
        local itemUpgradeInfo = C_Item.GetItemUpgradeInfo(itemLink)
        --@debug@
        -- self:Print(("Item Upgrade Info; Name: '%s'; Track String: '%s'"):format(itemName or "No Item Name", itemUpgradeInfo.trackString or "No Track String"))
        --@end-debug@

        -- add details
        if self.db.profile.troubleMode == true then
            self.db.global.items[itemID]["C_Item-GetItemUpgradeInfo"] = itemUpgradeInfo or {}
        end

        if itemUpgradeInfo ~= nil then
            -- check for nil or missing values in itemUpgradeInfo
            if not itemUpgradeInfo.currentLevel then
                itemUpgradeInfo.currentLevel = 0
            end
            if not itemUpgradeInfo.maxLevel then
                itemUpgradeInfo.maxLevel = 0
            end
            if not itemUpgradeInfo.maxItemLevel then
                itemUpgradeInfo.maxItemLevel = 0
            end
            if not itemUpgradeInfo.trackString then
                itemUpgradeInfo.trackString = "No Data"
            end
            if not itemUpgradeInfo.trackStringID then
                itemUpgradeInfo.trackStringID = 0
            end

            -- track additions
            local done = {
                itemLevel = false,
                upgradeLevel = false,
            }

            -- Find the item level line in the tooltip and modify it
            for i = 2, tooltip:NumLines() do
                -- create tmp variable to hold line
                local line = _G[tooltip:GetName() .. "TextLeft" .. i]

                -- get rank data from addon
                local ranksData = self.vars.expData[self.db.global.gameBranch][self.db.global.gameVersion][self.db.global.seasonID].ranks[itemUpgradeInfo.trackStringID]

                -- if the line is valid and has text, proceed
                if line and line:GetText() then
                    -- get the line text
                    local text = line:GetText()

                    -- get max item level from game, if 0 then get from addon data
                    local maxItemLevel = itemUpgradeInfo.maxItemLevel
                    if maxItemLevel == 0 then
                        if ranksData then
                            maxItemLevel = ranksData.levels.max or 0
                        end
                    end

                    -- get max level, not adjusting this since I'm using it to determine if I should show max level or not; assuming if zero I shouldn't, see item 264629 for example. It says its an Adventurer track but has no upgrade levels...
                    local maxLevel = itemUpgradeInfo.maxLevel

                    -- check for secret
                    --@debug@
                    -- self:Print(("Item '%s' - Show Upgrade Text: %s; Show Max Level: %s"):format(itemName, tostring(self.db.profile.showUpgradeText), tostring(self.db.profile.showUpgradeLevel)))
                    --@end-debug@
                    if not ns.WOWAPI.issecretvalue(text) then
                        -- look for "Item Level XXX" pattern
                        if text:match("Item Level %d+") and maxLevel > 0 and maxItemLevel > 0 and self.db.profile.showMaxLevel == true then
                            local colorCode = self.db.profile.colorCode or "00ff00"
                            local newText = text .. " |cff" .. colorCode .. "(" .. ns.L["Max"] .. ": " .. tostring(maxItemLevel) .. ")|r"
                            line:SetText(newText)
                            done.itemLevel = true

                        -- look for "Upgrade Level:" pattern
                        elseif text:match("Upgrade Level:") and (self.db.profile.showUpgradeText == true or self.db.profile.showUpgradeLevel == true) then
                            local colorCode = self.db.profile.colorCode or "00ff00"

                            -- build text
                            local referenceText = ""
                            local itemRankData = self.vars.upgrades[itemUpgradeInfo.trackStringID]
                            local itemRankLevels = self.vars.expData[self.db.global.gameBranch][self.db.global.gameVersion][self.db.global.seasonID][itemUpgradeInfo.trackStringID]
                            local loopCount = 0

                            -- append numeric level if enabled
                            -- if self.db.profile.showUpgradeLevel == true then
                            --     referenceText = ("(%d/%d) "):format(itemRankData.rank, self.vars.maxUpgradeRank)
                            -- end

                            if itemUpgradeInfo.trackStringID == 0 then
                                if self.db.profile.showUpgradeText == true then
                                    referenceText = itemUpgradeInfo.trackString
                                end
                            else
                                -- get max upgrade level
                                local maxUpgradeLevel = self.vars.expData[self.db.global.gameBranch][self.db.global.gameVersion][self.db.global.seasonID].maxUpgradeLevel

                                -- for debugging
                                -- self:Print("Item Upgrade Track String ID: " .. tostring(itemUpgradeInfo.trackStringID) .. "; Max Upgrade Level: " .. tostring(maxUpgradeLevel))

                                -- loop over the range from the track ID + 1 to the max upgrade level, and append the rank names to the reference text
                                for j = (itemUpgradeInfo.trackStringID + 1), maxUpgradeLevel do
                                    -- get the rank data
                                    local rankData = self.vars.upgrades[j]

                                    -- if not nil proceed
                                    if rankData ~= nil then
                                        -- append to reference text
                                        if self.db.profile.showUpgradeText == true then
                                            referenceText = ("%s > %s"):format(referenceText, rankData.name)
                                        end

                                        -- increment loop count
                                        loopCount = loopCount + 1

                                        -- Limit to next two ranks for brevity
                                        if loopCount > 2 then
                                            referenceText = referenceText .. " > ..."
                                            break
                                        end
                                    end
                                end
                            end

                            local newText = text .. " |cff" .. colorCode .. referenceText .. "|r"
                            --@debug@
                            -- self:Print(("Old Text: %s"):format(text))
                            -- self:Print(("New Text: %s"):format(newText))
                            --@end-debug@
                            line:SetText(newText)
                            done.upgradeLevel = true
                        end
                    end

                    -- If both modifications are done, exit the loop early
                    if done.itemLevel and done.upgradeLevel then
                        break
                    end
                end
            end

            -- Recalculate tooltip size after any modifications
            if done.itemLevel or done.upgradeLevel then
                tooltip:Show()
            end
        end
    end
end

