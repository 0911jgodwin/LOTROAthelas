TargetVitalsWindow = class( Turbine.UI.Window );
function TargetVitalsWindow:Constructor()
	Turbine.UI.Window.Constructor( self );	
	local screenWidth, screenHeight = Turbine.UI.Display:GetSize();
	self.scaleModifier = Settings["General"]["Scale"]/100;
	self:SetPosition(Settings["Target"]["Position"][1]*screenWidth, Settings["Target"]["Position"][2]*screenHeight);
	self:SetSize( 572*self.scaleModifier, 50*self.scaleModifier );

	-- Grab the player for use with callbacks
	self.player = Turbine.Gameplay.LocalPlayer.GetInstance();
    self.targetCallbacks = {};
    self.playerCallbacks = {};

    self:ConfigureVisuals();
    self:ConfigureCallbacks();

    self.dragbar = DragBar( self, "Athelas Target Vitals" );
end

function TargetVitalsWindow:ConfigureVisuals()
    self.E = Turbine.UI.Lotro.EntityControl();
    self.E:SetParent (self);
    self.E:SetVisible (true);
    self.E:SetSize(self:GetWidth(), self:GetHeight());
    self.E:SetEntity(self.player);
	self.E:SetZOrder(102);

	-- Frame Image
	self.frame = Turbine.UI.Control();
	self.frame:SetBackground( "ExoPlugins/Athelas/Resources/targetFrame.tga" );
	self.frame:SetBackColorBlendMode( Turbine.UI.BlendMode.Multiply );
	self.frame:SetSize(572, 50);
	self.frame:SetParent( self );
	self.frame:SetVisible(true);
	self.frame:SetMouseVisible(false);
	self.frame:SetBlendMode(4);
	self.frame:SetZOrder(101);
	self.frame:SetStretchMode(1);
	self.frame:SetSize(math.floor(572*self.scaleModifier), math.floor(50*self.scaleModifier))

    -- Construct the morale bar.
	self.moraleBar = VitalsBar(self, 472*self.scaleModifier, 30*self.scaleModifier, true);
	self.moraleBar:SetParent( self );
	self.moraleBar:SetZOrder( 100 );
    if Settings["Target"]["Vitals"]["Morale Display"] == "Default" then
	    self.moraleBar:SetColors( Turbine.UI.Color(0.9,0.1,0.1), Turbine.UI.Color(0.86,0.3,1), Turbine.UI.Color( 1, 1.0, 0.4, 0 ) );
    else
        self.moraleBar:SetColors( TableToColor(Settings["Target"]["Vitals"]["Custom Morale Colour"]), Turbine.UI.Color(0.86,0.3,1), Turbine.UI.Color( 1, 1.0, 0.4, 0 ) );
    end
	self.moraleBar:SetPosition( math.ceil(50*self.scaleModifier), (11*self.scaleModifier) );
	self.moraleBar:SetMouseVisible( false );

	--Configure morale text display
	self.CombatCallback = nil;
	if Settings["Target"]["Text"]["Display"] == "On Mouseover" then
		self.E.MouseEnter = function(sender, args)
			self.moraleBar:SetTextVisible(true);
		end

		self.E.MouseLeave = function(sender, args)
			self.moraleBar:SetTextVisible(false);
		end
	elseif Settings["Target"]["Text"]["Display"] == "In Combat" then
		self.CombatCallback = AddCallback(self.player, "InCombatChanged", function(sender, args)
			self.moraleBar:SetTextVisible(self.player:IsInCombat());
		end);
	elseif Settings["Target"]["Text"]["Display"] == "Always" then
		self.moraleBar:SetTextVisible(true);
	end

    -- The display text for the vitals bar.
	self.text = Turbine.UI.Label();
	self.text:SetForeColor( Turbine.UI.Color(1,0.84,0.46) );
	self.text:SetOutlineColor( Turbine.UI.Color( 1, 0, 0, 0 ) );
	self.text:SetFontStyle( Turbine.UI.FontStyle.Outline );
	self.text:SetFont( Turbine.UI.Lotro.Font.BookAntiquaBold24 );
	self.text:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	self.text:SetParent(self)
	self.text:SetSize(self:GetSize());
    self.text:SetPosition(0, -24 - (self.scaleModifier*6))
	self.text:SetZOrder( 110 );
	self.text:SetStretchMode(1);
end

function TargetVitalsWindow:ConfigureCallbacks()
    self.playerCallbacks["TargetChanged"] = AddCallback(self.player, "TargetChanged", function(sender, args)
        self:Setup();
    end);

    self:Setup();
end

function TargetVitalsWindow:SetTargetCallbacks()
    self.targetCallbacks["MoraleChanged"] = AddCallback(self.target, "MoraleChanged", function(sender, args) self:UpdateMorale() end);
    self.targetCallbacks["MaxMoraleChanged"] = AddCallback(self.target, "MaxMoraleChanged", function(sender, args) self:SetMorale() end);
    self.targetCallbacks["TemporaryMoraleChanged"] = AddCallback(self.target, "TemporaryMoraleChanged", function(sender, args) self:UpdateMorale() end);
end

function TargetVitalsWindow:RemoveTargetCallbacks()
    for key, value in pairs(self.targetCallbacks) do
        RemoveCallback(self.target, key, value);
    end
    collectgarbage();
end

function TargetVitalsWindow:RemoveCallbacks()
    self:RemoveTargetCallbacks();
    for key, value in pairs(self.playerCallbacks) do
        RemoveCallback(self.player, key, value);
        self.playerCallbacks[key] = nil;
    end
	if self.CombatCallback ~= nil then
		RemoveCallback(self.player, "InCombatChanged", self.CombatCallback);
	end
end

function TargetVitalsWindow:UpdateMorale()
    -- When a target dies we still get callbacks, check for this and remove
    if not self.target then self:RemoveTargetCallbacks() return end;
    
    local morale        = self.target:GetMorale();
	local maxMorale     = self.target:GetMaxMorale();
	local tempMorale    = self.target:GetTemporaryMorale();

	self.moraleBar:SetValue( morale );
    self.moraleBar:SetBaseMax( maxMorale );
	self.moraleBar:SetMax( maxMorale );
	self.moraleBar:SetTempValue( tempMorale );
end

function TargetVitalsWindow:SetMorale()
    local morale        = self.target:GetMorale();
	local maxMorale     = self.target:GetMaxMorale();
	local tempMorale    = self.target:GetTemporaryMorale();

	self.moraleBar:SetAllValues( morale, maxMorale, maxMorale, tempMorale );
end

function TargetVitalsWindow:Setup()
    if self.target then
        self:RemoveTargetCallbacks();
        self.target = nil;
        self.E:SetEntity(nil);
    end

    self.target = self.player:GetTarget();

    if self.target ~= nil then
        self:SetVisible(true);

        self.text:SetStretchMode(0);
        self.text:SetText(self.target:GetName());
        self.text:SetStretchMode(1);
        self.E:SetEntity(self.target);

        if self.target.GetLevel ~= nil then
            self:SetTargetCallbacks();
            local morale        = self.target:GetMorale();
            local maxMorale     = self.target:GetMaxMorale();
            local tempMorale    = self.target:GetTemporaryMorale();
            self.moraleBar:SetAllValues(morale, maxMorale, maxMorale, tempMorale);
        else
            self.moraleBar:SetAllValues(0,0,0,0);
        end
    else
        self:SetVisible(false);
    end
end

function TargetVitalsWindow:SavePosition()
	local screenWidth, screenHeight = Turbine.UI.Display:GetSize();
	Data = {
		[1] = self:GetLeft()/screenWidth,
		[2] = self:GetTop()/screenHeight,
	};
	Settings["Target"]["Position"] = Data;
end

function TargetVitalsWindow:Unload()
    self:RemoveCallbacks();
	self.moraleBar:Unload();
	self.moraleBar = nil;
    self.E:SetEntity(nil);
	self.E = nil;
	self.frame:SetStretchMode(0);
	self.frame = nil;
	self:SetStretchMode(0);
end

function TargetVitalsWindow:Reload()
    self:Unload();
    self:ConfigureVisuals();
    self:ConfigureCallbacks();
end

function TargetVitalsWindow:SetInactive()
    self:RemoveCallbacks();
    self:SetVisible(false);
end