# TooltipDataProcessor.AddLinePostCall Documentation

## Overview

`TooltipDataProcessor.AddLinePostCall` is a World of Warcraft addon API function that allows you to register callback functions to be executed **after** a specific type of tooltip line is processed and added to a tooltip. This is part of the newer tooltip system introduced in Patch 10.0.2 that replaced older script handler approaches like `OnTooltipSetItem` and `OnTooltipSetSpell`.

## API Signature

```lua
TooltipDataProcessor.AddLinePostCall(lineType, callbackFunction)
```

### Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `lineType` | `Enum.TooltipDataLineType` | The type of tooltip line to hook into (e.g., `GemSocket`, `RuneSocket`, etc.) |
| `callbackFunction` | `function` | The function to execute after the line is added. Signature: `function(self, lineData)` |

### Return Value

None

## When It Executes

- **PostCall** means your callback executes **after** the line has been added to the tooltip
- This allows you to modify or enhance tooltip line data after it's been processed
- The callback receives the tooltip frame (`self`) and the line data object (`lineData`)

## Common Enum.TooltipDataLineType Values

Here are some commonly used line type enumerations:

```lua
Enum.TooltipDataLineType.GemSocket          -- Gem socket information
Enum.TooltipDataLineType.RuneSocket         -- Rune socket information
Enum.TooltipDataLineType.AzeriteEmpowered   -- Azerite empowered info
Enum.TooltipDataLineType.ItemLevel          -- Item level display
Enum.TooltipDataLineType.ItemPowerLevel     -- Item power level
Enum.TooltipDataLineType.SpellPower         -- Spell power information
```

For a complete list, use the `/run` command in-game to explore `Enum.TooltipDataLineType`.

## Related API Functions

The `TooltipDataProcessor` system includes four main functions:

| Function | Purpose |
|----------|---------|
| `AddTooltipPreCall()` | Execute before tooltip data is processed |
| `AddTooltipPostCall()` | Execute after entire tooltip is processed |
| `AddLinePreCall()` | Execute before a specific line is added |
| `AddLinePostCall()` | Execute after a specific line is added |

## Basic Usage Example

```lua
-- Register a callback for gem socket lines
TooltipDataProcessor.AddLinePostCall(Enum.TooltipDataLineType.GemSocket, function(tooltip, lineData)
    -- lineData contains information about the gem socket line
    -- You can modify colors, text, or add additional information
    if lineData.socketText then
        print("Gem Socket: " .. lineData.socketText)
    end
end)
```

## Practical Examples

### Example 1: Add Custom Text to Gem Sockets

```lua
local addonName, ns = ...

TooltipDataProcessor.AddLinePostCall(Enum.TooltipDataLineType.GemSocket, function(tooltip, lineData)
    if lineData and lineData.socketText then
        -- Modify the socket display with custom information
        lineData.socketText = lineData.socketText .. " [CUSTOM]"
    end
end)
```

### Example 2: Track Multiple Line Types

```lua
local addonName, ns = ...

local function ProcessGemSocketLine(tooltip, lineData)
    -- Custom logic for gem sockets
    if lineData.quality then
        print("Gem Quality: " .. lineData.quality)
    end
end

local function ProcessRuneSocketLine(tooltip, lineData)
    -- Custom logic for rune sockets
    if lineData.socketText then
        print("Rune Socket: " .. lineData.socketText)
    end
end

-- Register both callbacks
TooltipDataProcessor.AddLinePostCall(Enum.TooltipDataLineType.GemSocket, ProcessGemSocketLine)
TooltipDataProcessor.AddLinePostCall(Enum.TooltipDataLineType.RuneSocket, ProcessRuneSocketLine)
```

### Example 3: Conditional Modifications Based on Item Type

```lua
local addonName, ns = ...

TooltipDataProcessor.AddLinePostCall(Enum.TooltipDataLineType.ItemLevel, function(tooltip, lineData)
    -- Only modify if we have valid data
    if not lineData or not lineData.level then
        return
    end
    
    -- Add maximum item level information (similar to UpgradeLevel addon pattern)
    local itemLevel = lineData.level
    if itemLevel > 0 then
        lineData.customText = "Max Level: " .. (itemLevel + 10)
    end
end)
```

## Important Considerations

### Callback Scope
- Callbacks registered with TooltipDataProcessor are **global** and trigger for all tooltips
- They affect all tooltips that inherit from `GameTooltipTemplate`
- The callbacks fire for every tooltip displayed, so keep logic efficient

### Taint Concerns
- **Important**: There is a known issue where TooltipDataProcessor callbacks can cause UI taint that propagates to protected frames
- This can break actionbar functionality during combat if taint is triggered
- See the GitHub issue discussion (linked below) for more details and workarounds
- Consider using `securecall()` wrapper if your callback executes in secure contexts

### Performance
- Keep callback logic minimal to avoid tooltip display lag
- Avoid expensive operations (database queries, complex calculations) in postCall handlers
- Test thoroughly to ensure your addon doesn't cause tooltip performance issues

### Registration Timing
- Register callbacks during addon initialization (OnInitialize or ADDON_LOADED event)
- Multiple callbacks for the same line type are all executed sequentially
- Callbacks are stored in shared tables and dispatched globally

## Common Pitfalls

### 1. Incorrect Line Type
```lua
-- ❌ WRONG - May cause errors if line type doesn't exist
TooltipDataProcessor.AddLinePostCall("InvalidType", callback)

-- ✅ CORRECT - Use proper Enum value
TooltipDataProcessor.AddLinePostCall(Enum.TooltipDataLineType.GemSocket, callback)
```

### 2. Not Checking for Nil Data
```lua
-- ❌ WRONG - Can crash if lineData is nil
local text = lineData.socketText .. " Extra"

-- ✅ CORRECT - Always validate data exists
if lineData and lineData.socketText then
    lineData.socketText = lineData.socketText .. " Extra"
end
```

### 3. Modifying Data Incorrectly
```lua
-- ❌ WRONG - May not persist changes
lineData.socketText = "New Text"

-- ✅ CORRECT - Understand lineData structure first
-- Check what fields are available and modifiable in your target line type
if lineData.socketText then
    lineData.socketText = "New Text"
end
```

## Real-World Addon Examples

### SimpleItemLevel Addon
- **Purpose**: Displays item level on tooltips
- **GitHub**: [kemayo/wow-simpleitemlevel](https://github.com/kemayo/wow-simpleitemlevel)
- **Uses**: `TooltipDataProcessor.AddTooltipPostCall()` for comprehensive tooltip processing

### AppearanceTooltip Addon
- **Purpose**: Shows 3D model preview of item appearances on tooltips
- **GitHub**: [kemayo/wow-appearancetooltip](https://github.com/kemayo/wow-appearancetooltip)
- **Pattern**: Registers `AddTooltipPostCall` to intercept item tooltip data
- **Code Pattern**:
  ```lua
  TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(self, data)
      if tooltips[self] then
          local link = data.guid and C_Item.GetItemLinkByGUID(data.guid) or data.hyperlink
          ns:ShowItem(link, self)
      end
  end)
  ```

### UpgradeLevel Addon (This Project)
- **Purpose**: Displays item upgrade levels and maximum item levels
- **Pattern**: Could use `AddTooltipPostCall` for processing item upgrade information
- **Related**: Uses tooltip hooking to add upgrade rank information

## Testing Your Implementation

### Debug Method 1: Print to Chat
```lua
TooltipDataProcessor.AddLinePostCall(Enum.TooltipDataLineType.GemSocket, function(tooltip, lineData)
    if lineData then
        print("Line Data Keys:", table.concat(GetTableKeys(lineData), ", "))
    end
end)
```

### Debug Method 2: Use DevTool
- Install the DevTool addon: [GitHub: DevTool](https://github.com/brittyazel/DevTool)
- Use `/run DevTool_AddData(Enum.TooltipDataLineType, "TooltipDataLineType")` to inspect enum values
- Hover over items to see the actual line type values

### Debug Method 3: Register for All Line Types
```lua
-- Create a loop to understand what line types are available
local lineTypeDebug = function(tooltip, lineData)
    print("LineData:", lineData)
end

-- Note: This is exploratory - don't leave this in production code
for key, value in pairs(Enum.TooltipDataLineType) do
    TooltipDataProcessor.AddLinePostCall(value, lineTypeDebug)
end
```

## Addon Initialization Best Practice

```lua
local addonName, ns = ...

local function OnAddonsLoaded(event, addon)
    if addon ~= addonName then
        return
    end
    
    -- Register all your TooltipDataProcessor callbacks here
    TooltipDataProcessor.AddLinePostCall(Enum.TooltipDataLineType.GemSocket, function(tooltip, lineData)
        -- Your logic here
    end)
    
    -- Unregister the event after initialization
    ns:UnregisterEvent("ADDON_LOADED")
end

ns:RegisterEvent("ADDON_LOADED", OnAddonsLoaded)
```

## Known Issues and Workarounds

### Issue: Taint Propagation to Protected Frames
**Description**: TooltipDataProcessor callbacks can cause secure code taint that breaks actionbars and other protected UI elements during combat.

**Reference**: [GitHub Issue: TooltipDataProcessor callback taint can break actionbars](https://github.com/Stanzilla/WoWUIBugs/issues/298)

**Workaround**: 
```lua
-- Wrap your callback in securecall to isolate taint
local function SafeCallback(tooltip, lineData)
    -- Your logic here
end

TooltipDataProcessor.AddLinePostCall(Enum.TooltipDataLineType.GemSocket, function(tooltip, lineData)
    securecall(SafeCallback, tooltip, lineData)
end)
```

### Issue: Line Type Not Recognized
**Solution**: Verify you're using the correct Enum value for your WoW version. Some line types may not exist in older expansions.

## Version Compatibility

- **Introduced**: Patch 10.0.2 (Dragonflight)
- **Available In**: Retail, Cata-Classic, and newer versions
- **Not Available In**: Classic/Vanilla, TBC Classic (prior to Cata)

## References and Resources

- [Tooltip API - Warcraft Wiki](https://warcraft.wiki.gg/wiki/Tooltip_API)
- [TooltipDataProcessor GitHub Issue Discussion](https://github.com/Stanzilla/WoWUIBugs/issues/298)
- [Tooltip Spec Addon - WowAce](https://www.wowace.com/projects/tooltip-spec)
- [DevTool Addon for Debugging](https://github.com/brittyazel/DevTool)

## Summary

`TooltipDataProcessor.AddLinePostCall` is a powerful tool for modifying specific types of tooltip lines in World of Warcraft addons. By registering callbacks with specific line type enumerations, you can enhance tooltips with custom information, modify existing data, and create more informative in-game experiences. Always remember to validate your data, keep callbacks efficient, and be aware of potential taint issues in secure contexts.
