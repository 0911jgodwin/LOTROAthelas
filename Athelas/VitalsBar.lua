VitalsBar = class( Turbine.UI.Control );
function VitalsBar:Constructor(parent, width, height, inscription)
	Turbine.UI.Control.Constructor( self );
	self:SetSize(width, height);

	--This section uses SetStretchMode to work out the pixel size of the given texture so we can scale accordingly.
    local TextureSize = Turbine.UI.Control();
    TextureSize:SetBackground("ExoPlugins/Athelas/Resources/bartexture.tga");
    TextureSize:SetStretchMode(2);
    local baseWidth, baseHeight = TextureSize:GetSize();
    TextureSize = nil;

	self.textureBar = Turbine.UI.Control();
	self.textureBar:SetParent(self);
	self.textureBar:SetBackground("ExoPlugins/Athelas/Resources/bartexture.tga");
	self.textureBar:SetSize(width, height);
	self.textureBar:SetZOrder(101);
	self.textureBar:SetBlendMode(4);

	self.background = Turbine.UI.Control();
	self.background:SetParent(self);
	self.background:SetBackground("ExoPlugins/Athelas/Resources/vitalsbackground.tga");
	self.background:SetSize(width, height);
	self.background:SetBlendMode(4);

	-- The fill bar is the bar used to represent the current value of the
	-- vital.
	self.currentBar = Turbine.UI.Control();
	self.currentBar:SetParent( self );
	self.currentBar:SetHeight(height);
	self.currentBar:SetBlendMode(4);

	-- The temp bar is an additional bar colored differently used to
	-- represent the additional vital granted due to effects that
	-- increase the max.
	self.tempBar = Turbine.UI.Control();
	self.tempBar:SetParent( self );
	self.tempBar:SetHeight(height);
	self.tempBar:SetBlendMode(4);

	-- The dread bar represents the amount of the vital lost due to
	-- effects that modify the max in a negative way.
	self.dreadBar = Turbine.UI.Control();
	self.dreadBar:SetParent( self );
	self.dreadBar:SetHeight(height);
	self.dreadBar:SetBlendMode(4);

	-- The inscription places a scrolling script texture on top of the bar
	-- this makes it look very fancy.
	if inscription then
		self.inscription = Inscription(self);
		self.inscription:SetPosition(0,0);
		self.inscription:SetZOrder(101);
	end

	-- The animation classes for smoothly moving the bars.
	self.current = LerpValue();
	self.max = LerpValue();
	self.baseMax = LerpValue();
	self.tempValue = LerpValue();

	-- The display text for the vitals bar.
	self.text = Turbine.UI.Label();
	self.text:SetForeColor( Turbine.UI.Color(1,0.91,0.68) );
	self.text:SetOutlineColor( Turbine.UI.Color( 1, 0, 0, 0 ) );
	self.text:SetFontStyle( Turbine.UI.FontStyle.Outline );
	if Settings["General"]["Scale"]/100 <= 0.6 then
		self.text:SetFont( Turbine.UI.Lotro.Font.BookAntiquaBold14 );
	elseif Settings["General"]["Scale"]/100 <= 0.8 then
		self.text:SetFont( Turbine.UI.Lotro.Font.BookAntiquaBold18 );
	else
		self.text:SetFont( Turbine.UI.Lotro.Font.BookAntiquaBold24 );
	end
	self.text:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	self.text:SetParent(self);
	self.text:SetSize(width, height);
	self.text:SetZOrder( 110 );
	self.text:SetStretchMode(1);
	self.text:SetVisible(false);

	self.lastUpdate = 0;
end

function VitalsBar:SetTextVisible(bool)
	self.text:SetVisible(bool);
end

function VitalsBar:SetColors( current, temp, dread )
	self.currentBar:SetBackColor( current );
	self.tempBar:SetBackColor( temp );
	self.dreadBar:SetBackColor( dread );
end

function VitalsBar:SetValue( value )
	self.current:SetValue( value );
	self.current:SetRate( self.max:GetTargetValue() / self:GetWidth() * 180 );

	if ( self.current:NeedsUpdate() ) then
		self:SetWantsUpdates( true );
	end
end

function VitalsBar:SetTempValue( value )
	self.tempValue:SetValue( value );
	self.tempValue:SetRate( self.max:GetTargetValue() / self:GetWidth() * 180 );

	if ( self.tempValue:NeedsUpdate() ) then
		self:SetWantsUpdates( true );
	end
end

function VitalsBar:SetMax( value )
	self.max:SetValueImmediate( value );
	self.current:SetRate( self.max:GetTargetValue() / self:GetWidth() * 720 );

	if ( self.max:NeedsUpdate() ) then
		self:SetWantsUpdates( true );
	end
end

function VitalsBar:SetBaseMax( value )
	self.baseMax:SetValueImmediate( value );

	if ( self.baseMax:NeedsUpdate() ) then
		self:SetWantsUpdates( true );
	end
end

function VitalsBar:SetAllValues(current, max, baseMax, temp)
	self.current:SetValueImmediate( current );
	self.max:SetValueImmediate( max );
	self.baseMax:SetValueImmediate( baseMax );
	self.tempValue:SetValueImmediate( temp );
	self:SetWantsUpdates( true );
end

function VitalsBar:GetValue()
	return self.current:GetValue();
end

function VitalsBar:PrintValues()
	Debug(dump(self.current:GetValue()));
	Debug(dump(self.max:GetValue()));
	Debug(dump(self.baseMax:GetValue()));
	Debug(dump(self.tempValue:GetValue()));
end

function VitalsBar:Update( args )
	local delta = 0;
	local currentTime = Turbine.Engine.GetGameTime();

	if ( self.lastUpdate > 0 ) then
		delta = currentTime - self.lastUpdate;
	end

	self.lastUpdate = currentTime;

	self.current:Update( delta );
	self.max:Update( delta );
	self.baseMax:Update( delta );
	self.tempValue:Update( delta );

	local current = math.floor( self.current:GetValue() + 0.5 ) 
	local max = math.floor( self.max:GetValue() + 0.5 ) 
	local baseMax = math.floor( self.baseMax:GetValue() + 0.5 ) 

	
	self.text:SetStretchMode(0);
	if current > 0 then
		local percentage = math.floor( ( current / max * 100 ) + 0.5 );
		self.text:SetText( FormatNumber(current) .. " - " .. percentage .. "%" );
	else
		self.text:SetText( "" );
	end
	self.text:SetStretchMode(1);

	self:PerformLayout();

	if ( not ( self.current:NeedsUpdate() or self.max:NeedsUpdate() or self.baseMax:NeedsUpdate() or self.tempValue:NeedsUpdate() ) ) then
		self:SetWantsUpdates( false );
		self.lastUpdate = 0;
	end
end

function VitalsBar:PerformLayout()
	local width, height = self:GetSize();

	local current = self.current:GetValue();
	local max     = self.max:GetValue();
	local baseMax = self.baseMax:GetValue();
	local temp    = self.tempValue:GetValue();

	local baseBarWidthPercent = 1;

	-- Calculate the percentage of the bar that is the base vital display
	-- versus the adjusted display portion for buffs and debuffs.
	if ( max < baseMax ) then
		baseBarWidthPercent = max / baseMax;
	elseif ( baseMax < max ) then
		baseBarWidthPercent = baseMax / max;
	end

	local baseBarFillPercent   = 0;
	local dreadBarFillPercent  = 0;

	-- Calculate the amount of fill for the base bar and the buffed bar.
	if ( max < baseMax ) then
		-- Dread case.
		baseBarFillPercent = current / max;
		dreadBarFillPercent = 1;
	elseif ( current <= baseMax ) then
		baseBarFillPercent = current / baseMax;
	else
		baseBarFillPercent = 1;
		dreadBarFillPercent = ( current - baseMax ) / ( max - baseMax );
	end

	-- Determine the actual layout of the bars now.
	local baseBarLeft      = 0;
	local baseBarMaxWidth  = math.floor( width * baseBarWidthPercent );
	local baseBarWidth     = math.floor( baseBarMaxWidth * baseBarFillPercent );
	local dreadBarLeft     = baseBarMaxWidth;
	local dreadBarWidth    = math.floor( ( width - baseBarWidth ) * dreadBarFillPercent );

	self.currentBar:SetPosition( baseBarLeft, 0 );
	self.currentBar:SetSize( baseBarWidth, height );

	self.dreadBar:SetVisible( false );
	self.tempBar:SetVisible( false );

	if ( max < baseMax ) then
		self.dreadBar:SetVisible( true );
		self.dreadBar:SetPosition( dreadBarLeft, 0 );
		self.dreadBar:SetSize( dreadBarWidth, height );
	end
	
	if (temp > 0) then
		local total = current + temp;
		local moraleWidth = (current / total) * baseBarWidth;
		local tempWidth = (temp / total) * baseBarWidth;

		self.tempBar:SetVisible( true );
		self.currentBar:SetSize(moraleWidth, height);
		self.tempBar:SetSize(tempWidth, height);
		self.tempBar:SetPosition(moraleWidth, 0);
	end
end

function VitalsBar:Unload()
	if self.inscription ~= nil then
		self.inscription:Unload();
		self.inscription = nil;
	end
	self.tempBar:SetStretchMode(0);
	self.currentBar:SetStretchMode(0);
	self.tempBar:SetStretchMode(0);
	self.tempBar:SetStretchMode(0);
	self.textureBar:SetStretchMode(0);
	self.background:SetStretchMode(0);
	self.text:SetStretchMode(0);

	self.tempBar = nil;
	self.currentBar = nil;
	self.tempBar = nil;
	self.tempBar = nil;
	self.textureBar = nil;
	self.background = nil;
	self.text = nil;
	self:SetWantsUpdates(false);
end

Inscription = class(Turbine.UI.Window)
function Inscription:Constructor(parent)
    Turbine.UI.Window.Constructor(self);
	self:SetParent(parent);
	self:SetOpacity(0.4);

	local finalWidth, finalHeight = parent:GetSize();
	finalHeight = finalHeight + 10;
    self:SetSize(finalWidth * (76/finalHeight), 76);

	self.texture = "ExoPlugins/Athelas/Resources/inscription.tga";

	self.text = Turbine.UI.Control();
    self.text:SetParent(self);
    self.text:SetSize(1998, 76);
    self.text:SetBackground(self.texture);
    self.text:SetBlendMode(Turbine.UI.BlendMode.Normal);
	self.text:SetPosition(0,0);
    self.text:SetVisible(true);
    self.text:SetMouseVisible(false);

	self:SetStretchMode(1);
    self:SetSize(finalWidth, finalHeight);

	self.currentFrame = 0;
    self.lastTick = Turbine.Engine.GetGameTime();
    self.Update = function()
        if Turbine.Engine.GetGameTime() - self.lastTick < 0.05 then return end
        self.lastTick = Turbine.Engine.GetGameTime();
		local leftPos = self.text:GetLeft();
		if leftPos == -1099 then
			self.text:SetLeft(-101)
		else
        	self.text:SetLeft(leftPos - 1);
		end
    end
	self:SetVisible(true);
	self:SetWantsUpdates(true);
end

function Inscription:Unload()
	self:SetWantsUpdates(false);
	self:SetParent(nil);
	self.text:SetParent(nil);
	self.text:SetBackground(nil);
	self.text = nil;
	self:SetStretchMode(0);
	collectgarbage();
end