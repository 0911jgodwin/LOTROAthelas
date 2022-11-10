function Clamp(value, min, max)
	local result = math.max(value, min);
	return math.min(result, max);
end

function Round(num, numDecimalPlaces)
    if num then
        local mult = 10^(numDecimalPlaces or 0)
        local number = math.floor(num * mult + 0.5) / mult
        if (number % 1) == 0 and numDecimalPlaces ~= 0 then
            return tostring(number .. ".0")
        else
            return number
        end
    end
end

function FormatNumber(number)
    if number == nil then return 0 end
    local returnString = nil
    if number < 1000 then
        returnString = Round(number, 0)
    elseif number >= 1000 and number < 1000000 then
        returnString = Round((number / 1000), 1) .. "K"
    elseif number >= 1000000 and number < 1000000000 then
        returnString = Round((number / 1000000),1) .. "M"
    elseif number >= 1000000000 and number < 1000000000000 then 
        returnString = Round((number / 1000000000), 1) .. "B"
    elseif number >= 1000000000000 then
        returnString = Round((number / 1000000000000), 1) .. "T"
    else
        returnString = number
    end

    return returnString
end

LerpValue = class()
function LerpValue:Constructor()
	self.value = 0;
	self.target = 0;
	self.rate = 1;
end

function LerpValue:GetValue()
	return self.value;
end

function LerpValue:GetTargetValue()
	return self.target;
end

function LerpValue:SetValue( value )
	self.target = value;
end

function LerpValue:SetValueImmediate( value )
	self.value = value;
	self.target = value;
end

function LerpValue:GetRate()
	return self.rate;
end

function LerpValue:SetRate( rate )
	self.rate = rate;
end

function LerpValue:NeedsUpdate()
	return ( self.value ~= self.target );
end

function LerpValue:Update( delta )
	if ( self.value < self.target ) then
		self.value = self.value + self.rate * delta;

		if ( self.value > self.target ) then
			self.value = self.target;
		end
	elseif ( self.value > self.target ) then

		self.value = self.value - self.rate * delta;

		if ( self.value < self.target ) then
			self.value = self.target;
		end
	end
end

function ConfigureFont()
	local numbers = {};
    for i = 0, 9, 1 do
        numbers[i] = Turbine.UI.Graphic("ExoPlugins/Vitals/Resources/AG" .. i .. ".tga");
    end
    numbers[10] = Turbine.UI.Graphic("ExoPlugins/Vitals/Resources/AGColon.tga");
	return numbers;
end

--https://www.lotro.com/forums/showthread.php?428196-Writing-LoTRO-Lua-Plugins-for-Noobs&p=5784203#post5784203
function AddCallback(object, event, callback)
    if (object[event] == nil) then
        object[event] = callback;
    else
        if (type(object[event]) == "table") then
            table.insert(object[event], callback);
        else
            object[event] = {object[event], callback};
        end
    end
    return callback;
end

function RemoveCallback(object, event, callback)
    if (object[event] == callback) then
        object[event] = nil;
    else
        if (type(object[event]) == "table") then
            local size = table.getn(object[event]);
            for i = 1, size do
                if (object[event][i] == callback) then
                    table.remove(object[event], i);
                    break;
                end
            end
        end
    end
end

function LoadData(Scope, FileName)
	return LoadTable(Turbine.PluginData.Load(Scope, FileName, nil));
end

function SaveData(Scope, FileName, Data)
	Turbine.PluginData.Save(Scope, FileName, SaveTable(Data));
end

function LoadTable(Table)
	if Table == nil then
		return nil;
	end
	local Data = {};
	for key, value in pairs(Table) do
		Data[LoadField(key)] = LoadField(value);
	end
	return Data;
end

function LoadField(Field)
	if type(Field) == "table" then
		return LoadTable(Field);
	elseif type(Field) == "string" then
		if string.find(Field, "<num>") then
			return tonumber(string.sub(Field, string.find(Field, ">") + 1, string.len(Field)));
		elseif string.find(Field, "<color>") then
			return "Test";
		else
			return Field;
		end
	elseif type(Field) == "boolean" then
		return Field;
	end
end

function SaveTable(Table)
	if Table == nil then
		return nil;
	end
	local Data = {};
	for key, value in pairs(Table) do
		Data[SaveField(key)] = SaveField(value);
	end
	return Data;
end

function SaveField(Field)
	if type(Field) == "number" then 
		return ("<num>" .. tostring(Field));
	elseif type(Field) == "table" then
		return SaveTable(Field);
	elseif type(Field) == "string" then
		return Field;
	elseif type(Field) == "boolean" then
		return Field;
	end
end

function CreateHoverFunction(obj)
	local hoverFunction = function() 
		if not obj:IsVisible() then return false end

		local x, y = obj:GetMousePosition();

		local pos_x, pos_y = obj:GetPosition();
		local size_x, size_y = obj:GetSize();

		if x + pos_x >= pos_x and x + pos_x <= pos_x + size_x and y + pos_y >= pos_y and y + pos_y <= pos_y + size_y then
			obj.hover = true;

			return true;
		else
			obj.hover = false;

			return false;
		end
	end

	return hoverFunction;
end

function Debug(STRING)
    if STRING == nil or STRING == "" then return end;
    Turbine.Shell.WriteLine("<rgb=#FF5555>" .. STRING .. "</rgb>");
end

function dump(o)
    if type(o) == 'table' then
        local s = '{\n'
        for k,v in pairs(o) do
                if type(k) ~= 'number' then k = '"'..k..'"' end
                s = s .. '['..k..'] = ' .. dump(v) .. '\n'
        end
        return s .. '}\n'
    else
        return tostring(o)
    end
end


function GetClass(actor)
    local class = actor:GetClass();
    if class == Turbine.Gameplay.Class.Brawler then
        class = "Brawler";
    elseif class == Turbine.Gameplay.Class.Burglar then
        class = "Burglar";
    elseif class == Turbine.Gameplay.Class.Beorning then
        class = "Beorning";
    elseif class == Turbine.Gameplay.Class.Captain then
        class = "Captain";
    elseif class == Turbine.Gameplay.Class.Champion then
        class = "Champion";
    elseif class == Turbine.Gameplay.Class.Guardian then
        class = "Guardian";
    elseif class == Turbine.Gameplay.Class.Hunter then
        class = "Hunter";
    elseif class == Turbine.Gameplay.Class.LoreMaster then
        class = "Loremaster";
    elseif class == Turbine.Gameplay.Class.Minstrel then
        class = "Minstrel";
    elseif class == Turbine.Gameplay.Class.RuneKeeper then
        class = "Runekeeper";
    elseif class == Turbine.Gameplay.Class.Warden then
        class = "Warden";
    end

    return class;
end

function ColorToTable(color)
	local data = {
		["r"] = color.R,
		["g"] = color.G,
		["b"] = color.B,
		["a"] = color.A,
	};
	return data;
end

function TableToColor(table)
	return Turbine.UI.Color(1, table["r"], table["g"], table["b"]);
end

function GenerateDefaultSettings()
    local screenWidth, screenHeight = Turbine.UI.Display:GetSize();

    local settings = {
		["General"] = {
			["Scale"] = 75,
		},
		["Player"] = {
			["Position"] = {
                [1] = 0.25,
			    [2] = 0.64,
			},
			["Vitals"] = {
				["Morale Display"] = "Default",
				["Custom Morale Colour"] = {
					["r"] = 1,
					["g"] = 1,
					["b"] = 1,
					["a"] = 1,
				},
				["Power Display"] = "Default",
				["Custom Power Colour"] = {
					["r"] = 1,
					["g"] = 1,
					["b"] = 1,
					["a"] = 1,
				},
			},
			["Text"] = {
				["Display"] = "On Mouseover",
			},
			["Resource"] = {
				["Enabled"] = true,
				["Timeout"] = 12,
				["Pip Type"] = "Fancy",
			},
		},
		["Target"] = {
			["Enabled"] = true,
			["Position"] = {
                [1] = (((screenWidth/2) - (572/2)) / screenWidth),
			    [2] = 0.1,
			},
			["Vitals"] = {
				["Morale Display"] = "Default",
				["Custom Morale Colour"] = {
					["r"] = 1,
					["g"] = 1,
					["b"] = 1,
					["a"] = 1,
				},
			},
			["Text"] = {
				["Display"] = "On Mouseover",
			},
		},
        ["Logo"] = {
			["Position"] = {
                [1] = 0,
			    [2] = 0.01,
			},
        },
	};
    return settings;
end

function GetClassColour(class)
	if class == "Brawler" then
		return Turbine.UI.Color(0.78, 0.61, 0.43);
	elseif class == "Beorning" then
		return Turbine.UI.Color(0.78, 0.61, 0.43);
	elseif class == "Burglar" then
		return Turbine.UI.Color(82/255, 82/255, 82/255);
	elseif class == "Captain" then	
		return Turbine.UI.Color(90/255, 74/255, 211/255);
	elseif class == "Champion" then
		return Turbine.UI.Color(187/255, 27/255, 35/255);
	elseif class == "Hunter" then
		return Turbine.UI.Color(43/255, 122/255, 57/255);
	elseif class == "Guardian" then
		return Turbine.UI.Color(116/255, 50/255, 37/255);
	elseif class == "Loremaster" then
		return Turbine.UI.Color(0.25, 0.78, 0.92);
	elseif class == "Minstrel" then
		return Turbine.UI.Color(233/255, 223/255, 83/255);
	elseif class == "Runekeeper" then
		return Turbine.UI.Color(206/255, 226/255, 105/255);
	elseif class == "Warden" then
		return Turbine.UI.Color(255/255, 102/255, 0/255);
	end
	return Turbine.UI.Color(1,0,0);
end