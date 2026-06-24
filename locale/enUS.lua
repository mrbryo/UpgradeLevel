-- English (US) localization for UpgradeLevel
local AceLocale = LibStub("AceLocale-3.0")
local L = AceLocale:NewLocale("UpgradeLevel", "enUS", true)

if not L then return end

-- following line is replaced when packaged through curseforge using their localization tool
@localization(locale="enUS", format="lua_additive_table", same-key-is-true=true, handle-subnamespaces="concat", handle-unlocalized="english")@

--@do-not-package@ 
--[[ leaving all for development purposes, export from curseforge ]]

-- General
L["General Settings"] = "General Settings"
L["About"] = "About"
L["No Data"] = "No Data"

-- Settings
L["Show Max Level"] = "Show Max Level"
L["Show maximum item level information in tooltips."] = "Show maximum item level information in tooltips."
L["Show Upgrade Text"] = "Show Upgrade Text"
L["Show upgrade level as descriptive text in tooltips."] = "Show upgrade level as descriptive text in tooltips."
L["Color"] = "Color"
L["Color for max level and upgrade text"] = "Color for max level and upgrade text"
L["Trouble Shooting Mode"] = "Trouble Shooting Mode"
L["Enable debug/trouble mode for additional logging to the saved variables file for issue submission."] = "Enable debug/trouble mode for additional logging to the saved variables file for issue submission."

-- Descriptions
L["Upgrade Level adds item level information to armor and weapon tooltips."] = "Upgrade Level adds two pieces of information to armor and weapon tooltips:\n\n1) Max upgrade item level is added to the current item level line.\n\n2) On the Upgrade Level line, text is added to remind you of higher ranks above the item's current rank.\n\nI had to keep going back to Wowhead to look this up...so I made this addon to help me out. Enjoy!"
L["To support this addon, please use on of the following methods:"] = "To support this addon, please use on of the following methods:"
L["To report issues or request features, please visit the GitHub repository:"] = "To report issues or request features, please visit the GitHub repository:"
L["Assist with translations or add a new language:"] = "Assist with translations or add a new language:"
L["Patreon: "] = "Patreon: "
L["Buy me a Coffee: "] = "Buy me a Coffee: "

-- Commands
L["Upgrade Level Commands:"] = "Upgrade Level Commands:"
L["/ul or /upgradelevel - Open General Settings in Options"] = "/ul or /upgradelevel - Open General Settings in Options"
L["/ul general - Open General Settings in Options"] = "/ul general - Open General Settings in Options"
L["/ul profiles - Open Profiles in Options"] = "/ul profiles - Open Profiles in Options"
L["/ul about - Open About in Options"] = "/ul about - Open About in Options"
L["/ul status - Show current settings in main chat window."] = "/ul status - Show current settings in main chat window."

-- Status messages
L["Show Max Level: %s"] = "Show Max Level: %s"
L["Show Upgrade Text: %s"] = "Show Upgrade Text: %s"
L["Color Code: %s"] = "Color Code: %s"
L["Trouble Shooting Mode: %s"] = "Trouble Shooting Mode: %s"
L["On"] = "On"
L["Off"] = "Off"
L["Max"] = "Max"

-- Upgrade Ranks
L["Explorer"] = "Explorer"
L["Adventurer"] = "Adventurer"
L["Veteran"] = "Veteran"
L["Champion"] = "Champion"
L["Hero"] = "Hero"
L["Myth"] = "Myth"

-- Something Weird Blizzard Introduced???
L["ToDebugString"] = "UpgradeLevel:ToDebugString"

-- Game Version Detections
L["No Data found for Season: "] = "No Data found for Season: "
L[" for Expansion: "] = " for Expansion: "
L[" at Game Version: "] = " at Game Version: "
L["New Expansion Detected! Until updated, addon will have limited functionality."] = "New Expansion Detected! Until updated, addon will have limited functionality."

--@end-do-not-package@