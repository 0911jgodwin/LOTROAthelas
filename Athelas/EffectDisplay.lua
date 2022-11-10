EffectDisplay = class(Turbine.UI.Control)
function EffectDisplay:Constructor()
    Turbine.UI.Control.Constructor( self );
    self:SetSize(24, 25)

    self.iconLabel = Turbine.UI.Lotro.EffectDisplay()
    self.iconLabel:SetEffect(nil);
    self.iconLabel:SetParent(self);
    self.iconLabel:SetPosition(2,2);
    self.iconLabel:SetSize(20, 21);
    self.iconLabel:SetVisible(true);

    self.foreground = Turbine.UI.Control();
    self.foreground:SetParent(self);
    self.foreground:SetBackground("ExoPlugins/Athelas/Resources/effectForeground.tga");
    self.foreground:SetBlendMode(0);
    self.foreground:SetSize(22,25);
    self.foreground:SetLeft(1);
    self.foreground:SetStretchMode(1);
    self.foreground:SetMouseVisible(false);
    self.foreground:SetZOrder(101);
end

function EffectDisplay:SetEffect(effect)
    self.iconLabel:SetEffect(effect);
end

function EffectDisplay:GetEffect()
    return self.iconLabel:GetEffect();
end