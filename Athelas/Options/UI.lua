HeaderNode = class(Turbine.UI.TreeNode);
function HeaderNode:Constructor(text)
	Turbine.UI.TreeNode.Constructor(self);
	self:SetSize(398, 26);

	self.text = Turbine.UI.Label();
	self.text:SetParent(self);
	self.text:SetSize(360,22);
	self.text:SetPosition(28, 0);
	self.text:SetText(text);
	self.text:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	self.text:SetFont(Turbine.UI.Lotro.Font.TrajanProBold24);
	self.text:SetForeColor(Turbine.UI.Color(225/255,197/255,110/255));
	self.text:SetMouseVisible(false);

	self.chevron = Turbine.UI.Control();
	self.chevron:SetParent(self);
	self.chevron:SetBackground("ExoPlugins/Athelas/Resources/UI/ChevronDown.tga")
	self.chevron:SetBlendMode(4);
	self.chevron:SetSize(18,18);
	self.chevron:SetPosition(5,3);
	self.chevron:SetMouseVisible(false);
	

	self.underline = Turbine.UI.Control();
	self.underline:SetParent(self);
	self.underline:SetPosition(5,25);
	self.underline:SetSize(388, 1);
	self.underline:SetBackColor(Turbine.UI.Color( 1, 82/255, 60/255, 5/255 ));
	self.underline:SetMouseVisible(false);
end

function HeaderNode:ToggleChevron()
	if self:IsExpanded() then
		self.chevron:SetBackground("ExoPlugins/Athelas/Resources/UI/ChevronDown.tga");
	else
		self.chevron:SetBackground("ExoPlugins/Athelas/Resources/UI/ChevronRight.tga");
	end
end

function HeaderNode:MouseClick()
	self:ToggleChevron();
end

function HeaderNode:Unload()
	local childNodes = self:GetChildNodes();
	
	for i=1, childNodes:GetCount() do
		childNodes:Get(i):Unload();
	end
end

SettingsNode = class(Turbine.UI.TreeNode);
function SettingsNode:Constructor()
	Turbine.UI.TreeNode.Constructor(self);
	self:SetSize(398,22);

	self.border = Border();
	self.border:SetParent(self);
	self.border:SetSize(388, 12);
	self.border:SetPosition(5,5);

	self.container = Turbine.UI.ListBox();
	self.container:SetParent(self);
	self.container:SetSize(366, 0);
	self.container:SetPosition(15, 10);
end

function SettingsNode:AddContent(content)
	local height = content:GetHeight();
	self:SetHeight(self:GetHeight()+height);

	self.border:SetHeight(self.border:GetHeight()+height);

	self.container:AddItem(content);


	AddCallback(content, "SizeChanged", function()
		self:CalculateHeight();
	end);
end

function SettingsNode:CalculateHeight()
	local height = 0;
	for i = 1, self.container:GetItemCount() do
		height = height + self.container:GetItem(i):GetHeight();
	end
	
	self.container:SetHeight(height);
	self.border:SetHeight(height+10);
	self:SetHeight(height+20);
	local parent = self:GetParentNode();

	if parent:IsExpanded() then
		parent:Collapse();
		parent:Expand();
	end
end

function SettingsNode:Unload()
	for i=1, self.container:GetItemCount() do
		self.container:GetItem(i):Unload();
		Debug("test");
	end
end

function SettingsNode:GetData()
	--return self.contents:GetData();
end

Subheading = class(Turbine.UI.Control);
function Subheading:Constructor(text)
	Turbine.UI.TreeNode.Constructor(self);
	self:SetSize(366,35);

	self.underline = Turbine.UI.Control();
	self.underline:SetParent(self);
	self.underline:SetSize(120, 1);
	self.underline:SetBackColor(Turbine.UI.Color( 1, 82/255, 60/255, 5/255 ));
	self.underline:SetPosition(123,24);
	self.underline:SetVisible(true);

	self.text = Turbine.UI.Label();
	self.text:SetParent(self);
	self.text:SetSize(120,20);
	self.text:SetPosition(123, 3);
	self.text:SetText(text);
	self.text:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	self.text:SetFont(Turbine.UI.Lotro.Font.TrajanProBold22);
	self.text:SetFontStyle( Turbine.UI.FontStyle.Outline );
	self.text:SetOutlineColor( Turbine.UI.Color( 0, 0, 0 ) );
	self.text:SetForeColor(Turbine.UI.Color(225/255,197/255,110/255));
	self.text:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
end

CheckBoxSetting = class(Turbine.UI.Control)
function CheckBoxSetting:Constructor(text)
	Turbine.UI.Control.Constructor(self);

	self.text = Turbine.UI.Label();
	self.text:SetParent(self);
	self.text:SetText(text);
	self.text:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	self.text:SetFont(Turbine.UI.Lotro.Font.TrajanProBold16);
	self.text:SetFontStyle( Turbine.UI.FontStyle.Outline );
	self.text:SetOutlineColor( Turbine.UI.Color( 0, 0, 0 ) );
	self.text:SetForeColor(Turbine.UI.Color(225/255,197/255,110/255));
	self.text:SetMouseVisible(false);

	self.checkBox = CustomCheckBox();
	self.checkBox:SetParent(self)
	
	self:SetSize(173, 30);
end

function CheckBoxSetting:SetValue(bool)
	self.checkBox:SetValue(bool);
end

function CheckBoxSetting:SizeChanged()
	local width, height = self:GetSize();
	self.text:SetSize(width-16,height);
	self.checkBox:SetPosition(width-16, (height-16)/2);
end

function CheckBoxSetting:GetValue()
	return self.checkBox:IsChecked();
end

function CheckBoxSetting:Unload()
	self.checkBox:Unload();
	self.text = nil;
	self = nil;
end

ExpandingCheckBoxSetting = class(Turbine.UI.Control)
function ExpandingCheckBoxSetting:Constructor(text)
	Turbine.UI.Control.Constructor(self);

	self:SetSize(366, 30);
	self.contentHeight = 0;

	self.text = Turbine.UI.Label();
	self.text:SetParent(self);
	self.text:SetSize(157,30);
	self.text:SetText(text);
	self.text:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	self.text:SetFont(Turbine.UI.Lotro.Font.TrajanProBold16);
	self.text:SetFontStyle( Turbine.UI.FontStyle.Outline );
	self.text:SetOutlineColor( Turbine.UI.Color( 0, 0, 0 ) );
	self.text:SetForeColor(Turbine.UI.Color(225/255,197/255,110/255));
	self.text:SetMouseVisible(false);

	self.checkBox = CustomCheckBox();
	self.checkBox:SetParent(self)
	self.checkBox:SetPosition(157, 7);

	self.container = Turbine.UI.ListBox();
	self.container:SetParent(self);
	self.container:SetPosition(0,30);
	self.container:SetSize(366, 0);

	self.checkBox.CheckBoxClicked = function()
		if self.checkBox:IsChecked() then
			local height = self:CalculateHeight();
			self:SetHeight(30+height);
		else
			self:SetHeight(30);
		end
	end
end

function ExpandingCheckBoxSetting:SetData(bool)
	self.checkBox:SetValue(bool);
end

function ExpandingCheckBoxSetting:GetData()
	return self.checkBox:IsChecked();
end

function ExpandingCheckBoxSetting:AddContent(content)
	self.contentHeight = self.contentHeight + content:GetHeight();
	self.container:AddItem(content);
	self.container:SetHeight(self.contentHeight);

	AddCallback(content, "SizeChanged", function()
		self:ChildrenSizeChanged();
	end);
end

function ExpandingCheckBoxSetting:CalculateHeight()
	local height = 0;
	for i=1, self.container:GetItemCount() do
		height = height + self.container:GetItem(i):GetHeight();
	end
	return height;
end

function ExpandingCheckBoxSetting:ChildrenSizeChanged()
	local height = self:CalculateHeight();
	
	self.container:SetHeight(height);
	if self.checkBox:IsChecked() then
		self:SetHeight(30+height);
	else
		self:SetHeight(30);
	end
end

CustomCheckBox = class(Turbine.UI.Control)
function CustomCheckBox:Constructor()
	Turbine.UI.Control.Constructor(self);

	self:SetSize(16, 16);
	self:SetBackColor(Turbine.UI.Color(225/255,197/255,110/255));
	self:SetMouseVisible(true);

	self.box = Turbine.UI.Control();
	self.box:SetParent(self);
	self.box:SetSize(14, 14);
	self.box:SetPosition(1,1);
	self.box:SetBackColor(Turbine.UI.Color(0.85, 0, 0, 0));
	self.box:SetMouseVisible(false);

	self.fill = Turbine.UI.Control();
	self.fill:SetParent(self.box);
	self.fill:SetSize(10, 10);
	self.fill:SetPosition(2, 2);
	self.fill:SetBackColor(Turbine.UI.Color(225/255,197/255,110/255));
	self.fill:SetVisible(false);
	self.fill:SetMouseVisible(false);

	self.Checked = nil;
	
end

function CustomCheckBox:MouseClick()
	self.fill:SetVisible(not self.fill:IsVisible());
	self:CheckBoxClicked();
end

function CustomCheckBox:SetActive()
	self.fill:SetVisible(not self.fill:IsVisible());
	self:CheckBoxClicked();
end

function CustomCheckBox:SetValue(bool)
	self.fill:SetVisible(bool);
	self:CheckBoxClicked();
end

function CustomCheckBox:CheckBoxClicked()
	--Overwrite with functionality
end

function CustomCheckBox:IsChecked()
	return self.fill:IsVisible();
end

function CustomCheckBox:Unload()
	self.box = nil;
	self.fill = nil;
	self = nil;
end

Slider = class(Turbine.UI.Control)
function Slider:Constructor()
	Turbine.UI.Control.Constructor(self);
	self.sliderMin = 0;
	self.sliderMax = 100;
	self.sliderValue = 0;

	self.sliderRange = self.sliderMax - self.sliderMin;

	self.keySize = 16;
	self.valueSize = 32;

	self:SetSize(100, 16);
	self:SetMouseVisible(false);

	self.alignment = "horizontal";

	self.key = Turbine.UI.Label();
	self.key:SetSize(self.keySize, 16);
	--self.key:SetText("Text Size: ");
	self.key:SetFont( Turbine.UI.Lotro.Font.TrajanProBold16 );
	self.key:SetForeColor(Turbine.UI.Color(225/255,197/255,110/255));
	self.key:SetMouseVisible(false);
	self.key:SetParent(self);

	self.value = Turbine.UI.Lotro.TextBox();
	self.value:SetSize(self.valueSize, 16);
	self.value:SetText(0);
	self.value:SetFont( Turbine.UI.Lotro.Font.TrajanPro14 );
	self.value:SetTextAlignment( 5 );
	self.value:SetForeColor(Turbine.UI.Color(225/255,197/255,110/255));
	self.value:SetParent(self);

	self.valueBorder = Border();
	self.valueBorder:SetParent(self);
	self.valueBorder:SetSize(self.valueSize, 16);

	self.slideBar = Turbine.UI.Control();
	self.slideBar:SetSize(100, 1);
	self.slideBar:SetBackColor(Turbine.UI.Color( 1, 82/255, 60/255, 5/255 ));
	self.slideBar:SetMouseVisible(false);
	self.slideBar:SetBackColorBlendMode( Turbine.UI.BlendMode.AlphaBlend );
	self.slideBar:SetParent(self);

	self.background = Turbine.UI.Control();
	self.background:SetBackColor(Turbine.UI.Color(0, 0, 0, 0));
	self.background:SetSize(100-16*2, 16);
	self.background:SetPosition(16, 0);
	self.background:SetBackColorBlendMode( Turbine.UI.BlendMode.AlphaBlend );
	self.background:SetParent(self);

	self.background.IsHovering = CreateHoverFunction(self.background);

	self.background.MouseUp = function(sender, args)
		if self.sliderRange < 2 then return end

		if self.background.IsHovering() then
			local position = self.background:GetMousePosition() - 8;
			local width = self.background:GetWidth() - 16;

			if position < 0 then position = 0 elseif position > width then position = width end;

			self.widget:SetPosition( position, 0 );
			self.widgetPosition = position;
			self.sliderValue = math.floor((((self.sliderMax - self.sliderMin)/width)*position)+0.5) + self.sliderMin;
			self.value:SetText(self.sliderValue);
			self:ValueChanged(self.sliderValue);
		end
	end

	self.widget = Turbine.UI.Control();
	self.widget:SetBackground("ExoPlugins/Athelas/Resources/UI/sliderWidget.tga");
	self.widget:SetParent(self.background);
	self.widget:SetSize(16,16);
	self.widget:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend )
	self.widget:SetBackColorBlendMode( Turbine.UI.BlendMode.Multiply )
	self.widget:SetPosition(16, 0);

	self.widget.MouseDown = function(sender, args)
		if not self.widget.Dragging then
			self.widget.Dragging = true;
			self.widget.DragStart = args.X
		end

		self.widget:SetBackground("ExoPlugins/Athelas/Resources/UI/sliderWidgetPressed.tga")
	end

	self.widget.MouseUp = function()
		if self.sliderRange < 2 then return end;

		if self.widget.Dragging then
			self.widget.Dragging = false;

			self.value:SetText(self.sliderValue);
			self:ValueChanged(self.sliderValue);
		end

		self.widget:SetBackground("ExoPlugins/Athelas/Resources/UI/sliderWidget.tga")
	end

	self.widget.MouseEnter = function()
		if self.widget.Dragging then return end;

		self.widget:SetBackground("ExoPlugins/Athelas/Resources/UI/sliderWidgetHover.tga")
	end

	self.widget.MouseLeave = function()
		if self.widget.Dragging then return end;

		self.widget:SetBackground("ExoPlugins/Athelas/Resources/UI/sliderWidget.tga")
	end

	self.widget.MouseMove = function(sender, args)
		if self.widget.Dragging then
			local position = self.widget:GetPosition() - self.widget.DragStart + args.X;
			local width = self.background:GetWidth() - 16;

			if position < 0 then position = 0 elseif position > width then position = width end;

			self.widget:SetPosition( position, 0 );
			self.widgetPosition = position;
			self.sliderValue = math.floor((((self.sliderMax - self.sliderMin)/width)*position)+0.5) + self.sliderMin;
			self.value:SetText(self.sliderValue);
			self:SliderChanged(self.sliderValue);
		end
	end

	self.leftButton = Turbine.UI.Control();
	self.leftButton:SetBackground("ExoPlugins/Athelas/Resources/UI/sliderLeft.tga")
	self.leftButton:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.leftButton:SetSize(16,16);
	self.leftButton:SetParent(self);

	self.leftButton.MouseUp = function()
		self.leftButton:SetBackground("ExoPlugins/Athelas/Resources/UI/sliderLeftHover.tga");

		self.leftButton:SetWantsUpdates(false);
	end

	self.leftButton.MouseEnter = function()
		self.leftButton:SetBackground("ExoPlugins/Athelas/Resources/UI/sliderLeftHover.tga");
	end

	self.leftButton.MouseLeave = function()
		self.leftButton:SetBackground("ExoPlugins/Athelas/Resources/UI/sliderLeft.tga");
	end

	self.leftButton.MouseDown = function()
		self.leftButton:SetBackground("ExoPlugins/Athelas/Resources/UI/sliderLeftPressed.tga");
		self.leftButton:Move();
		self.leftButton.count = 0;
		self.leftButton:SetWantsUpdates(true);
	end

	self.leftButton.Update = function()
		if self.leftButton.count == 40 then
			self.leftButton:Move();
		else
			self.leftButton.count = self.leftButton.count+1;
		end
	end

	self.leftButton.Move = function()
		if self.sliderValue <= self.sliderMin then return end

		local max = self.background:GetWidth() - 16;
		self.widgetPosition = self.widgetPosition - ( max / (self.sliderRange));

		if self.widgetPosition <= 0 then self.widgetPosition = 0 end

		self.widget:SetPosition(self.widgetPosition, 0);

		self.sliderValue = self.sliderValue - 1;
		self.value:SetText(self.sliderValue);
		self:ValueChanged();
	end

	self.rightButton = Turbine.UI.Control();
	self.rightButton:SetBackground("ExoPlugins/Athelas/Resources/UI/sliderRight.tga")
	self.rightButton:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.rightButton:SetSize(16,16);
	self.rightButton:SetParent(self);

	self.rightButton.MouseUp = function()
		self.rightButton:SetBackground("ExoPlugins/Athelas/Resources/UI/sliderRightHover.tga");

		self.rightButton:SetWantsUpdates(false);
	end

	self.rightButton.MouseEnter = function()
		self.rightButton:SetBackground("ExoPlugins/Athelas/Resources/UI/sliderRightHover.tga");
	end

	self.rightButton.MouseLeave = function()
		self.rightButton:SetBackground("ExoPlugins/Athelas/Resources/UI/sliderRight.tga");
	end

	self.rightButton.MouseDown = function()
		self.rightButton:SetBackground("ExoPlugins/Athelas/Resources/UI/sliderRightPressed.tga");
		self.rightButton:Move();
		self.rightButton.count = 0;
		self.rightButton:SetWantsUpdates(true);
	end

	self.rightButton.Update = function()
		if self.rightButton.count == 40 then
			self.rightButton:Move();
		else
			self.rightButton.count = self.rightButton.count+1;
		end
	end

	self.rightButton.Move = function()
		if self.sliderValue >= self.sliderMax then return end

		local width = self.background:GetWidth();
		local max = width - 16;
		self.widgetPosition = self.widgetPosition + ( max / (self.sliderRange));

		if self.widgetPosition >= width then self.widgetPosition = width end

		self.widget:SetPosition(self.widgetPosition, 0);

		self.sliderValue = self.sliderValue + 1;
		self.value:SetText(self.sliderValue);
		self:ValueChanged();
	end
end

function Slider:SetValue(value, disable)
	if value < self.sliderMin then value = self.sliderMin elseif value > self.sliderMax then value = self.sliderMax end

	self.sliderValue = value

	local width = self.background:GetWidth() - 16;
	local total = width / ( self.sliderMax - self.sliderMin )

	self.widgetPosition = ( value - self.sliderMin ) * total

	self.widget:SetPosition( self.widgetPosition, 0 )

	--self.Value.old_text = value

	if not disable then
		self.value:SetText( value )

		self:ValueChanged( value )
    end
end

function Slider:GetValue()
	return self.sliderValue;
end

function Slider:SizeChanged()
	local w, h = self:GetSize()
	local offset = 0;
	if h > 16 then
		offset = (h-16)/2;
	end

	if self.alignment == "horizontal" then
		self.background:SetPosition( 16 + self.keySize, offset )
		self.background:SetSize( w - 32 - self.keySize - self.valueSize - 2, 16 )

		self.leftButton:SetPosition( self.keySize, offset )
		self.rightButton:SetPosition( w - 16 - self.valueSize - 2, offset )

		self.value:SetPosition( w - self.valueSize, offset );
		self.value:SetWidth( self.valueSize );
		self.valueBorder:SetPosition(w - self.valueSize, offset);
		self.valueBorder:SetWidth(self.valueSize);

		self.key:SetWidth( self.keySize );
		self.key:SetTop(offset);

		self:SetValue( self.sliderValue, true )

		self.slideBar:SetPosition( 16 + 2 + self.keySize, 7+offset )
		self.slideBar:SetSize( w - 16 * 2 - 4 - self.keySize - self.valueSize - 2, 2 );
	elseif self.alignment == "vertical" then

		self.key:SetWidth( w );
		self.key:SetTop(5);
		self.key:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);

		self.background:SetPosition( 16, 18 );
		self.background:SetSize( w - 34, 16 );

		self.leftButton:SetPosition( 0, 18 )
		self.rightButton:SetPosition( w - 16, 18 )

		self.value:SetPosition( (w/2) - (self.valueSize/2), 34 );
		self.value:SetWidth( self.valueSize );
		self.valueBorder:SetPosition((w/2) - (self.valueSize/2), 34);
		self.valueBorder:SetWidth(self.valueSize);

		

		self:SetValue( self.sliderValue, true )

		self.slideBar:SetPosition( 16 + 2, 25 )
		self.slideBar:SetSize( w - 32 - 4, 2 );
	end
end

function Slider:SliderChanged( value )

end

function Slider:ValueChanged(value)

end

function Slider:SetAlignment( alignment )
	self.alignment = alignment;
end

function Slider:SetKey(text)
	self.key:SetText(text);
end

function Slider:DisableValueEdit(bool)
	self.value:SetReadOnly(bool);
end

function Slider:SetRange( min, max )
	self.sliderMin = min
	self.sliderMax = max

	self.sliderRange = max - min
end

function Slider:SetKeySize(size)
	self.keySize = size;
	self:SizeChanged();
end

function Slider:Unload()
	self.key = nil;
	self.value = nil;
	self.valueBorder = nil;
	self.slideBar = nil;
	self.background = nil;
	self.widget = nil;
	self.leftButton = nil;
	self.rightButton = nil;
	self = nil;
end

ColourSetting = class(Turbine.UI.Control);
function ColourSetting:Constructor(text)
	Turbine.UI.Control.Constructor(self);

	self:SetSize(366, 80);

	self.text = Turbine.UI.Label();
	self.text:SetParent(self);
	self.text:SetSize(300,20);
	self.text:SetText(text);
	self.text:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	self.text:SetFont(Turbine.UI.Lotro.Font.TrajanProBold16);
	self.text:SetFontStyle( Turbine.UI.FontStyle.Outline );
	self.text:SetOutlineColor( Turbine.UI.Color( 0, 0, 0 ) );
	self.text:SetForeColor(Turbine.UI.Color(225/255,197/255,110/255));
	self.text:SetMouseVisible(false);

	self.r = self:SetupSlider("R: ");
	self.g = self:SetupSlider("G ");
	self.b = self:SetupSlider("B: ");

	self.r:SetPosition(0,20);
	self.g:SetPosition(0, 40);
	self.b:SetPosition(0, 60);

	self.colourPanel = Turbine.UI.Control();
	self.colourPanel:SetParent(self);
	self.colourPanel:SetSize(53,53);
	self.colourPanel:SetBackColor(Turbine.UI.Color(1, 0, 0));
	self.colourPanel:SetPosition(310, 22);

	self.colourBorder = Border();
	self.colourBorder:SetParent(self);
	self.colourBorder:SetSize(55,55);
	self.colourBorder:SetZOrder(101);
	self.colourBorder:SetPosition(309,21);

	self.r:SetValue(255);
	self.g:SetValue(180);
	self.b:SetValue(100)
end

function ColourSetting:SetupSlider(key)
	local slider = Slider();
	slider:SetSize(290, 20);
	slider:SetKey(key);
	slider:SetKeySize(20);
	slider:SetRange(0,255);
	slider:SetParent(self);
	slider:DisableValueEdit(true);
	slider.ValueChanged = function(value)
		self:ChangeColor();
	end
	return slider;
end

function ColourSetting:ChangeColor()
	self.colourPanel:SetBackColor(self:GetColor());
end

function ColourSetting:SetColor(color)
	self.colourPanel:SetBackColor(color);
	self.r:SetValue(color.R * 255);
	self.g:SetValue(color.G * 255);
	self.b:SetValue(color.B * 255);
end

function ColourSetting:GetColor()
	return Turbine.UI.Color(self.r:GetValue()/255, self.g:GetValue()/255, self.b:GetValue()/255);
end

IconSetting = class(Turbine.UI.Control);
function IconSetting:Constructor()
	Turbine.UI.Control.Constructor(self);

	self:SetSize(366, 75);
	self.currentImage = 1;
	self.text = Turbine.UI.Label();
	self.text:SetParent(self);
	self.text:SetSize(350,20);
	self.text:SetText("Icon Filepath: ");
	self.text:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	self.text:SetFont(Turbine.UI.Lotro.Font.TrajanProBold16);
	self.text:SetFontStyle( Turbine.UI.FontStyle.Outline );
	self.text:SetOutlineColor( Turbine.UI.Color( 0, 0, 0 ) );
	self.text:SetForeColor(Turbine.UI.Color(225/255,197/255,110/255));
	self.text:SetMouseVisible(false);
	self.text:SetPosition(0, 5);

	self.textBox = Turbine.UI.Lotro.TextBox();
	self.textBox:SetSize(290, 20);
	self.textBox:SetText(0);
	self.textBox:SetFont( Turbine.UI.Lotro.Font.TrajanPro16 );
	self.textBox:SetTextAlignment( 5 );
	self.textBox:SetForeColor(Turbine.UI.Color(225/255,197/255,110/255));
	self.textBox:SetParent(self);
	self.textBox:SetPosition(0, 25);

	self.textBorder = Border();
	self.textBorder:SetParent(self);
	self.textBorder:SetSize(290,20);
	self.textBorder:SetZOrder(101);
	self.textBorder:SetPosition(0,25);
	

	self.iconPanel = Turbine.UI.Control();
	self.iconPanel:SetParent(self);
	self.iconPanel:SetSize(53,53);
	self.iconPanel:SetPosition(310, 12);

	self.iconBorder = Border();
	self.iconBorder:SetParent(self);
	self.iconBorder:SetSize(55,55);
	self.iconBorder:SetZOrder(101);
	self.iconBorder:SetPosition(309,11);

	self.imageBrowseButton = Button("Image Browser", 144);
	self.imageBrowseButton:SetParent(self);
	self.imageBrowseButton:SetPosition(-1, 46);

	self.findImageButton = Button("Find Image", 144);
	self.findImageButton:SetParent(self);
	self.findImageButton:SetPosition(145, 46);

	

	self.findImageButton.MouseClick = function(sender, args)
		self:LoadImage(self.textBox:GetText());
	end
end

function IconSetting:SetVisible(bool)
	if bool then
		self:LoadImage(self.textBox:GetText());
	else
		self.iconPanel:SetStretchMode(0);
	end
end

function IconSetting:Unload()
	self.currentImage = nil;
	self.text = nil;
	self.textBox = nil;
	self.textBorder = nil;
	self.iconPanel:SetStretchMode(0);
	self.iconPanel = nil;
	self.iconBorder:Unload();
	self.imageBrowseButton:Unload();
	self.findImageButton:Unload();

	self = nil;
end

function IconSetting:LoadImage(image)
	foo = function()
		if tonumber(image) then
			self.iconPanel:SetBackground(tonumber(image));
		else
			self.iconPanel:SetBackground(image);
		end
		self.iconPanel:SetStretchMode(2);
		self.iconPanel:SetStretchMode(1);
		self.iconPanel:SetSize(53,53);
	end
	if not pcall(foo) then
		Turbine.Shell.WriteLine("Image is not valid")
	else
		self.currentImage = image;
		self.textBox:SetText(image);
	end
end

function IconSetting:SetImage(image)
	self.textBox:SetText(image);
	self:LoadImage(image);
end

function IconSetting:GetImage()
	return self.currentImage;
end

Button = class(Turbine.UI.Control)
function Button:Constructor( text, width )
	Turbine.UI.Control.Constructor( self );
	self:SetHeight(22);
	self:SetWidth(width+4);

	self.border = Turbine.UI.Control();
	self.border:SetParent(self);
	self.border:SetSize(width, 20);
	self.border:SetPosition(1, 1);
	self.border:SetBackColor(Turbine.UI.Color( 1, 82/255, 60/255, 5/255 ));
	self.border:SetMouseVisible(false);

	self.container = Turbine.UI.Control();
	self.container:SetParent(self.border);
	self.container:SetSize(width-2, 18);
	self.container:SetPosition(1,1);
	self.container:SetBackColor(Turbine.UI.Color( 0.9, 0, 0, 0 ));
	self.container:SetMouseVisible(false);

	self.text = Turbine.UI.Label();
	self.text:SetParent(self.container);
	self.text:SetSize(width-2,18);
	self.text:SetText(text);
	self.text:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	self.text:SetFont(Turbine.UI.Lotro.Font.TrajanProBold16);
	self.text:SetForeColor(Turbine.UI.Color(225/255,197/255,110/255));
	self.text:SetMouseVisible(false);
end

function Button:MouseEnter(sender, args)
	self.container:SetBackColor(Turbine.UI.Color( 0.95, 0.1, 0.1, 0.1 ));
end

function Button:MouseLeave(sender, args)
	self.container:SetBackColor(Turbine.UI.Color( 0.9, 0, 0, 0 ));
end

function Button:MouseClick(sender, args)

end

function Button:Unload()
	self.border = nil;
	self.container = nil;
	self.text = nil;
	self = nil;
end

Border = class(Turbine.UI.Control)
function Border:Constructor()
	Turbine.UI.Control.Constructor(self);

	self:SetMouseVisible(false);
	self.borderLeft = Turbine.UI.Control();
	self.borderTop = Turbine.UI.Control();
	self.borderRight = Turbine.UI.Control();
	self.borderBottom = Turbine.UI.Control();
	self:SetSize(1,1);
	
	self.borderLeft:SetParent(self);
	self.borderLeft:SetVisible(true);
	self.borderLeft:SetBackColor(Turbine.UI.Color( 1, 82/255, 60/255, 5/255 ));
	self.borderLeft:SetZOrder(101);
	self.borderLeft:SetPosition(0, 1);
	self.borderLeft:SetMouseVisible(false);

	
	self.borderTop:SetParent(self);
	self.borderTop:SetVisible(true);
	self.borderTop:SetBackColor(Turbine.UI.Color( 1, 82/255, 60/255, 5/255 ));
	self.borderTop:SetZOrder(101);
	self.borderTop:SetMouseVisible(false);

	
	self.borderRight:SetParent(self);
	self.borderRight:SetVisible(true);
	self.borderRight:SetBackColor(Turbine.UI.Color( 1, 82/255, 60/255, 5/255 ));
	self.borderRight:SetZOrder(101);
	self.borderRight:SetMouseVisible(false);

	
	self.borderBottom:SetParent(self);
	self.borderBottom:SetVisible(true);
	self.borderBottom:SetBackColor(Turbine.UI.Color( 1, 82/255, 60/255, 5/255 ));
	self.borderBottom:SetZOrder(101);
	self.borderBottom:SetMouseVisible(false);

	self:SetVisible(true);
end

function Border:SizeChanged()
	local x, y = self:GetSize();
	self.borderLeft:SetSize(1, y-2);
	self.borderTop:SetSize(x, 1);
	self.borderRight:SetSize(1, y-2);
	self.borderRight:SetPosition(x-1, 1);
	self.borderBottom:SetSize(x, 1);
	self.borderBottom:SetPosition(0, self:GetHeight()-1);
end

function Border:Unload()
	self.borderLeft = nil;
	self.borderTop = nil;
	self.borderRight = nil;
	self.borderBottom = nil;
	self = nil;
end

LargeTextSetting = class(Turbine.UI.Control)
function LargeTextSetting:Constructor(text, y)
	Turbine.UI.Control.Constructor(self);

	self:SetSize(316, 25+10+y);

	self.text = Turbine.UI.Label();
	self.text:SetParent(self);
	self.text:SetSize(300,20);
	self.text:SetText(text);
	self.text:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	self.text:SetFont(Turbine.UI.Lotro.Font.TrajanProBold16);
	self.text:SetFontStyle( Turbine.UI.FontStyle.Outline );
	self.text:SetOutlineColor( Turbine.UI.Color( 0, 0, 0 ) );
	self.text:SetForeColor(Turbine.UI.Color(225/255,197/255,110/255));
	self.text:SetMouseVisible(false);
	self.text:SetTop(5);

	self.textBox = Turbine.UI.Lotro.TextBox();
	self.textBox:SetSize(316, y);
	self.textBox:SetText(0);
	self.textBox:SetFont( Turbine.UI.Lotro.Font.TrajanPro16 );
	self.textBox:SetTextAlignment( Turbine.UI.ContentAlignment.TopLeft );
	self.textBox:SetForeColor(Turbine.UI.Color(225/255,197/255,110/255));
	self.textBox:SetParent(self);
	self.textBox:SetPosition(0, 30);

	self.textBorder = Border();
	self.textBorder:SetParent(self);
	self.textBorder:SetSize(316,y);
	self.textBorder:SetZOrder(101);
	self.textBorder:SetPosition(0,30);
end

function LargeTextSetting:SetText(text)
	self.textBox:SetText(text);
end

function LargeTextSetting:GetText()
	return self.textBox:GetText();
end

function LargeTextSetting:Unload()
	self.text = nil;
	self.textBox = nil;
	self.textBorder = nil;
	self = nil;
end

TextSetting = class(Turbine.UI.Control)
function TextSetting:Constructor(text, x)
	Turbine.UI.Control.Constructor(self);

	self:SetSize(390, 30);

	self.text = Turbine.UI.Label();
	self.text:SetParent(self);
	self.text:SetSize(300,20);
	self.text:SetText(text);
	self.text:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	self.text:SetFont(Turbine.UI.Lotro.Font.TrajanProBold16);
	self.text:SetFontStyle( Turbine.UI.FontStyle.Outline );
	self.text:SetOutlineColor( Turbine.UI.Color( 0, 0, 0 ) );
	self.text:SetForeColor(Turbine.UI.Color(225/255,197/255,110/255));
	self.text:SetMouseVisible(false);
	self.text:SetTop(5);

	self.textBox = Turbine.UI.Lotro.TextBox();
	self.textBox:SetSize(x, 20);
	self.textBox:SetText(0);
	self.textBox:SetFont( Turbine.UI.Lotro.Font.TrajanPro16 );
	self.textBox:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	self.textBox:SetForeColor(Turbine.UI.Color(225/255,197/255,110/255));
	self.textBox:SetParent(self);
	self.textBox:SetPosition(365-x, 5);

	self.textBox.FocusLost = function(args)
		self:FocusLost();
	end

	self.textBorder = Border();
	self.textBorder:SetParent(self);
	self.textBorder:SetSize(x, 20);
	self.textBorder:SetZOrder(101);
	self.textBorder:SetPosition(365-x, 5);
end

function TextSetting:SetText(text)
	self.textBox:SetText(text);
end

function TextSetting:FocusLost()

end

function TextSetting:GetText()
	return self.textBox:GetText();
end

function TextSetting:Unload()
	self.text = nil;
	self.textBox = nil;
	self.textBorder = nil;
	self = nil;
end

DropDownSetting = class(Turbine.UI.Control)
function DropDownSetting:Constructor(text)
	Turbine.UI.Control.Constructor(self);

	self:SetSize(173, 50);

	self.active = false;

	self.text = Turbine.UI.Label();
	self.text:SetParent(self);
	self.text:SetSize(173,20);
	self.text:SetText(text);
	self.text:SetTextAlignment(Turbine.UI.ContentAlignment.TopCenter);
	self.text:SetFont(Turbine.UI.Lotro.Font.TrajanProBold16);
	self.text:SetFontStyle( Turbine.UI.FontStyle.Outline );
	self.text:SetOutlineColor( Turbine.UI.Color( 0, 0, 0 ) );
	self.text:SetForeColor(Turbine.UI.Color(225/255,197/255,110/255));
	self.text:SetMouseVisible(false);
	self.text:SetTop(5);

	self.dropdownBorder = Border();
	self.dropdownBorder:SetParent(self);
	self.dropdownBorder:SetSize(173, 22);
	self.dropdownBorder:SetZOrder(101);
	self.dropdownBorder:SetPosition(0, 21);
	

	self.dropdownBox = Turbine.UI.Control()
	self.dropdownBox:SetParent(self);
	self.dropdownBox:SetSize(173, 20);
	self.dropdownBox:SetPosition(0, 22);

	self.dropdownBox.IsHovering = CreateHoverFunction(self.dropdownBox);


	self.dropdownText = Turbine.UI.Label();
	self.dropdownText:SetParent(self.dropdownBox);
	self.dropdownText:SetSize(154, 20);
	self.dropdownText:SetText("Insert Text");
	self.dropdownText:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	self.dropdownText:SetFont(Turbine.UI.Lotro.Font.TrajanProBold16);
	self.dropdownText:SetFontStyle( Turbine.UI.FontStyle.Outline );
	self.dropdownText:SetOutlineColor( Turbine.UI.Color( 0, 0, 0 ) );
	self.dropdownText:SetForeColor(Turbine.UI.Color(225/255,197/255,110/255));
	self.dropdownText:SetMouseVisible(false);

	self.dropdownArrow = Turbine.UI.Control();
	self.dropdownArrow:SetParent(self.dropdownBox);
	self.dropdownArrow:SetSize(16,16);
	self.dropdownArrow:SetBackground("ExoPlugins/Athelas/Resources/UI/dropdown.tga");
	self.dropdownArrow:SetBlendMode(4);
	self.dropdownArrow:SetPosition(154, 2);
	self.dropdownArrow:SetMouseVisible(false);

	self.DropdownWindow = DropDownWindow(self);
	self.DropdownWindow:SetVisible(false);

	self.dropdownBox.MouseEnter = function(sender, args)
		if self.active then return end
		self.dropdownArrow:SetBackground("ExoPlugins/Athelas/Resources/UI/dropdownHover.tga");
		self.dropdownText:SetForeColor(Turbine.UI.Color(233/255,213/255,163/255));
	end

	self.dropdownBox.MouseLeave = function(sender, args)

		if self.active then return end
		self.dropdownArrow:SetBackground("ExoPlugins/Athelas/Resources/UI/dropdown.tga");
		self.dropdownText:SetForeColor(Turbine.UI.Color(225/255,197/255,110/255));
	end

	self.dropdownBox.MouseClick = function(sender, args)

		self.DropdownWindow:SetVisible(true);
		local x, y = self:PointToScreen(self.dropdownBorder:GetPosition());
		self.DropdownWindow:SetPosition(x-1, y + 1);
		self.DropdownWindow:Activate();
		self:GenerateWindowContents();
		self.DropdownWindow:SetWantsUpdates(true);
		self.active = true;
	end
end

function DropDownSetting:AddList(list, currentItem)
	self.list = list;
	self.currentItem = currentItem;
	self.lookupList = {};
	for i, v in ipairs(self.list) do
		self.lookupList[v] = i;
	end

	self.dropdownText:SetText(currentItem);
end

function DropDownSetting:GenerateWindowContents()
	self.DropdownWindow:ResetList();
	for i, v in ipairs(self.list) do
		if v ~= self.currentItem then
			self.DropdownWindow:AddItem(v);
		end
	end
end

function DropDownSetting:SetSelected(item)
	item = self.lookupList[item];
	self.dropdownText:SetText(self.list[item]);
	self.currentItem = self.list[item];
end

function DropDownSetting:CloseWindow()
	self.DropdownWindow:SetVisible(false);
	if not self.dropdownBox:IsHovering() then
		self.dropdownArrow:SetBackground("ExoPlugins/Athelas/Resources/UI/dropdown.tga");
		self.dropdownText:SetForeColor(Turbine.UI.Color(225/255,197/255,110/255));
	end
	self.DropdownWindow:SetWantsUpdates(false);
	self.active = false;
end

DropDownWindow = class(Turbine.UI.Window)
function DropDownWindow:Constructor(dropdownControl)
	Turbine.UI.Window.Constructor(self);

	self.dropdownControl = dropdownControl;

	self:SetSize(174, 23);
	self:SetBackColor(Turbine.UI.Color(0.6,0,0,0));
	self:SetZOrder(1001);

	self.dropdownBorder = Border();
	self.dropdownBorder:SetParent(self);
	self.dropdownBorder:SetSize(173, 101);
	self.dropdownBorder:SetZOrder(101);
	self.dropdownBorder:SetPosition(1, -1);

	self.container = Turbine.UI.ListBox();
	self.container:SetParent(self);
	self.container:SetSize(173, 0);
	self.container:SetPosition(2, 20);
	self.container:SetBackColor(Turbine.UI.Color(1,0,0));

	self.IsHovering = CreateHoverFunction(self);
end

function DropDownWindow:AddItem(item)
	self.container:AddItem(DropdownItem(self, item));

	self.container:SetHeight(self.container:GetHeight() + 20);
	self:SetHeight(self:GetHeight()+20);
	self.dropdownBorder:SetHeight(self.dropdownBorder:GetHeight()+20);
end

function DropDownWindow:ResetList()
	self.container:ClearItems();
	
	self.container:SetHeight(0);
	self:SetHeight(23);
	self.dropdownBorder:SetHeight(21);
end

function DropDownWindow:SetSelected(item)
	self.dropdownControl:SetSelected(item);
	self.dropdownControl:CloseWindow();
end

function DropDownWindow:Update()
	if not self:IsHovering() then
		self.dropdownControl:CloseWindow();
	end
end

function DropDownWindow:MouseClick()
	self.dropdownControl:CloseWindow();
end

DropdownItem = class(Turbine.UI.Control)
function DropdownItem:Constructor(dropdown, text)
	Turbine.UI.Control.Constructor(self);

	self.dropdown = dropdown;
	self.item = text;
	self:SetSize(171,20);
	self:SetBackColor(Turbine.UI.Color(0.9, 0, 0, 0));

	self.text = Turbine.UI.Label();
	self.text:SetParent(self);
	self.text:SetSize(154,20);
	self.text:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	self.text:SetFont(Turbine.UI.Lotro.Font.TrajanProBold16);
	self.text:SetFontStyle( Turbine.UI.FontStyle.Outline );
	self.text:SetOutlineColor( Turbine.UI.Color( 0, 0, 0 ) );
	self.text:SetForeColor(Turbine.UI.Color(225/255,197/255,110/255));
	self.text:SetText(text);
	self.text:SetMouseVisible(false);
end

function DropdownItem:MouseEnter(sender, args)
	self:SetBackColor(Turbine.UI.Color(0.9, 0.1, 0.1, 0.1));
end

function DropdownItem:MouseLeave(sender, args)
	self:SetBackColor(Turbine.UI.Color(0.9, 0, 0, 0));
end

function DropdownItem:MouseClick(sender, args)
	self.dropdown:SetSelected(self.item);
end

ExpandingDropDownSetting = class(Turbine.UI.Control)
function ExpandingDropDownSetting:Constructor(text)
	Turbine.UI.Control.Constructor(self);

	self:SetSize(366, 30);

	self.active = false;

	self.text = Turbine.UI.Label();
	self.text:SetParent(self);
	self.text:SetSize(173,30);
	self.text:SetText(text);
	self.text:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	self.text:SetFont(Turbine.UI.Lotro.Font.TrajanProBold16);
	self.text:SetFontStyle( Turbine.UI.FontStyle.Outline );
	self.text:SetOutlineColor( Turbine.UI.Color( 0, 0, 0 ) );
	self.text:SetForeColor(Turbine.UI.Color(225/255,197/255,110/255));
	self.text:SetMouseVisible(false);

	self.dropdownBorder = Border();
	self.dropdownBorder:SetParent(self);
	self.dropdownBorder:SetSize(173, 22);
	self.dropdownBorder:SetZOrder(101);
	self.dropdownBorder:SetPosition(366-173, 4);

	self.dropdownBox = Turbine.UI.Control()
	self.dropdownBox:SetParent(self);
	self.dropdownBox:SetSize(173, 20);
	self.dropdownBox:SetPosition(366-173, 5);

	self.dropdownBox.IsHovering = CreateHoverFunction(self.dropdownBox);


	self.dropdownText = Turbine.UI.Label();
	self.dropdownText:SetParent(self.dropdownBox);
	self.dropdownText:SetSize(154, 20);
	self.dropdownText:SetText("Insert Text");
	self.dropdownText:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	self.dropdownText:SetFont(Turbine.UI.Lotro.Font.TrajanProBold16);
	self.dropdownText:SetFontStyle( Turbine.UI.FontStyle.Outline );
	self.dropdownText:SetOutlineColor( Turbine.UI.Color( 0, 0, 0 ) );
	self.dropdownText:SetForeColor(Turbine.UI.Color(225/255,197/255,110/255));
	self.dropdownText:SetMouseVisible(false);

	self.dropdownArrow = Turbine.UI.Control();
	self.dropdownArrow:SetParent(self.dropdownBox);
	self.dropdownArrow:SetSize(16,16);
	self.dropdownArrow:SetBackground("ExoPlugins/Athelas/Resources/UI/dropdown.tga");
	self.dropdownArrow:SetBlendMode(4);
	self.dropdownArrow:SetPosition(154, 2);
	self.dropdownArrow:SetMouseVisible(false);

	self.DropdownWindow = DropDownWindow(self);
	self.DropdownWindow:SetVisible(false);

	self.dropdownBox.MouseEnter = function(sender, args)
		if self.active then return end
		self.dropdownArrow:SetBackground("ExoPlugins/Athelas/Resources/UI/dropdownHover.tga");
		self.dropdownText:SetForeColor(Turbine.UI.Color(233/255,213/255,163/255));
	end

	self.dropdownBox.MouseLeave = function(sender, args)

		if self.active then return end
		self.dropdownArrow:SetBackground("ExoPlugins/Athelas/Resources/UI/dropdown.tga");
		self.dropdownText:SetForeColor(Turbine.UI.Color(225/255,197/255,110/255));
	end

	self.dropdownBox.MouseClick = function(sender, args)

		self.DropdownWindow:SetVisible(true);
		local x, y = self:PointToScreen(self.dropdownBorder:GetPosition());
		self.DropdownWindow:SetPosition(x-1, y + 1);
		self.DropdownWindow:Activate();
		self:GenerateWindowContents();
		self.DropdownWindow:SetWantsUpdates(true);
		self.active = true;
	end

	self.contentHeight = 0;

	self.container = Turbine.UI.ListBox();
	self.container:SetParent(self);
	self.container:SetPosition(0,30);
	self.container:SetSize(366, 0);
end

function ExpandingDropDownSetting:AddList(list, currentItem)
	self.list = list;
	self.currentItem = currentItem;
	self.lookupList = {};
	for i, v in ipairs(self.list) do
		self.lookupList[v] = i;
	end

	self.dropdownText:SetText(currentItem);
end

function ExpandingDropDownSetting:GenerateWindowContents()
	self.DropdownWindow:ResetList();
	for i, v in ipairs(self.list) do
		if v ~= self.currentItem then
			self.DropdownWindow:AddItem(v);
		end
	end
end

function ExpandingDropDownSetting:SetSelected(item)
	item = self.lookupList[item];
	self.dropdownText:SetText(self.list[item]);
	self.currentItem = self.list[item];

	if self.currentItem == self.expandedSelection then
		local height = self:CalculateHeight();
		self:SetHeight(30+height);
	else
		self:SetHeight(30);
	end
end

function ExpandingDropDownSetting:GetSelected()
	return self.currentItem;
end

function ExpandingDropDownSetting:CloseWindow()
	self.DropdownWindow:SetVisible(false);
	if not self.dropdownBox:IsHovering() then
		self.dropdownArrow:SetBackground("ExoPlugins/Athelas/Resources/UI/dropdown.tga");
		self.dropdownText:SetForeColor(Turbine.UI.Color(225/255,197/255,110/255));
	end
	self.DropdownWindow:SetWantsUpdates(false);
	self.active = false;
end

function ExpandingDropDownSetting:AddContent(selection, content)
	self.expandedSelection = selection;
	self.contentHeight = self.contentHeight + content:GetHeight();
	self.container:AddItem(content);
	self.container:SetHeight(self.contentHeight);

	AddCallback(content, "SizeChanged", function()
		self:ChildrenSizeChanged();
	end);
end

function ExpandingDropDownSetting:CalculateHeight()
	local height = 0;
	for i=1, self.container:GetItemCount() do
		height = height + self.container:GetItem(i):GetHeight();
	end
	return height;
end

function ExpandingDropDownSetting:ChildrenSizeChanged()
	local height = self:CalculateHeight();
	
	self.container:SetHeight(height);
	if self.expandedSelection == self.currentItem then
		self:SetHeight(30+height);
	else
		self:SetHeight(30);
	end
end

DoubleBox = class(Turbine.UI.ListBox)
function DoubleBox:Constructor()
	Turbine.UI.ListBox.Constructor(self);
	self:SetHeight(30);
	self:SetWidth(366);

	self:SetOrientation( Turbine.UI.Orientation.Horizontal );

	self.needsPadding = true;
end

function DoubleBox:AddContent(content)
	local height = content:GetHeight();

	if height > self:GetHeight() then
		self:SetHeight(height);
	end

	self:AddItem(content);
	if self.needsPadding then
		local padding = Turbine.UI.Control();
		padding:SetSize(20,height);

		self:AddItem(padding);
		self.needsPadding = false;
	end
end

function DoubleBox:Unload()
	self:GetItem(1):Unload();
	self:GetItem(3):Unload();

	self = nil;
end

ScrollBar = class(Turbine.UI.ScrollBar)
function ScrollBar:Constructor()
	Turbine.UI.ScrollBar.Constructor(self);
	self:SetSize(10,200);
	self:SetOrientation(Turbine.UI.Orientation.Vertical);

	self.background = Turbine.UI.Control();
	self.background:SetBackColor(Turbine.UI.Color( 1, 82/255, 60/255, 5/255 ));
	self.background:SetParent(self);
	self.background:SetLeft(3);

	self.thumbButton = ThumbButton();

	self:SetThumbButton(self.thumbButton);
end

function ScrollBar:SizeChanged()
	local w, h = self:GetSize();
    self.background:SetSize( 2, h );
end

ThumbButton = class(Turbine.UI.Control)
function ThumbButton:Constructor()
	Turbine.UI.Control.Constructor(self);

	self.up = "ExoPlugins/Athelas/Resources/UI/arrowUp.tga";
	self.upHover = "ExoPlugins/Athelas/Resources/UI/arrowUpHover.tga";
	self.upPressed = "ExoPlugins/Athelas/Resources/UI/arrowUpPressed.tga";
	self.down = "ExoPlugins/Athelas/Resources/UI/arrowDown.tga";
	self.downHover = "ExoPlugins/Athelas/Resources/UI/arrowDownHover.tga";
	self.downPressed = "ExoPlugins/Athelas/Resources/UI/arrowDownPressed.tga";

	self:SetSize(8,128);
	self:SetBackColor(Turbine.UI.Color(1,1,1,1));
	self:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self:SetBackColorBlendMode(Turbine.UI.BlendMode.Multiply);

	self.top = Turbine.UI.Control();
	self.top:SetParent(self);
	self.top:SetBackColor(Turbine.UI.Color(0,0,0,0));
	self.top:SetPosition(-4, -2);
	self.top:SetBackground(self.up);
	self.top:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.top:SetBackColorBlendMode(Turbine.UI.BlendMode.Multiply);
	self.top:SetSize(16,16);
	self.top:SetMouseVisible(false);

	self.middle = Turbine.UI.Control();
	self.middle:SetParent(self);
	self.middle:SetBackColor(Turbine.UI.Color(1,0.486,0.408,0.243));
	self.middle:SetPosition(0, 16 - 4);
	self.middle:SetSize(12, 128 - 16 * 2 + 8);
	self.middle:SetMouseVisible(false);

	self.bottom = Turbine.UI.Control();
	self.bottom:SetParent(self);
	self.bottom:SetBackColor(Turbine.UI.Color(0,0,0,0));
	self.bottom:SetPosition(-4, 128 - 16 + 2);
	self.bottom:SetBackground(self.down);
	self.bottom:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.bottom:SetBackColorBlendMode(Turbine.UI.BlendMode.Multiply);
	self.bottom:SetSize(16,16);
	self.bottom:SetMouseVisible(false);

	self.IsHovering = CreateHoverFunction(self);
end

function ThumbButton:MouseEnter()
	if self.dragging then return end

    self.top:SetBackground( self.upHover );
    self.middle:SetBackColor(Turbine.UI.Color(1,0.655,0.549,0.333));
    self.bottom:SetBackground( self.downHover );
end

function ThumbButton:MouseLeave()
	if self.dragging then return end

    self.top:SetBackground( self.up );
    self.middle:SetBackColor(Turbine.UI.Color(1,0.486,0.408,0.243));
    self.bottom:SetBackground( self.down );
end

function ThumbButton:MouseDown()
	self.top:SetBackground( self.upPressed );
    self.middle:SetBackColor(Turbine.UI.Color(1,0.322,0.267,0.153));
    self.bottom:SetBackground( self.downPressed );

    self.dragging = true;
end

function ThumbButton:MouseUp()
	if self:IsHovering() then
		self.top:SetBackground( self.upHover );
		self.middle:SetBackColor(Turbine.UI.Color(1,0.655,0.549,0.333));
		self.bottom:SetBackground( self.downHover );
	else
		self.top:SetBackground( self.up );
	self.middle:SetBackColor(Turbine.UI.Color(1,0.486,0.408,0.243));
	self.bottom:SetBackground( self.down );
	end

	self.dragging = false;
end

function ThumbButton:SizeChanged()
	local w, h = self:GetSize();
    self.middle:SetSize( 8, h - 16 * 2 + 8 );
    self.bottom:SetPosition( -4, h - 16 + 2 );
end