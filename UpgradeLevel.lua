-- UpgradeLevel.lua
-- Adds upgrade level information to armor and weapon tooltips

local addonName, addonTable = ...

-- Create AceAddon
local UpgradeLevel = LibStub("AceAddon-3.0"):NewAddon("UpgradeLevel", "AceEvent-3.0")

-- Default database values
local defaults = {
    profile = {
        enabled = true,
        showMaxLevel = true,
        colorCode = "00ff00", -- Green color for max level text
        showOnlyUpgradeable = false,
        troubleMode = false,
    },
    global = {
        items = {},
        linktoitem = {},
    },
}

UpgradeLevel.vars = {
    isDevMode = true,
    maxUpgradeLevel = 975,
    upgrades = {
        [970] = {
            id = "explorer",
            name = "Explorer",
            activities = "Delve Tiers 1-2\nNormal Dungeons\nOutdoor Activities, Patch 11.2 Campaign Quests",
            levels = {
                min = 642,
                max = 665,
            },
            crests = {}
        },
        [971] = {
            id = "adventurer",
            name = "Adventurer",
            activities = "Delve Tiers 3-4\nHeroic Dungeons",
            levels = {
                min = 655,
                max = 678,
            },
            crests = {
                "weathered",
            }
        },
        [972] = {
            id = "veteran",
            name = "Veteran",
            activities = "Weekly World Events\nDelve Tiers 5-6\nDelve Tiers 1-4 Great Vault\nHeroic Difficulty Dungeons Great Vault\nLFR Difficulty Raid Bosses",
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
            id = "champion",
            name = "Champion",
            activities = "World Bosses\nDelve Tiers 7-11\nDelve Tiers 5-6 Great Vault\nMythic Difficulty Dungeons\nMythic Difficulty Dungeons Great Vault\nMythic+ Keystone 2-6 Dungeons\nNormal Difficulty Raid Bosses",
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
            id = "hero",
            name = "Hero",
            activities = "Delver's Bounty Maps Tier 8\nDelves Tiers 7-11 Great Vault\nMythic+ Keystone 7-10 Dungeons\nMythic+ Keystone 2-9 Dungeons Great Vault\nHeroic Difficulty Raid Bosses",
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
            id = "myth",
            name = "Myth",
            activities = "Mythic+ Keystone 10+ Dungeons Great Vault\nMythic Difficulty Raid Bosses",
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

function UpgradeLevel:OnInitialize()
    -- Initialize AceDB with defaults
    self.db = LibStub("AceDB-3.0"):New("UpgradeLevelDB", defaults, true)
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

function UpgradeLevel:AddUpgradeInfo(tooltip)
    -- Check if addon is enabled
    if not self.db.profile.enabled then
        return
    end

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
    if itemType == "Armor" or itemType == "Weapon" then
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
                    if text:match("Item Level %d+") and itemUpgradeInfo.maxItemLevel > 0 then
                        local colorCode = self.db.profile.colorCode or "00ff00"
                        local newText = text .. " |cff" .. colorCode .. "(Max: " .. tostring(itemUpgradeInfo.maxItemLevel) .. ")|r"
                        line:SetText(newText)
                        done.itemLevel = true
                    elseif text:match("Upgrade Level:") then
                        local colorCode = self.db.profile.colorCode or "00ff00"

                        -- build text
                        local referenceText = ""
                        local itemRankData = UpgradeLevel.vars.upgrades[itemUpgradeInfo.trackStringID]
                        local loopCount = 0
                        for i = (itemUpgradeInfo.trackStringID + 1), UpgradeLevel.vars.maxUpgradeLevel do
                            local rankData = UpgradeLevel.vars.upgrades[i]
                            if rankData then
                                -- append to reference text
                                referenceText = ("%s > %s"):format(referenceText, rankData.name)

                                -- increment loop count
                                loopCount = loopCount + 1

                                -- Limit to next two ranks for brevity
                                if loopCount > 2 then
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

