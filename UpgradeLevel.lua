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
    },
    global = {
        items = {},
        linktoitem = {},
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

    -- if itemName not found, return to end function call
    if not itemName then return end
    
    -- Only show for armor and weapons
    if itemType == "Armor" or itemType == "Weapon" then
        -- Get current item level - use the itemLevel from GetItemInfo since we have itemLink
        local currentItemLevel = itemLevel
        
        -- Method 1: Try GetDetailedItemLevelInfo for upgradeable items
        local maxItemLevel = nil
        local currentDetailedLevel, hasPreview, sparksRemaining = C_Item.GetDetailedItemLevelInfo(itemLink)
        -- GetDetailedItemLevelInfo doesn't directly give us max level, so we'll rely on other methods
        
        -- Method 2: For items with upgrade levels, calculate max from base + upgrades
        if not maxItemLevel then
            local upgradeInfo = C_Item.GetItemStats(itemLink)
            local numBonusIDs = C_Item.GetNumItemUpgrades and C_Item.GetNumItemUpgrades(itemLink) or 0
            if numBonusIDs and numBonusIDs > 0 then
                -- For many items, each upgrade adds 5-15 item levels
                local baseItemLevel = C_Item.GetBaseItemLevel and C_Item.GetBaseItemLevel(itemLink) or currentItemLevel
                -- This is an approximation - actual values vary by item type and expansion
                maxItemLevel = baseItemLevel + (numBonusIDs * 10)
            end
        end
        
        print(("Item: %s, Current Level: %d, Max Level: %s"):format(itemName, currentItemLevel or 0, maxItemLevel and tostring(maxItemLevel) or "Unknown"))

        if currentItemLevel and maxItemLevel and currentItemLevel < maxItemLevel then
            -- Only show if we want to display max levels
            if not self.db.profile.showMaxLevel then
                return
            end
            
            -- If showOnlyUpgradeable is true, only show for items that can be upgraded
            if self.db.profile.showOnlyUpgradeable and currentItemLevel >= maxItemLevel then
                return
            end
            
            print("here2")
            -- Find the item level line in the tooltip and modify it
            for i = 2, tooltip:NumLines() do
                print("here3")
                local line = _G[tooltip:GetName() .. "TextLeft" .. i]
                print(line)
                if line and line:GetText() then
                    local text = line:GetText()
                    -- Look for "Item Level XXX" pattern
                    if text:match("Item Level %d+") then
                        local colorCode = self.db.profile.colorCode or "00ff00"
                        local newText = text .. " |cff" .. colorCode .. "(Max: " .. maxItemLevel .. ")|r"
                        line:SetText(newText)
                        tooltip:Show()
                        return
                    end
                end
            end
        end
    end
end

