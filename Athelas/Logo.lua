Logo = class( Turbine.UI.Window );
function Logo:Constructor()
	Turbine.UI.Window.Constructor( self );	
	local screenWidth, screenHeight = Turbine.UI.Display:GetSize();
	self:SetPosition(Settings["Logo"]["Position"][1]*screenWidth, Settings["Logo"]["Position"][2]*screenHeight);
	self:SetVisible(true);

	self:SetSize(64, 64);
	self:SetBackground("ExoPlugins/Athelas/Resources/UI/athelasButton.tga");
	self:SetStretchMode(1);
	self:SetSize(48,48);

	self.dragbar = DragBar( self, "Athelas Logo" );
end

function Logo:SavePosition()
	local screenWidth, screenHeight = Turbine.UI.Display:GetSize();
	Data = {
		[1] = self:GetLeft()/screenWidth,
		[2] = self:GetTop()/screenHeight,
	};
	Settings["Logo"]["Position"] = Data;
end

function Logo:MouseEnter(sender, args)
	self:SetStretchMode(0);
	self:SetSize(64, 64);
	self:SetBackground("ExoPlugins/Athelas/Resources/UI/athelasButtonHighlight.tga");
	self:SetStretchMode(1);
	self:SetSize(48,48);
end

function Logo:MouseLeave(sender, args)
	self:SetStretchMode(0);
	self:SetSize(64, 64);
	self:SetBackground("ExoPlugins/Athelas/Resources/UI/athelasButton.tga");
	self:SetStretchMode(1);
	self:SetSize(48,48);
end

function Logo:MouseClick(sender, args)
	if MenuPanel == nil then
		local screenWidth, screenHeight = Turbine.UI.Display:GetSize();
		MenuPanel = Options.Menu((screenWidth/2)-200,(screenHeight/2)-200);
	else
		MenuPanel:ToggleVisible();
	end
end