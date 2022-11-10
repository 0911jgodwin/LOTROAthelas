Menu = class(Turbine.UI.Window)
function Menu:Constructor( x, y )
	Turbine.UI.Window.Constructor( self );

	self:SetSize(450, 600);

	self:SetPosition(x,y);
	self:SetVisible(true);
	self.dragging = false;

	self.screenWidth, self.screenHeight = Turbine.UI.Display:GetSize();
	self.screenWidth = self.screenWidth - self:GetWidth();
	self.screenHeight = self.screenHeight - self:GetHeight();

	self:CreateWindow(450, 600);

	self:CreateContent();
	self:SetData();
end

function Menu:ToggleVisible()
	self:SetVisible(not self:IsVisible());
end

function Menu:CreateWindow(width, height)
	self.title = Turbine.UI.Control();
	self.title:SetParent(self);
	self.title:SetBackground("ExoPlugins/Athelas/Resources/UI/Title.tga");
	self.title:SetSize(116,32);
	self.title:SetStretchMode(1);
	self.title:SetPosition((width/2)-58,0);
	self.title:SetZOrder(101);

	self.title.MouseDown = function(sender, args)
		self.startX = args.X;
		self.startY = args.Y;
		self.dragging = true;
	end

	self.title.MouseUp = function(sender, args)
		self.dragging = false;
	end

	self.title.MouseMove = function(sender, args)
		if self.dragging then
			local left, top = self:GetPosition();
			local x = left + (args.X - self.startX);
			local y = top + (args.Y - self.startY);
			self:SetPosition(Clamp(x, 0, self.screenWidth), Clamp(y, 0, self.screenHeight));
		end
	end

	-- The display text for the title.
	self.titleText = Turbine.UI.Label();
	self.titleText:SetForeColor( Turbine.UI.Color(1,0.84,0.46) );
	self.titleText:SetOutlineColor( Turbine.UI.Color( 1, 0, 0, 0 ) );
	self.titleText:SetFontStyle( Turbine.UI.FontStyle.Outline );
	self.titleText:SetFont( Turbine.UI.Lotro.Font.BookAntiquaBold22 );
	self.titleText:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	self.titleText:SetParent(self.title)
	self.titleText:SetSize(76, 19);
    self.titleText:SetPosition(20, 5)
	self.titleText:SetZOrder( 110 );
	self.titleText:SetStretchMode(1);
	self.titleText:SetMouseVisible(false);
	self.titleText:SetText("Athelas");

	self.exit = Turbine.UI.Control();
	self.exit:SetParent(self);
	self.exit:SetBackground("ExoPlugins/Athelas/Resources/UI/xButton.tga");
	self.exit:SetSize(64,64);
	self.exit:SetStretchMode(1);
	self.exit:SetSize(32,32);
	self.exit:SetPosition(width-36,1);
	self.exit:SetZOrder(101);

	self.exit.MouseEnter = function(sender, args)
		self.exit:SetBackground("ExoPlugins/Athelas/Resources/UI/xButtonHover.tga");
	end

	self.exit.MouseLeave = function(sender, args)
		self.exit:SetBackground("ExoPlugins/Athelas/Resources/UI/xButton.tga");
	end

	self.exit.MouseClick = function(sender, args)
		self:ToggleVisible();
	end

	local frameOffset = 13;
	local frameHeight = height-frameOffset;
	local frameWidth = width;


	self.border1 = Turbine.UI.Control();
    self.border1:SetParent( self );
	self.border1:SetBackground("ExoPlugins/Athelas/Resources/UI/Border1.tga")
	self.border1:SetSize(16,16);
	self.border1:SetStretchMode(1);
	self.border1:SetSize(8,8);
	self.border1:SetPosition(0,frameOffset);

	self.border2 = Turbine.UI.Control();
    self.border2:SetParent( self );
	self.border2:SetBackground("ExoPlugins/Athelas/Resources/UI/Border2.tga")
	self.border2:SetSize(frameWidth,16);
	self.border2:SetStretchMode(1);
	self.border2:SetSize(frameWidth-16,8);
	self.border2:SetPosition(8,frameOffset);

	self.border3 = Turbine.UI.Control();
    self.border3:SetParent( self );
	self.border3:SetBackground("ExoPlugins/Athelas/Resources/UI/Border3.tga")
	self.border3:SetSize(16,16);
	self.border3:SetStretchMode(1);
	self.border3:SetSize(8,8);
	self.border3:SetPosition(frameWidth-8,frameOffset);

	self.border4 = Turbine.UI.Control();
    self.border4:SetParent( self );
	self.border4:SetBackground("ExoPlugins/Athelas/Resources/UI/Border4.tga")
	self.border4:SetSize(16,frameHeight);
	self.border4:SetStretchMode(1);
	self.border4:SetSize(8,frameHeight-16);
	self.border4:SetPosition(frameWidth-8,frameOffset+8);

	self.border5 = Turbine.UI.Control();
    self.border5:SetParent( self );
	self.border5:SetBackground("ExoPlugins/Athelas/Resources/UI/Border5.tga")
	self.border5:SetSize(16,16);
	self.border5:SetStretchMode(1);
	self.border5:SetSize(8,8);
	self.border5:SetPosition(frameWidth-8,height-8);

	self.border6 = Turbine.UI.Control();
    self.border6:SetParent( self );
	self.border6:SetBackground("ExoPlugins/Athelas/Resources/UI/Border6.tga")
	self.border6:SetSize(frameWidth,16);
	self.border6:SetStretchMode(1);
	self.border6:SetSize(frameWidth-16,8);
	self.border6:SetPosition(8,height-8);

	self.border7 = Turbine.UI.Control();
    self.border7:SetParent( self );
	self.border7:SetBackground("ExoPlugins/Athelas/Resources/UI/Border7.tga")
	self.border7:SetSize(16,16);
	self.border7:SetStretchMode(1);
	self.border7:SetSize(8,8);
	self.border7:SetPosition(0,height-8);

	self.border8 = Turbine.UI.Control();
    self.border8:SetParent( self );
	self.border8:SetBackground("ExoPlugins/Athelas/Resources/UI/Border8.tga")
	self.border8:SetSize(16,frameHeight);
	self.border8:SetStretchMode(1);
	self.border8:SetSize(8,frameHeight-16);
	self.border8:SetPosition(0,frameOffset+8);

	self.content = Turbine.UI.Control();
	self.content:SetParent(self);
	self.content:SetBackColor(Turbine.UI.Color( 0.9, 0, 0, 0 ));
	self.content:SetSize(frameWidth-16, frameHeight-16);
	self.content:SetPosition(8,frameOffset+8);
end

function Menu:CreateContent()
	local contentHeight = 455;

	local settingsBorder = Border();
	settingsBorder:SetParent(self.content);
	settingsBorder:SetSize(416, 470);
	settingsBorder:SetPosition(10,10);

	local buttonsBorder = Border();
	buttonsBorder:SetParent(self.content);
	buttonsBorder:SetSize(416, 72);
	buttonsBorder:SetPosition(10,490);

	self.settings = Turbine.UI.TreeView();
	self.settings:SetParent(self.content);
	self.settings:SetSize(398, contentHeight);
	self.settings:SetPosition(15, 18);
	self.settings:SetIndentationWidth( 0 );

	self.settingsScrollBar = ScrollBar();
	self.settingsScrollBar:SetOrientation( Turbine.UI.Orientation.Vertical );
	self.settingsScrollBar:SetParent( self.content );
	self.settingsScrollBar:SetPosition( 412, 18 );
	self.settingsScrollBar:SetSize( 10, contentHeight );

	self.settings:SetVerticalScrollBar( self.settingsScrollBar );

	self.generalNode = HeaderNode("General");
	self.generalSettings = SettingsNode();
	self.generalNode:GetChildNodes():Add(self.generalSettings);

	local subheading = Subheading("Size");
	self.generalSettings:AddContent(subheading);

	self.scale = Slider();
	self.scale:SetAlignment("vertical");
	self.scale:SetKey("UI Scale (%)");
	self.scale:SetRange(50,100);
	self.scale:SetSize(366,50);

	self.generalSettings:AddContent(self.scale);

	self.playerNode = HeaderNode("Player");
	self.playerSettings = SettingsNode();
	self.playerNode:GetChildNodes():Add(self.playerSettings);

	local subheading = Subheading("Vitals");
	self.playerSettings:AddContent(subheading);

	self.playerMoraleColour = ExpandingDropDownSetting("Morale Colour:");
	local list = {"Default","Class Colour","Custom"};
	self.playerMoraleColour:AddList(list);

	self.customPlayerMoraleColour = ColourSetting();
	self.playerMoraleColour:AddContent("Custom", self.customPlayerMoraleColour);

	self.playerSettings:AddContent(self.playerMoraleColour);

	self.playerPowerColour = ExpandingDropDownSetting("Power Colour:");
	local list = {"Default","Custom"};
	self.playerPowerColour:AddList(list);

	self.customPlayerPowerColour = ColourSetting();
	self.playerPowerColour:AddContent("Custom", self.customPlayerPowerColour);

	self.playerSettings:AddContent(self.playerPowerColour);

	local subheading = Subheading("Text");
	self.playerSettings:AddContent(subheading);

	self.playerTextDisplay = ExpandingDropDownSetting("Show Text:");
	local list = {"Always","In Combat", "On Mouseover"};
	self.playerTextDisplay:AddList(list);

	self.playerSettings:AddContent(self.playerTextDisplay);

	local subheading = Subheading("Resources");
	self.playerSettings:AddContent(subheading);

	self.resourceEnabled = ExpandingCheckBoxSetting("Enabled:");

	self.resourceTimeout = Slider();
	self.resourceTimeout:SetAlignment("vertical");
	self.resourceTimeout:SetKey("Timeout Period");
	self.resourceTimeout:SetSize(366,50);
	self.resourceTimeout:SetRange(0,20);

	self.resourceEnabled:AddContent(self.resourceTimeout);

	self.playerSettings:AddContent(self.resourceEnabled);


	self.targetNode = HeaderNode("Target");
	self.targetSettings = SettingsNode();
	self.targetNode:GetChildNodes():Add(self.targetSettings);

	self.targetEnabled = ExpandingCheckBoxSetting("Enabled:");

	local subheading = Subheading("Vitals");
	self.targetEnabled:AddContent(subheading);

	self.targetMoraleColour = ExpandingDropDownSetting("Morale Colour:");
	local list = {"Default","Custom"};
	self.targetMoraleColour:AddList(list);

	self.customTargetMoraleColour = ColourSetting();
	self.targetMoraleColour:AddContent("Custom", self.customTargetMoraleColour);

	self.targetEnabled:AddContent(self.targetMoraleColour);

	local subheading = Subheading("Text");
	self.targetEnabled:AddContent(subheading);

	self.targetTextDisplay = ExpandingDropDownSetting("Show Text:");
	local list = {"Always","In Combat", "On Mouseover"};
	self.targetTextDisplay:AddList(list);

	self.targetEnabled:AddContent(self.targetTextDisplay);

	self.targetSettings:AddContent(self.targetEnabled);

	self.settings:GetNodes():Add(self.generalNode);
	self.settings:GetNodes():Add(self.playerNode);
	self.settings:GetNodes():Add(self.targetNode);
	self.settings:ExpandAll();

	self.revertButton = Button("Revert Changes", 150);
	self.revertButton:SetParent(self.content);
	self.revertButton:SetPosition(51, 515);

	self.revertButton.MouseClick = function(sender, args)
		self:SetData();
	end

	self.saveButton = Button("Save Changes", 150);
	self.saveButton:SetParent(self.content);
	self.saveButton:SetPosition(237, 515);

	self.saveButton.MouseClick = function(sender, args)
		_G.Settings = self:GetData();
		ReloadPlugin();
	end
end

function Menu:GetData()
	local data = {
		["General"] = {
			["Scale"] = self.scale:GetValue(),
		},
		["Player"] = {
			["Position"] = Settings["Player"]["Position"];
			["Vitals"] = {
				["Morale Display"] = self.playerMoraleColour:GetSelected(),
				["Custom Morale Colour"] = ColorToTable(self.customPlayerMoraleColour:GetColor()),
				["Power Display"] = self.playerPowerColour:GetSelected(),
				["Custom Power Colour"] = ColorToTable(self.customPlayerPowerColour:GetColor()),
			},
			["Text"] = {
				["Display"] = self.playerTextDisplay:GetSelected(),
			},
			["Resource"] = {
				["Enabled"] = self.resourceEnabled:GetData(),
				["Timeout"] = self.resourceTimeout:GetValue(),
				["Pip Type"] = "Fancy",
			},
		},
		["Target"] = {
			["Enabled"] = self.targetEnabled:GetData(),
			["Position"] = Settings["Target"]["Position"];
			["Vitals"] = {
				["Morale Display"] = self.targetMoraleColour:GetSelected(),
				["Custom Morale Colour"] = ColorToTable(self.customTargetMoraleColour:GetColor()),
			},
			["Text"] = {
				["Display"] = self.targetTextDisplay:GetSelected(),
			},
		},
		["Logo"] = Settings["Logo"];
	};
	return data;
end

function Menu:SetData()
	self.scale:SetValue(Settings["General"]["Scale"]);

	self.playerMoraleColour:SetSelected(Settings["Player"]["Vitals"]["Morale Display"]);
	self.customPlayerMoraleColour:SetColor(TableToColor(Settings["Player"]["Vitals"]["Custom Morale Colour"]));
	self.playerPowerColour:SetSelected(Settings["Player"]["Vitals"]["Power Display"]);
	self.customPlayerPowerColour:SetColor(TableToColor(Settings["Player"]["Vitals"]["Custom Power Colour"]));

	self.playerTextDisplay:SetSelected(Settings["Player"]["Text"]["Display"]);
	self.resourceEnabled:SetData(Settings["Player"]["Resource"]["Enabled"]);
	self.resourceTimeout:SetValue(Settings["Player"]["Resource"]["Timeout"]);

	self.targetEnabled:SetData(Settings["Target"]["Enabled"]);

	self.targetMoraleColour:SetSelected(Settings["Target"]["Vitals"]["Morale Display"]);
	self.customTargetMoraleColour:SetColor(TableToColor(Settings["Target"]["Vitals"]["Custom Morale Colour"]));

	self.targetTextDisplay:SetSelected(Settings["Target"]["Text"]["Display"]);
end