import "ExoPlugins.Athelas";

if LoadData(Turbine.DataScope.Character, "AthelasSettings") ~= nil then
	_G.Settings = LoadData(Turbine.DataScope.Character, "AthelasSettings");
else
	_G.Settings = GenerateDefaultSettings();
end

function LoadPlugin()
	VitalsWindow = VitalsWindow();
	VitalsWindow:SetVisible( true );
	Turbine.UI.Lotro.LotroUI.SetEnabled( Turbine.UI.Lotro.LotroUIElement.Vitals, false );

	if _G.Settings["Target"]["Enabled"] == true then
		TargetVitalsWindow = TargetVitalsWindow();
		Turbine.UI.Lotro.LotroUI.SetEnabled( Turbine.UI.Lotro.LotroUIElement.Target, false );
	end
end

function ReloadPlugin()
	Turbine.PluginManager.LoadPlugin( "~AthelasReloader" );
end

local status  = 0;
reloader = Turbine.UI.Control();

function reloader:Update()
	if status == 1 then
        Turbine.PluginManager.UnloadScriptState( "AthelasReloader" );
    elseif status > 1 then
        self:SetWantsUpdates( false );
        reloader = nil;
	end
    status = status + 1;
end

reloader:SetWantsUpdates( true );

Logo = Logo();
Updater = Updater();

LoadPlugin();

plugin.Load=function(sender, args)
	Turbine.Shell.WriteLine("<rgb=#FF5555><" .. plugin:GetName() .. "></rgb> V." .. plugin:GetVersion() .. " loaded.");
end

plugin.Unload=function()
	VitalsWindow:Unload();
	SaveData(Turbine.DataScope.Character, "AthelasSettings", Settings);
	Turbine.Shell.WriteLine("<rgb=#FF5555><Athelas></rgb> Unload Complete");
    Turbine.UI.Lotro.LotroUI.SetEnabled( Turbine.UI.Lotro.LotroUIElement.Vitals, true );
end