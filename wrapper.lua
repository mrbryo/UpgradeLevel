--[[
    Simply the idea is copied from AllTheThings. Credit to Crieve!
    This is in response to Blizzard grieving addon developers with last minute API changes. As you will see in several addon change logs...
]]

local app = select(2, ...);
app.GameBuildVersion = select(4, GetBuildInfo());
app.IsRetail = app.GameBuildVersion >= 110000;
app.AfterCata = app.GameBuildVersion >= 40000;
app.IsClassic = not app.IsRetail;

app.EmptyFunction = function() end;
app.EmptyTable = setmetatable({}, { __newindex = app.EmptyFunction });

local lib = setmetatable({}, {
	__index = function(t, key)
		error("API " .. key .. " not available! Please open an issue for this addon. Link to Issue Tracker is in the About section in options or addon window.");
	end
});

-- Local cache
local select,type,rawget
	= select,type,rawget
app.WOWAPI = lib;

-- Priority API assigner.
-- Can be used to one-line assign the most relevant API to the specified WOWAPI wrapper.
---@param name string
---@param ... function|nil
local function AssignAPIWrapper(name, ...)
	for i = 1, select("#", ...) do
		local api = select(i, ...)  -- Get API Function
		if api then
			if rawget(lib, name) then
				print("Warning: existing ATT.WOWAPI replaced!", name)
			end
			lib[name] = api
			return  -- Return immediately after successful assignment.
		end
	end
	print("No valid function for", name)  -- If no valid function is found, print an error message.
end

-- System Level APIs
AssignAPIWrapper("issecretvalue", issecretvalue, function() return false; end);

-- TODO: Add the rest of the blizzard api's here in some future update.