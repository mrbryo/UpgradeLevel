-- English (US) localization for UpgradeLevel
local AceLocale = LibStub("AceLocale-3.0")
local L = AceLocale:NewLocale("UpgradeLevel", "enUS", true)

if not L then return end

-- General
L["UpgradeLevel"] = "UpgradeLevel"
L["General Settings"] = "General Settings"
L["About"] = "About"

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
L["Upgrade Level adds item level information to armor and weapon tooltips."] = "Upgrade Level adds item level information to armor and weapon tooltips."
L["To support this addon, please use on of the following methods:"] = "To support this addon, please use on of the following methods:"
L["To report issues or request features, please visit the GitHub repository:"] = "To report issues or request features, please visit the GitHub repository:"
L["Patreon: "] = "Patreon: "
L["Buy me a Coffee: "] = "Buy me a Coffee: "

-- Commands
L["UpgradeLevel Commands:"] = "UpgradeLevel Commands:"
L["/ul or /upgradelevel - Open configuration panel"] = "/ul or /upgradelevel - Open configuration panel"
L["/ul config - Open configuration panel"] = "/ul config - Open configuration panel"
L["/ul toggle - Toggle addon on/off"] = "/ul toggle - Toggle addon on/off"
L["/ul status - Show current settings"] = "/ul status - Show current settings"

-- Status messages
L["Show Max Level: %s"] = "Show Max Level: %s"
L["Show Upgrade Text: %s"] = "Show Upgrade Text: %s"
L["Color Code: %s"] = "Color Code: %s"
L["Trouble Shooting Mode: %s"] = "Trouble Shooting Mode: %s"
L["On"] = "On"
L["Off"] = "Off"
L["Max"] = "Max"

-- ChatCommand debug
L["ChatCommand called with input: "] = "ChatCommand called with input: "
