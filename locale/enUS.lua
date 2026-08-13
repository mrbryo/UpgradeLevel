--[[---------------------------------------------------------------------------
    Localization for Action Bar Sync
    Language: English (US)
-----------------------------------------------------------------------------]]

local addonName, ns = ...

local L = setmetatable({}, {
    __index = function(self, key)
        return key  -- fallback: return the key itself
    end,
})
ns.L = L

-- following line is replaced when packaged through curseforge using their localization tool so do not comment out when checking in otherwise the first translation will be
-- @localization(locale="enUS", format="lua_additive_table", same-key-is-true=true, handle-subnamespaces="concat", handle-unlocalized="english")@

--@do-not-package@ 
--[[ leaving all for development purposes, export from curseforge ]]
L[" at Game Version: "] = " at Game Version: " 
L[" for Expansion: "] = " for Expansion: "
L["/ul about - Open About in Options"] = "/ul about - Open About in Options"
L["/ul general - Open General Settings in Options"] = "/ul general - Open General Settings in Options"
L["/ul or /upgradelevel - Open General Settings in Options"] = "/ul or /upgradelevel - Open General Settings in Options"
L["/ul profiles - Open Profiles in Options"] = "/ul profiles - Open Profiles in Options"
L["/ul status - Show current settings in main chat window."] = "/ul status - Show current settings in main chat window."
L["About"] = "About"
L["Adventurer"] = "Adventurer"
L["Assist with translations or add a new language:"] = "Assist with translations or add a new language:"
L["Buy me a Coffee: "] = "Buy me a Coffee: "
L["Champion"] = "Champion"
L["Color"] = "Color"
L["Color Code: %s"] = "Color Code: %s"
L["Color for max level and upgrade text"] = "Color for max level and upgrade text"
L["Current Season ID"] = "Current Season ID"
L["Enable debug/trouble mode for additional logging to the saved variables file for issue submission."] = "Enable debug/trouble mode for additional logging to the saved variables file for issue submission."
L["Expansion ID"] = "Expansion ID"
L["Explorer"] = "Explorer"
L["Game Branch (Project)"] = "Game Branch (Project)"
L["General Settings"] = "General Settings"
L["Hero"] = "Hero"
L["iMX3 Author Link on Wowhead"] = "iMX3 Author Link on Wowhead"
L["Max"] = "Max"
L["Midnight Guide for Item Levels"] = "Midnight Guide for Item Levels"
L["Myth"] = "Myth"
L["New Expansion Detected! Until updated, addon will have limited functionality."] = "New Expansion Detected! Until updated, addon will have limited functionality."
L["No Data"] = "No Data"
L["No Data found for Expansion Level: "] = "No Data found for Expansion Level: "
L["No Data found for Season: "] = "No Data found for Season: "
L["Off"] = "Off"
L["On"] = "On"
L["On Wowhead, iMX3 is the author of an article which has lots of gear information on it. With out it I'm not sure where I would find the details I need for the addon with out having to write a bunch of additional code to extrapolate over time the min and max values for gear."] = "On Wowhead, iMX3 is the author of an article which has lots of gear information on it. With out it I'm not sure where I would find the details I need for the addon with out having to write a bunch of additional code to extrapolate over time the min and max values for gear."
L["Patreon: "] = "Patreon: "
L["Show Max Level"] = "Show Max Level"
L["Show Max Level: %s"] = "Show Max Level: %s"
L["Show maximum item level information in tooltips."] = "Show maximum item level information in tooltips."
L["Show upgrade level as descriptive text in tooltips."] = "Show upgrade level as descriptive text in tooltips."
L["Show Upgrade Text"] = "Show Upgrade Text"
L["Show Upgrade Text: %s"] = "Show Upgrade Text: %s"
L["To report issues or request features, please visit the GitHub repository:"] = "To report issues or request features, please visit the GitHub repository:"
L["To support this addon, please use on of the following methods:"] = "To support this addon, please use on of the following methods:"
L["ToDebugString"] = "UpgradeLevel:ToDebugString"
L["Trouble Shooting Mode"] = "Trouble Shooting Mode"
L["Thank You!"] = "Thank You!"
L["Trouble Shooting Mode: %s"] = "Trouble Shooting Mode: %s"
L["Troubleshoot"] = "Troubleshoot"
L["Upgrade Level adds item level information to armor and weapon tooltips."] = "Upgrade Level adds two pieces of information to armor and weapon tooltips:\n\n1) Max upgrade item level is added to the current item level line.\n\n2) On the Upgrade Level line, text is added to remind you of higher ranks above the item's current rank.\n\nI had to keep going back to Wowhead to look this up...so I made this addon to help me out. Enjoy!"
L["Upgrade Level Commands:"] = "Upgrade Level Commands:"
L["Veteran"] = "Veteran"
L["Champion"] = "Champion"
L["Hero"] = "Hero"
L["Myth"] = "Myth"

-- Activities
L["Delve Tiers 1-2\nNormal Dungeons\nOutdoor Activities, Patch 11.2 Campaign Quests"] = "Delve Tiers 1-2\nNormal Dungeons\nOutdoor Activities, Patch 11.2 Campaign Quests"
L["Delve Tiers 3-4\nHeroic Dungeons"] = "Delve Tiers 3-4\nHeroic Dungeons"
L["Weekly World Events\nDelve Tiers 5-6\nDelve Tiers 1-4 Great Vault\nHeroic Difficulty Dungeons Great Vault\nLFR Difficulty Raid Bosses"] = "Weekly World Events\nDelve Tiers 5-6\nDelve Tiers 1-4 Great Vault\nHeroic Difficulty Dungeons Great Vault\nLFR Difficulty Raid Bosses"
L["World Bosses\nDelve Tiers 7-11\nDelve Tiers 5-6 Great Vault\nMythic Difficulty Dungeons\nMythic Difficulty Dungeons Great Vault\nMythic+ Keystone 2-6 Dungeons\nNormal Difficulty Raid Bosses"] = "World Bosses\nDelve Tiers 7-11\nDelve Tiers 5-6 Great Vault\nMythic Difficulty Dungeons\nMythic Difficulty Dungeons Great Vault\nMythic+ Keystone 2-6 Dungeons\nNormal Difficulty Raid Bosses"
L["Delver's Bounty Maps Tier 8\nDelves Tiers 7-11 Great Vault\nMythic+ Keystone 7-10 Dungeons\nMythic+ Keystone 2-9 Dungeons Great Vault\nHeroic Difficulty Raid Bosses"] = "Delver's Bounty Maps Tier 8\nDelves Tiers 7-11 Great Vault\nMythic+ Keystone 7-10 Dungeons\nMythic+ Keystone 2-9 Dungeons Great Vault\nHeroic Difficulty Raid Bosses"
L["Mythic+ Keystone 10+ Dungeons Great Vault\nMythic Difficulty Raid Bosses"] = "Mythic+ Keystone 10+ Dungeons Great Vault\nMythic Difficulty Raid Bosses"

--@end-do-not-package@