Tab = class(Turbine.UI.Control)
function Tab:Constructor( text, icon, width )
	Turbine.UI.Control.Constructor( self );
	self:SetHeight(34);
	self:SetWidth(width+4);
	

	self.border = Turbine.UI.Control();
	self.border:SetParent(self);
	self.border:SetSize(width, 24);
	self.border:SetPosition(2, 2);
	self.border:SetBackColor(Turbine.UI.Color( 1, 82/255, 60/255, 5/255 ));

	self.container = Turbine.UI.Control();
	self.container:SetParent(self.border);
	self.container:SetSize(width-2, 22);
	self.container:SetPosition(1,1);
	self.container:SetBackColor(Turbine.UI.Color( 0.8, 0, 0, 0 ));

	self.text = Turbine.UI.Label();
	self.text:SetParent(self.container);
	self.text:SetSize(width-2,22);
	self.text:SetText(text .. " ");
	self.text:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
	self.text:SetFont(Turbine.UI.Lotro.Font.TrajanProBold16);
	self.text:SetForeColor(Turbine.UI.Color(225/255,197/255,110/255));

	self.image = Turbine.UI.Control();
	self.image:SetParent( self.container );
	self.image:SetBackground(icon)
	self.image:SetSize(64,64);
	self.image:SetStretchMode(1);
	self.image:SetSize(14,14);
	self.image:SetPosition(4,4);
end

function Tab:MouseEnter(sender, args)
	self.container:SetBackColor(Turbine.UI.Color( 0.85, 0.1, 0.1, 0.1 ));
end

function Tab:MouseLeave(sender, args)
	self.container:SetBackColor(Turbine.UI.Color( 0.8, 0, 0, 0 ));
end