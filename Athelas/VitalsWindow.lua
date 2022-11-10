VitalsWindow = class( Turbine.UI.Window );
function VitalsWindow:Constructor()
	Turbine.UI.Window.Constructor( self );	
	local screenWidth, screenHeight = Turbine.UI.Display:GetSize();
	self:SetPosition(Settings["Player"]["Position"][1]*screenWidth, Settings["Player"]["Position"][2]*screenHeight);
	self:SetSize( 395, 130 );
	self.scaleModifier = Settings["General"]["Scale"]/100;

	-- Grab the player for use with callbacks
	self.player = Turbine.Gameplay.LocalPlayer.GetInstance();
	self.playerCallbacks = {};
	self.classCallbacks = {};

	self:ConfigureVisuals();
	self:ConfigureCallbacks();

	self.dragbar = DragBar( self, "Athelas Vitals" );
end

function VitalsWindow:ConfigureVisuals()
	self.E = Turbine.UI.Lotro.EntityControl();
    self.E:SetParent (self);
    self.E:SetVisible (true);
    self.E:SetSize(395*self.scaleModifier, 108*self.scaleModifier);
    self.E:SetEntity(self.player);
	self.E:SetZOrder(102);

	-- Frame Image
	self.frame = Turbine.UI.Control();
	self.frame:SetBackground( "ExoPlugins/Athelas/Resources/vitalsframe.tga" );
	self.frame:SetBackColorBlendMode( Turbine.UI.BlendMode.Multiply );
	self.frame:SetSize(395, 108);
	self.frame:SetParent( self );
	self.frame:SetVisible(true);
	self.frame:SetMouseVisible(false);
	self.frame:SetBlendMode(4);
	self.frame:SetZOrder(101);
	self.frame:SetPosition(0,24);
	self.frame:SetStretchMode(1);
	self.frame:SetSize(math.floor(395*self.scaleModifier), math.floor(108*self.scaleModifier))

	local class = GetClass(self.player);
	self.classIcon = Turbine.UI.Control();
	self.classIcon:SetBackground( "ExoPlugins/Athelas/Resources/" .. class .. ".tga" );
	self.classIcon:SetBackColorBlendMode( Turbine.UI.BlendMode.Multiply );
	self.classIcon:SetBlendMode(4);
	self.classIcon:SetSize(108, 108);
	self.classIcon:SetParent( self );
	self.classIcon:SetVisible(true);
	self.classIcon:SetMouseVisible(false);
	self.classIcon:SetZOrder(100);
	self.classIcon:SetPosition(0,24);
	self.classIcon:SetStretchMode(1);
	self.classIcon:SetSize(math.floor(108*self.scaleModifier), math.floor(108*self.scaleModifier))

	--Class resource container
	if Settings["Player"]["Resource"]["Enabled"] then
		if class == "Brawler" or class == "Hunter" or class == "Champion" or class == "Runekeeper" or class == "Warden" then
			self.class = ClassHolder();
			self.class:SetParent(self);
			self.class:SetPosition(math.ceil(67*self.scaleModifier), math.ceil(33*self.scaleModifier)+((1-self.scaleModifier)*10*2));
		end
	end

	-- Construct the morale bar.
	self.moraleBar = VitalsBar(self, math.ceil(238*self.scaleModifier), math.ceil(30*self.scaleModifier), true);
	self.moraleBar:SetParent( self );
	self.moraleBar:SetZOrder( 100 );
	if Settings["Player"]["Vitals"]["Morale Display"] == "Default" then
		self.moraleBar:SetColors( Turbine.UI.Color( 1, 0.1, 1, 0.1 ), Turbine.UI.Color(0.86,0.3,1), Turbine.UI.Color( 1, 1.0, 0.4, 0 ) );
	elseif Settings["Player"]["Vitals"]["Morale Display"] == "Custom" then
		self.moraleBar:SetColors( TableToColor(Settings["Player"]["Vitals"]["Custom Morale Colour"]), Turbine.UI.Color(0.86,0.3,1), Turbine.UI.Color( 1, 1.0, 0.4, 0 ) );
	else
		self.moraleBar:SetColors( GetClassColour(class), Turbine.UI.Color(0.86,0.3,1), Turbine.UI.Color( 1, 1.0, 0.4, 0 ) );
	end
	self.moraleBar:SetPosition( 86, 47 );
	self.moraleBar:SetPosition( math.ceil(107*self.scaleModifier), math.ceil(52*self.scaleModifier)+((1-self.scaleModifier)*10*2.7) );
	self.moraleBar:SetMouseVisible( false );
	self.moraleBar:SetStretchMode(1);
	
	-- Construct the power bar.
	self.powerBar = VitalsBar(self, 216*self.scaleModifier, 15*self.scaleModifier);
	self.powerBar:SetParent( self );
	self.powerBar:SetZOrder( 100 );
	if Settings["Player"]["Vitals"]["Power Display"] == "Custom" then
		self.powerBar:SetColors( TableToColor(Settings["Player"]["Vitals"]["Custom Power Colour"]), Turbine.UI.Color(0.86,0.3,1), Turbine.UI.Color( 1, 1.0, 0.4, 0 ));
	elseif class == "Beorning" then
		self.powerBar:SetColors( Turbine.UI.Color( 1, 1.0, 0.4, 0 ), Turbine.UI.Color(0.86,0.3,1), Turbine.UI.Color( 1, 1.0, 0.4, 0 ));
	else
		self.powerBar:SetColors( Turbine.UI.Color( 1, 0.1, 0.5, 1 ), Turbine.UI.Color(0.86,0.3,1), Turbine.UI.Color( 1, 1.0, 0.4, 0 ));
	end
	self.powerBar:SetPosition( math.ceil(103*self.scaleModifier), math.ceil(92*self.scaleModifier)+((1-self.scaleModifier)*10*2.5) );
	self.powerBar:SetMouseVisible( false );
	self.powerBar:SetStretchMode(1);


	-- Construct the effects lists
	self.buffsEffectsList = Turbine.UI.ListBox();
	self.buffsEffectsList:SetParent( self );
	self.buffsEffectsList:SetPosition( math.ceil(100*self.scaleModifier), math.ceil(120*self.scaleModifier)+((1-self.scaleModifier)*10*2) );
	self.buffsEffectsList:SetSize( 240, 80 );
	self.buffsEffectsList:SetOrientation( Turbine.UI.Orientation.Horizontal );
	self.buffsEffectsList:SetMaxItemsPerLine( 10 );
	self.buffsEffectsList:SetMouseVisible( false );
	self.buffsEffectsList:SetZOrder(103);

	self.debuffsEffectsList = Turbine.UI.ListBox();
	self.debuffsEffectsList:SetParent( self );
	self.debuffsEffectsList:SetPosition( math.ceil(100*self.scaleModifier), math.ceil(120*self.scaleModifier)+((1-self.scaleModifier)*10*17) );
	self.debuffsEffectsList:SetSize( 240, 80 );
	self.debuffsEffectsList:SetOrientation( Turbine.UI.Orientation.Horizontal );
	self.debuffsEffectsList:SetMaxItemsPerLine( 10 );
	self.debuffsEffectsList:SetMouseVisible( false );
	self.debuffsEffectsList:SetZOrder(103);

	local effects = self.player:GetEffects();

	local i;
	for i = 1, effects:GetCount() do
		self:AddEffect( i );
	end
end

function VitalsWindow:ConfigureCallbacks()
	-- Set callbacks
    self.playerCallbacks["MoraleChanged"] = AddCallback(self.player, "MoraleChanged", function(sender, args) self:UpdateMorale() end);
    self.playerCallbacks["MaxMoraleChanged"] = AddCallback(self.player, "MaxMoraleChanged", function(sender, args) self:UpdateMorale() end);
    self.playerCallbacks["BaseMaxMoraleChanged"] = AddCallback(self.player, "BaseMaxMoraleChanged", function(sender, args) self:UpdateMorale() end);
    self.playerCallbacks["TemporaryMoraleChanged"] = AddCallback(self.player, "TemporaryMoraleChanged", function(sender, args) self:UpdateMorale() end);

	self:UpdateMorale();
	local class = GetClass(self.player);
	if class == "Beorning" then
		self:UpdateWrath();
		self.classCallbacks["WrathChanged"] = AddCallback(self.player:GetClassAttributes(), "WrathChanged", function(sender, args) self:UpdateWrath() end);
	else
		self.playerCallbacks["PowerChanged"] = AddCallback(self.player, "PowerChanged", function(sender, args) self:UpdatePower() end);
    	self.playerCallbacks["MaxPowerChanged"] = AddCallback(self.player, "MaxPowerChanged", function(sender, args) self:UpdatePower() end);
    	self.playerCallbacks["BaseMaxPowerChanged"] = AddCallback(self.player, "BaseMaxPowerChanged", function(sender, args) self:UpdatePower() end);
		self:UpdatePower();
	end

	--Configure morale text display
	self.CombatCallback = nil;
	if Settings["Player"]["Text"]["Display"] == "On Mouseover" then
		self.E.MouseEnter = function(sender, args)
			self.moraleBar:SetTextVisible(true);
		end

		self.E.MouseLeave = function(sender, args)
			self.moraleBar:SetTextVisible(false);
		end
	elseif Settings["Player"]["Text"]["Display"] == "In Combat" then
		self.CombatCallback = AddCallback(self.player, "InCombatChanged", function(sender, args)
			self.moraleBar:SetTextVisible(self.player:IsInCombat());
		end);
	elseif Settings["Player"]["Text"]["Display"] == "Always" then
		self.moraleBar:SetTextVisible(true);
	end

	self.EffectsCallbacks = {};
	self.EffectsCallbacks["EffectAdded"] = AddCallback(self.player:GetEffects(), "EffectAdded", function(sender, args) self:AddEffect(args.Index) end);
	self.EffectsCallbacks["EffectRemoved"] = AddCallback(self.player:GetEffects(), "EffectRemoved", function(sender, args) self:RemoveEffect(args.Effect) end);
end

function VitalsWindow:UpdateMorale()
	local morale        = self.player:GetMorale();
	local maxMorale     = self.player:GetMaxMorale();
	local baseMaxMorale = self.player:GetBaseMaxMorale();
	local tempMorale    = self.player:GetTemporaryMorale();

	self.moraleBar:SetValue( morale );
	self.moraleBar:SetMax( maxMorale );
	self.moraleBar:SetBaseMax( baseMaxMorale );
	self.moraleBar:SetTempValue( tempMorale );
end

function VitalsWindow:UpdatePower()
	local power = self.player:GetPower()
	self.powerBar:SetValue( power );

	local maxPower = self.player:GetMaxPower()
	self.powerBar:SetMax( maxPower );

	local baseMaxPower = self.player:GetBaseMaxPower()
	self.powerBar:SetBaseMax( baseMaxPower );
end

function VitalsWindow:UpdateWrath()
	local wrath = self.player:GetClassAttributes():GetWrath();
	self.powerBar:SetValue( wrath );

	self.powerBar:SetMax( 100 );
	self.powerBar:SetBaseMax( 100 );
end

function VitalsWindow:AddEffect( effectIndex )
	local effect = self.player:GetEffects():Get( effectIndex );

	--local effectDisplay = Turbine.UI.Lotro.EffectDisplay()
	local effectDisplay = EffectDisplay()
	effectDisplay:SetEffect( effect );
	--effectDisplay:SetSize( 22, 22 );

	local insertionList = nil;
	local effectEndTime = effect:GetStartTime() + effect:GetDuration();

	if ( effectDisplay:GetEffect():IsDebuff() ) then
		insertionList = self.debuffsEffectsList;
	else
		insertionList = self.buffsEffectsList;
	end

	local i = 0;
	local insertAt = -1;

	for i = 1, insertionList:GetItemCount() do
		local testEffect = insertionList:GetItem( i ):GetEffect();
		local testEffectEndTime = testEffect:GetStartTime() + testEffect:GetDuration();

		if ( effectEndTime > testEffectEndTime ) then
			insertAt = i;
			break;
		end
	end

	if ( insertAt == -1 ) then
		insertionList:AddItem( effectDisplay );
	else
		insertionList:InsertItem( insertAt, effectDisplay );
	end

	self:UpdateEffectsLayout();
end

function VitalsWindow:RemoveEffect( effect )
	local i;

	if ( effect:IsDebuff() ) then
		for i = 1, self.debuffsEffectsList:GetItemCount() do
			local effectListItem = self.debuffsEffectsList:GetItem( i ):GetEffect();
			
			if ( effect == effectListItem ) then
				local effectElement = self.debuffsEffectsList:GetItem( i );
				effectElement:SetVisible( false );
				self.debuffsEffectsList:RemoveItemAt( i );
				break;
			end
		end
	else
		for i = 1, self.buffsEffectsList:GetItemCount() do
			local effectListItem = self.buffsEffectsList:GetItem( i ):GetEffect();
			
			if ( effect == effectListItem ) then
				local effectElement = self.buffsEffectsList:GetItem( i );
				effectElement:SetVisible( false );
				self.buffsEffectsList:RemoveItemAt( i );
				break;
			end
		end
	end
	
	self:UpdateEffectsLayout();
end

function VitalsWindow:UpdateEffectsLayout()
	local debuffsCount = self.debuffsEffectsList:GetItemCount();
	local rows = math.ceil( debuffsCount / self.debuffsEffectsList:GetMaxItemsPerLine() );
	local debuffsHeight = ( rows * 25 );
	local buffsTop = ( self.debuffsEffectsList:GetTop() ) + debuffsHeight;
	self.debuffsEffectsList:SetSize( self.debuffsEffectsList:GetWidth(), debuffsHeight );
	self.buffsEffectsList:SetPosition( math.ceil(100*self.scaleModifier), math.ceil(buffsTop*self.scaleModifier) );
end

function VitalsWindow:RemoveCallbacks()
	for key, value in pairs(self.playerCallbacks) do
        RemoveCallback(self.player, key, value);
        self.playerCallbacks[key] = nil;
    end
	if GetClass(self.player) == "Beorning" then
		RemoveCallback(self.player:GetClassAttributes(), "WrathChanged", self.classCallbacks["WrathChanged"]);
	end

	if self.CombatCallback ~= nil then
		RemoveCallback(self.player, "InCombatChanged", self.CombatCallback);
	end

	self.playerCallbacks = {};
	self.classCallbacks = {};
	self.CombatCallback = nil;
end

function VitalsWindow:SavePosition()
	local screenWidth, screenHeight = Turbine.UI.Display:GetSize();
	Data = {
		[1] = self:GetLeft()/screenWidth,
		[2] = self:GetTop()/screenHeight,
	};
	Settings["Player"]["Position"] = Data;
end

function VitalsWindow:Unload()
	self:RemoveCallbacks();
	self.moraleBar:Unload();
	self.powerBar:Unload();
	self.moraleBar = nil;
	self.powerBar = nil;
	if self.class ~= nil then
		self.class:Unload();
	end
    self.E:SetEntity(nil);
	self.E = nil;
	self.frame:SetStretchMode(0);
	self.frame = nil;
	self.classIcon:SetStretchMode(0);
	self.classIcon = nil;
	self:SetStretchMode(0);
end

function VitalsWindow:Reload()
	self:Unload();
	self:ConfigureVisuals();
	self:ConfigureCallbacks();
end