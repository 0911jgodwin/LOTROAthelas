ClassHolder = class( Turbine.UI.Control );
function ClassHolder:Constructor()
	Turbine.UI.Control.Constructor( self );
	self:SetSize(282, 59);
	self.scaleModifier = Settings["General"]["Scale"]/100;

	self.player = Turbine.Gameplay.LocalPlayer.GetInstance();
	self.playerAttributes = self.player:GetClassAttributes();

	self.frame = Turbine.UI.Control();
	self.frame:SetParent( self );
	self.frame:SetBackground( "ExoPlugins/Athelas/Resources/resourceframe.tga" );
	self.frame:SetBackColorBlendMode( Turbine.UI.BlendMode.Multiply );
	self.frame:SetSize(282, 59);
	self.frame:SetVisible(true);
	self.frame:SetMouseVisible(false);
	self.frame:SetZOrder(95);

	local class = GetClass(self.player);
	self.effectsCallback = {};
	self.attributesCallback = {};
	self.timer = 0;

	if class == "Runekeeper" then
		self.resource = ResourceBar(self, 180, 20, 9, "ExoPlugins/Athelas/Resources/dagor.tga");
		self.resource:SetPosition(51, 16);
		self.resource:SetAttunementTotal(self.playerAttributes:GetAttunement());

		self.attributesCallback["AttunementChanged"] = AddCallback(self.playerAttributes, "AttunementChanged", function(sender, args)
			self.resource:SetAttunementTotal(self.playerAttributes:GetAttunement());
			self:ResourceChanged();
		end);
	elseif class == "Brawler" then
		self.resource = ResourceBar(self, 180, 20, 9, "ExoPlugins/Athelas/Resources/mettle.tga");
		self.resource:SetPosition(51, 16);
		self.resource:SetTotal(0);

		self.BattleFlow = {
			["Battle Flow 1"] = 1,
			["Battle Flow 2"] = 2,
			["Battle Flow 3"] = 3,
			["Battle Flow 4"] = 4,
			["Battle Flow 5"] = 5,
			["Battle Flow 6"] = 6,
			["Battle Flow 7"] = 7,
			["Battle Flow 8"] = 8,
			["Battle Flow 9"] = 9,
		};
		self.lastTier = "Battle Flow 1";

		self.playerEffects = self.player:GetEffects();

		self.effectsCallback["EffectAdded"] = AddCallback(self.playerEffects, "EffectAdded", function(sender, args)
			local effectName = self.playerEffects:Get(args.Index):GetName();
			if self.BattleFlow[effectName] ~= nil then
				self.lastTier = effectName;
				self.resource:SetTotal(self.BattleFlow[effectName]);
				self:ResourceChanged();
			end
		end);

		self.effectsCallback["EffectRemoved"] = AddCallback(self.playerEffects, "EffectRemoved", function(sender, args)
			local effect = args.Effect;
			if effect ~= nil then 
				local effectName = effect:GetName();
				if effectName == self.lastTier then
					self.resource:SetTotal(0);
					self:ResourceChanged();
				end
			end
		end);

	elseif class == "Hunter" then
		self.resource = ResourceBar(self, 180, 20, 9, "ExoPlugins/Athelas/Resources/focus.tga");
		self.resource:SetPosition(51, 16);
		self.resource:SetTotal(self.playerAttributes:GetFocus());

		self.attributesCallback["FocusChanged"] = AddCallback(self.playerAttributes, "FocusChanged", function(sender, args)
			self.resource:SetTotal(self.playerAttributes:GetFocus());
			self:ResourceChanged();
		end);
	elseif class == "Champion" then
		self.resource = ResourceBar(self, 180, 20, 5, "ExoPlugins/Athelas/Resources/fervor.tga");
		self.resource:SetPosition(51, 16);
		self.resource:SetTotal(self.playerAttributes:GetFervor());

		self.attributesCallback["FervorChanged"] = AddCallback(self.playerAttributes, "FervorChanged", function(sender, args)
			self.resource:SetTotal(self.playerAttributes:GetFervor());
			self:ResourceChanged();
		end);
	elseif class == "Warden" then
		self.resource = ResourceBar(self, 180, 20, 5, "ExoPlugins/Athelas/Resources/empty.tga");
		self.resource:SetPosition(51, 16);
		self.resource:ConfigureGambitInfo(self.playerAttributes);
		self.attributesCallback["GambitChanged"] = AddCallback(self.playerAttributes, "GambitChanged", function(sender, args)
			self.resource:AdjustGambitDisplay();
			self:ResourceChanged();
		end);
	end

	self.CombatCallback = AddCallback(self.player, "InCombatChanged", function(sender, args)
		if self.player:IsInCombat() then self:SetActive(true) end
	end);

	self.updateCallback = AddCallback(Updater, "Tick", function(sender, args)
		if self.player:IsInCombat() then return end
		self.timer = self.timer + 0.5;
		if self.timer > Settings["Player"]["Resource"]["Timeout"] then
			self:SetActive(false);
		end
	end);

	self.lastTick = Turbine.Engine.GetGameTime();
	self.Update = function()
		if self:GetTop() == self.endPoint then self:SetWantsUpdates(false) return end
        if Turbine.Engine.GetGameTime() - self.lastTick < 0.05 then return end
		self:SetTop(self:GetTop() + self.direction);
    end
	if self.resource ~= nil then
		self.resource:SetStretchMode(1);
		self.resource:SetSize(math.ceil(180*self.scaleModifier), math.ceil(20*self.scaleModifier));
		self.resource:SetPosition(math.ceil(51*self.scaleModifier), math.ceil(16*self.scaleModifier));
	end
	self.frame:SetStretchMode(1);
	self.frame:SetSize(math.ceil(282*self.scaleModifier), math.ceil(59*self.scaleModifier));
end

function ClassHolder:SetActive(bool)
	if bool then
		self.endPoint = math.floor(33-math.ceil(33*self.scaleModifier));
		self.direction = -1;
	else
		self.endPoint = math.ceil(33*self.scaleModifier)+((1-self.scaleModifier)*10*2);
		self.direction = 1;
	end
	self:SetWantsUpdates(true);
end

function ClassHolder:ResourceChanged()
	self.timer = 0;
	self:SetActive(true);
end

function ClassHolder:Unload()
	for key, value in pairs(self.attributesCallback) do
        RemoveCallback(self.playerAttributes, key, value);
        self.attributesCallback[key] = nil;
    end
	for key, value in pairs(self.effectsCallback) do
        RemoveCallback(self.playerEffects, key, value);
        self.effectsCallback[key] = nil;
    end
	RemoveCallback(Updater, "Tick", self.updateCallback);
	self.resource:Unload();
	self.frame = nil;
	self = nil;
end

ResourceBar = class( Turbine.UI.Control );
function ResourceBar:Constructor(parent, width, height, pipCount, icon)
    Turbine.UI.Control.Constructor( self );
    self:SetParent(parent);
    self:SetSize(width, height);
    self:SetZOrder(100);
    self:SetMouseVisible(false);
    self:SetVisible(true);

    self.pipCount = pipCount;
    self.Pips = {};

    for i = 1, self.pipCount, 1 do
        self.Pips[i] = Pip(self, 20, 20)
        self.Pips[i]:SetPosition((width/2) - ((20/2) * pipCount) + ((i-1)*20), 0);
		self.Pips[i]:SetBackground( icon )
		self.Pips[i]:SetStretchMode(1);
    end
end

function ResourceBar:SetTotal(total)
    for i = 1, self.pipCount, 1 do
        if i <= total then
			self.Pips[i]:SetVisible(true);
        else
            self.Pips[i]:SetVisible(false);
        end
    end
end

function ResourceBar:SetAttunementTotal(total)
    local currentTotal = (total - 10);
	local background = "ExoPlugins/Athelas/Resources/nestad.tga";
	if currentTotal < 0 then
        currentTotal = currentTotal * -1;
		background = "ExoPlugins/Athelas/Resources/dagor.tga";
    end

	for i = 1, self.pipCount, 1 do
        if i <= currentTotal then
            self.Pips[i]:SetBackground(background);
			self.Pips[i]:SetVisible(true);
        else
            self.Pips[i]:SetVisible(false);
        end
    end
end

function ResourceBar:ConfigureGambitInfo(player)
	self.player = player;
	self.gambitIcons = {
		[0] = "ExoPlugins/Athelas/Resources/empty.tga",
		[1] = "ExoPlugins/Athelas/Resources/spear.tga",
		[2] = "ExoPlugins/Athelas/Resources/shield.tga",
		[3] = "ExoPlugins/Athelas/Resources/fist.tga",
	};
	for i = 1, self.pipCount, 1 do
        self.Pips[i] = Pip(self, 25, 25)
        self.Pips[i]:SetPosition((180/2) - ((25/2) * self.pipCount) + ((i-1)*25), -2);
		self.Pips[i]:SetStretchMode(0);
		self.Pips[i]:SetBackground( icon )
		self.Pips[i]:SetStretchMode(1);
    end
	self:AdjustGambitDisplay();
end

function ResourceBar:AdjustGambitDisplay()
	for i = 1, self.pipCount, 1 do
		self.Pips[i]:SetBackground(self.gambitIcons[self.player:GetGambit(i)]);
    end
end

function ResourceBar:Unload()
    for i = 1, self.pipCount, 1 do
        self.Pips[i]:Unload();
    end
    self.Pips = {};
    self:SetParent(nil);
	self = nil;
end

Pip = class( Turbine.UI.Control );
function Pip:Constructor(parent, width, height)
    Turbine.UI.Control.Constructor( self );
    self:SetParent(parent);
    self:SetSize(width, height);
    self:SetZOrder(100);
    self:SetMouseVisible(false);
    self:SetVisible(true);
end

function Pip:Unload()
	self = nil;
end