import "Turbine"
import "Turbine.UI"

local status  = 0
control_reload = Turbine.UI.Control()

function control_reload:Update()
	if status == 1 then
		Turbine.PluginManager.UnloadScriptState( "Athelas" )
	elseif status == 2 then
		Turbine.PluginManager.LoadPlugin( "Athelas" )
	elseif status > 2 then
        self:SetWantsUpdates( false )
        
		control_reload = nil
	end

	status = status + 1
end

control_reload:SetWantsUpdates( true )

local check  = 0
control_check = Turbine.UI.Control()

function control_check:Update()
	if check == 50 then
		Turbine.PluginManager.UnloadScriptState( "Athelas" )
	elseif check == 51 then
		Turbine.PluginManager.LoadPlugin( "Athelas" )
	elseif check > 51 then
        self:SetWantsUpdates( false )
        
		control_check = nil
	end

	check = check + 1
end

control_check:SetWantsUpdates( true )