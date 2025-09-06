-- UpgradeLevel.lua
-- Adds upgrade level information to armor and weapon tooltips

local addonName, addonTable = ...

-- Initialize AceLocale
local L = LibStub("AceLocale-3.0"):GetLocale("UpgradeLevel", true)

-- Create AceAddon
local UpgradeLevel = LibStub("AceAddon-3.0"):NewAddon("UpgradeLevel", "AceEvent-3.0", "AceConsole-3.0")

-- Default database values
local defaults = {
    profile = {
        showMaxLevel = true,
        colorCode = "00ff00", -- Green color for max level text
        troubleMode = false,
        showUpgradeText = true,
        -- showUpgradeLevel = true,
    },
    global = {
        items = {},
        linktoitem = {},
    },
}

UpgradeLevel.vars = {
    isDevMode = true,
    maxUpgradeLevel = 975,
    maxUpgradeRank = 1,
    upgrades = {
        [970] = {
            rank = 6,
            id = "explorer",
            name = L["Explorer"],
            activities = L["Delve Tiers 1-2\nNormal Dungeons\nOutdoor Activities, Patch 11.2 Campaign Quests"],
            levels = {
                min = 642,
                max = 665,
            },
            crests = {}
        },
        [971] = {
            rank = 5,
            id = "adventurer",
            name = L["Adventurer"],
            activities = L["Delve Tiers 3-4\nHeroic Dungeons"],
            levels = {
                min = 655,
                max = 678,
            },
            crests = {
                "weathered",
            }
        },
        [972] = {
            rank = 4,
            id = "veteran",
            name = L["Veteran"],
            activities = L["Weekly World Events\nDelve Tiers 5-6\nDelve Tiers 1-4 Great Vault\nHeroic Difficulty Dungeons Great Vault\nLFR Difficulty Raid Bosses"],
            levels = {
                min = 668,
                max = 691,
            },
            crests = {
                "weathered",
                "carved",
            }
        },
        [973] = {
            rank = 3,
            id = "champion",
            name = L["Champion"],
            activities = L["World Bosses\nDelve Tiers 7-11\nDelve Tiers 5-6 Great Vault\nMythic Difficulty Dungeons\nMythic Difficulty Dungeons Great Vault\nMythic+ Keystone 2-6 Dungeons\nNormal Difficulty Raid Bosses"],
            levels = {
                min = 681,
                max = 704,
            },
            crests = {
                "carved",
                "runed",
            }
        },
        [974] = {
            rank = 2,
            id = "hero",
            name = L["Hero"],
            activities = L["Delver's Bounty Maps Tier 8\nDelves Tiers 7-11 Great Vault\nMythic+ Keystone 7-10 Dungeons\nMythic+ Keystone 2-9 Dungeons Great Vault\nHeroic Difficulty Raid Bosses"],
            levels = {
                min = 694,
                max = 710,
            },
            crests = {
                "runed",
                "gilded",
            }
        },
        [975] = {
            rank = 1,
            id = "myth",
            name = L["Myth"],
            activities = L["Mythic+ Keystone 10+ Dungeons Great Vault\nMythic Difficulty Raid Bosses"],
            levels = {
                min = 707,
                max = 723,
            },
            crests = {
                "gilded",
            }
        },
    },
}

-- AceConfig options table
local options = {
    name = "Upgrade Level",
    handler = UpgradeLevel,
    type = "group",
    args = {
        about = {
            name = L["About"],
            type = "group",
            order = 0,
            args = {
                description = {
                    type = "description",
                    name = L["Upgrade Level adds item level information to armor and weapon tooltips."],
                    order = 1,
                },
                support = {
                    type = "description",
                    name = L["To support this addon, please use on of the following methods:"],
                    order = 2,
                },
                patreon = {
                    type = "input",
                    get = function() return "https://www.patreon.com/Bryo" end,
                    set = function() end,
                    name = L["Patreon: "],
                    width = "full",
                    order = 3,
                },
                buymeacoffee = {
                    type = "input",
                    get = function() return "https://www.buymeacoffee.com/mrbryo" end,
                    set = function() end,
                    name = L["Buy me a Coffee: "],
                    width = "full",
                    order = 4,
                },
                github = {
                    type = "input",
                    get = function() return "https://github.com/mrbryo/UpgradeLevel/issues" end,
                    set = function() end,
                    name = L["To report issues or request features, please visit the GitHub repository:"],
                    width = "full",
                    order = 5,
                },
            },
        },
        general = {
            name = L["General Settings"],
            type = "group",
            order = 1,
            args = {
                showMaxLevel = {
                    type = "toggle",
                    name = L["Show Max Level"],
                    desc = L["Show maximum item level information in tooltips."],
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
                    name = L["Show Upgrade Text"],
                    desc = L["Show upgrade level as descriptive text in tooltips."],
                    get = function(info) return UpgradeLevel.db.profile.showUpgradeText or false end,
                    set = function(info, val) UpgradeLevel.db.profile.showUpgradeText = val end,
                    order = 3,
                },
                colorCode = {
                    type = "color",
                    name = L["Color"],
                    desc = L["Color for max level and upgrade text"],
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
                    name = L["Trouble Shooting Mode"],
                    desc = L["Enable debug/trouble mode for additional logging to the saved variables file for issue submission."],
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
    },
}

function UpgradeLevel:OnInitialize()
    -- Initialize AceDB with defaults
    self.db = LibStub("AceDB-3.0"):New("UpgradeLevelDB", defaults, true)
    
    -- Add profiles to options table now that db exists
    options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
    
    -- Setup AceConfig
    LibStub("AceConfig-3.0"):RegisterOptionsTable("UpgradeLevel", options)
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("UpgradeLevel", "Upgrade Level")
    
    -- Register slash commands using AceConsole
    self:RegisterChatCommand("upgradelevel", "ChatCommand")
    self:RegisterChatCommand("ul", "ChatCommand")
end

function UpgradeLevel:OnEnable()
    -- Register events and set up hooks when addon is enabled
    self:SetupTooltipHooks()
end

function UpgradeLevel:SetupTooltipHooks()
    -- Hook tooltip methods using the proper approach
    local function OnTooltipSetItem(tooltip)
        self:AddUpgradeInfo(tooltip)
    end
    
    -- Override the tooltip's methods
    hooksecurefunc(GameTooltip, "SetBagItem", OnTooltipSetItem)
    hooksecurefunc(GameTooltip, "SetInventoryItem", OnTooltipSetItem)
    hooksecurefunc(GameTooltip, "SetHyperlink", OnTooltipSetItem)
    hooksecurefunc(ItemRefTooltip, "SetHyperlink", OnTooltipSetItem)
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
        self:Print(L["Show Max Level: %s"]:format(self.db.profile.showMaxLevel and L["On"] or L["Off"]))
        self:Print(L["Show Upgrade Text: %s"]:format(self.db.profile.showUpgradeText and L["On"] or L["Off"]))
        self:Print(L["Color Code: %s"]:format(self.db.profile.colorCode))
        self:Print(L["Trouble Shooting Mode: %s"]:format(self.db.profile.troubleMode and L["On"] or L["Off"]))
    else
        -- Show help
        self:Print(L["UpgradeLevel Commands:"])
        self:Print(L["/ul or /upgradelevel - Open configuration panel"])
        self:Print(L["/ul config - Open configuration panel"])
        self:Print(L["/ul toggle - Toggle addon on/off"])
        self:Print(L["/ul status - Show current settings"])
    end
end

function UpgradeLevel:AddUpgradeInfo(tooltip)
    -- get tooltips item link
    local _, itemLink = tooltip:GetItem()

    -- if itemLink not found, return to end function call
    if not itemLink then return end

    -- fetch the itemID from the itemLink
    local itemID = C_Item.GetItemIDForItemInfo(itemLink)

    -- fetch item info using C_Item.GetItemInfo, returned value 2 is also itemLink, no need to override what is fetched from tooltip
    local itemName, _, itemQuality, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, ItemTexture, sellPrice, classID, subclassID, bindType, expansionID, setID, isCraftingReagent = C_Item.GetItemInfo(itemLink)

    -- add to db if not already present
    if self.db.profile.troubleMode == true then
        if itemID and not self.db.global.items[itemID] then
            -- main item table
            self.db.global.items[itemID] = {
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
            }
            -- for reverse lookup by itemLink to get itemID, then get the itemID from the items table
            self.db.global.linktoitem[itemLink] = itemID
        end
    end

    -- if itemName not found, return to end function call
    if not itemName then return end

    -- Only show for armor and weapons
    if (itemType == "Armor" or itemType == "Weapon") and (self.db.profile.showMaxLevel == true or self.db.profile.showUpgradeText == true or self.db.profile.showUpgradeLevel == true) then
        -- get the item upgrade information
        local itemUpgradeInfo = C_Item.GetItemUpgradeInfo(itemLink)
        
        -- add details
        if self.db.profile.troubleMode == true then 
            self.db.global.items[itemID].currentLevel = itemUpgradeInfo and itemUpgradeInfo.currentLevel or 0
            self.db.global.items[itemID].maxLevel = itemUpgradeInfo and itemUpgradeInfo.maxLevel or 0
            self.db.global.items[itemID].maxItemLevel = itemUpgradeInfo and itemUpgradeInfo.maxItemLevel or 0
            self.db.global.items[itemID].trackString = itemUpgradeInfo and itemUpgradeInfo.trackString or ""
            self.db.global.items[itemID].trackStringID = itemUpgradeInfo and itemUpgradeInfo.trackStringID or 0
        end

        if itemUpgradeInfo then
            -- track additions
            local done = {
                itemLevel = false,
                upgradeLevel = false,
            }

            -- Find the item level line in the tooltip and modify it
            for i = 2, tooltip:NumLines() do
                -- create tmp variable to hold line
                local line = _G[tooltip:GetName() .. "TextLeft" .. i]

                -- if the line is valid and has text, proceed
                if line and line:GetText() then
                    -- get the line text
                    local text = line:GetText()

                    -- Look for "Item Level XXX" pattern
                    if text:match("Item Level %d+") and itemUpgradeInfo.maxItemLevel > 0 and self.db.profile.showMaxLevel == true then
                        local colorCode = self.db.profile.colorCode or "00ff00"
                        local newText = text .. " |cff" .. colorCode .. "(" .. L["Max"] .. ": " .. tostring(itemUpgradeInfo.maxItemLevel) .. ")|r"
                        line:SetText(newText)
                        done.itemLevel = true
                    elseif text:match("Upgrade Level:") and (self.db.profile.showUpgradeText == true or self.db.profile.showUpgradeLevel == true) then
                        local colorCode = self.db.profile.colorCode or "00ff00"

                        -- build text
                        local referenceText = ""
                        local itemRankData = UpgradeLevel.vars.upgrades[itemUpgradeInfo.trackStringID]
                        local loopCount = 0

                        -- append numeric level if enabled
                        -- if self.db.profile.showUpgradeLevel == true then
                        --     referenceText = ("(%d/%d) "):format(itemRankData.rank, UpgradeLevel.vars.maxUpgradeRank)
                        -- end

                        for i = (itemUpgradeInfo.trackStringID + 1), UpgradeLevel.vars.maxUpgradeLevel do
                            local rankData = UpgradeLevel.vars.upgrades[i]
                            if rankData then
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

                        local newText = text .. " |cff" .. colorCode .. referenceText .. "|r"
                        line:SetText(newText)
                        done.upgradeLevel = true
                    end

                    -- If both modifications are done, exit the loop early
                    if done.itemLevel and done.upgradeLevel then
                        tooltip:Show()
                        return
                    end
                end
            end
        end
    end
end

