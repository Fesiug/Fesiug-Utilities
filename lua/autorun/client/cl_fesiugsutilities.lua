
hook.Add( "HUDShouldDraw", "HideHUD", function( name )
	if name == "CHudDamageIndicator" and GetConVar("fes_plymod_dmgindicator"):GetBool() then
		return false
	end
	if name == "CHudZoom" and GetConVar("fes_plymod_zoom"):GetBool() then
		return false
	end
end )

hook.Add("DrawDeathNotice", "FES_HIDE_NOTICE", function()
	if GetConVar("fes_plymod_deathnotice"):GetBool() then return true end
end)


hook.Add( "PopulateToolMenu", "FES_NPC_DMG", function()
	spawnmenu.AddToolMenuOption( "Options", "Fesiug's Utilities", "FES_NPC_DMG", "Settings", "", "", FES_NPC_DMG)
end )

function FES_NPC_DMG( CPanel )
	CPanel:AddControl("Header", {Description = "Remember to hit Apply when you're done!!" })
	CPanel:AddControl("Button", {Label = "Apply", Command = "fes_ply_apply" })
	CPanel:AddControl("Button", {Label = "Return to GMod Defaults", Command = "fes_ply_defaults" })

	local combobox = vgui.Create( "DComboBox", CPanel )
	combobox.OnSelect = function( self, index, value )
		RunConsoleCommand( "fes_plymod_preset", self:GetOptionData( index ) )
	end
	combobox:Dock( TOP )
	combobox:DockMargin( 10, 10, 10, 10 )
	combobox:SetValue( "Select a preset" )
	combobox:AddChoice( "Half-Life 2", "hl2" )
	combobox:AddChoice( "Half-Life 1", "hl1" )
	combobox:AddChoice( "Counter-Strike: Source", "css" )
	combobox:AddChoice( "Left 4 Dead 2", "l4d2" )
	combobox:AddChoice( "Day of Defeat: Source", "dods" )

	CPanel:AddControl("Header", {Description = "> - Damage Multipliers" })
	CPanel:AddControl("Slider", {Label = "Player to NPC", Command = "fes_ply2npc_mult", min = 0, max = 3, Type = "float" })
	CPanel:AddControl("Slider", {Label = "NPC to Player", Command = "fes_npc2ply_mult", min = 0, max = 3, Type = "float" })
	CPanel:AddControl("Slider", {Label = "Fall Damage Mult", Command = "fes_gra2ply_mult", min = 0, max = 3, Type = "float" })

	CPanel:AddControl("Header", {Description = "> - Player Modifiers" })
	CPanel:AddControl("Slider", {Label = "Max Health", Command = "fes_ply_health_max",	 min = 1,	 max = 300,	Type = "int" })
	CPanel:AddControl("Slider", {Label = "Max Armor", Command = "fes_ply_armor_max",	 min = 1,	 max = 300,	Type = "int" })
	CPanel:AddControl("Slider", {Label = "Start Health", Command = "fes_ply_health_start",	 min = 1,	 max = 300,	Type = "int" })
	CPanel:AddControl("Slider", {Label = "Start Armor", Command = "fes_ply_armor_start",	 min = 1,	 max = 300,	Type = "int" })

	CPanel:AddControl("Header", {Description = "" })

	CPanel:AddControl("Slider", {Label = "Duck Enter", Command = "fes_plyspeed_duckenter",	min = 0,	max = .99,	Type = "float" })
	CPanel:AddControl("Slider", {Label = "Duck Exit", Command = "fes_plyspeed_duckexit", 	min = 0,	max = .99,	Type = "float" })

	CPanel:AddControl("Header", {Description = "> - Player Speed" })
	CPanel:AddControl("Slider", {Label = "Walk Speed", Command = "fes_plyspeed_walkslow",	min = 1,	max = 300,	Type = "float" })
	CPanel:AddControl("Slider", {Label = "Normal Speed", Command = "fes_plyspeed_walk",		min = 100,	max = 500,	Type = "float" })
	CPanel:AddControl("Slider", {Label = "Run Speed", Command = "fes_plyspeed_run",			min = 100,	max = 500,	Type = "float" })
	CPanel:AddControl("Slider", {Label = "Crouching Mult", Command = "fes_plyspeed_crouchedmult",	min = 0,	max = 1,	Type = "float" })
	CPanel:AddControl("Slider", {Label = "Ladder Speed", Command = "fes_plyspeed_ladder",	min = 100,	max = 500,	Type = "float"  })
	CPanel:AddControl("Slider", {Label = "Jump Power", Command = "fes_plyspeed_jumppower",	min = 1,	max = 500,	Type = "float" })

	CPanel:AddControl("Checkbox", {Label = "No-Collide with Team", Command = "fes_plymod_collideteam" })
	CPanel:AddControl("label",    {text =  "Only works with team IDs 1 through 4" })
	CPanel:AddControl("Checkbox", {Label = "Avoid Players", Command = "fes_plymod_avoidplayers" })
	CPanel:AddControl("label",    {text =  "Pushes players away from each other when too close." })
	CPanel:AddControl("Checkbox", {Label = "Disable Giant Fuckall Red Damage Flash", Command = "fes_plymod_dmgindicator" })
	CPanel:AddControl("label",    {text =  "yeah" })
	CPanel:AddControl("Checkbox", {Label = "Only Sprint Moving Forward", Command = "fes_plymod_onlysprintforward" })
	CPanel:AddControl("label",    {text =  "Only allow players to sprint when moving forward." })
	local dropdown = CPanel:ComboBox("Ablative Armor Mode", "fes_plymod_abarmor")
	dropdown:SetSortItems(false)
	dropdown:AddChoice("Disabled", 0)
	dropdown:AddChoice("Enabled", 1)
	dropdown:AddChoice("Enabled 2: Durandal", 2)
	CPanel:AddControl("label",    {text =  "Absorbs most damage types to your armor.\nUse mode 2 if health and armor values start breaking." })
	CPanel:AddControl("Checkbox", {Label = "Fall Damage Armor Protection", Command = "fes_plymod_abarmor_fall" })
	CPanel:AddControl("label",    {text =  "Also absorb fall damage to your armor.\nRequires ablative armor." })
	CPanel:AddControl("Checkbox", {Label = "No HL2 Weapons", Command = "fes_plymod_nohl2weps" })
	CPanel:AddControl("label",    {text =  "Disallow picking up HL2 weapons." })
	CPanel:AddControl("Checkbox", {Label = "Hide Zoom HUD", Command = "fes_plymod_zoom" })
	CPanel:AddControl("label",    {text =  "Hide HL2 Zoom HUD." })
	CPanel:AddControl("Checkbox", {Label = "Hide Death Notice", Command = "fes_plymod_deathnotice" })
	CPanel:AddControl("label",    {text =  "Hide top-right popups on NPC/player death." })

	CPanel:AddControl("Button", {Label = "Apply", Command = "fes_ply_apply" })
	CPanel:AddControl("Button", {Label = "Return to GMod Defaults", Command = "fes_ply_defaults" })
end

list.Set( "DesktopWindows", "SquadOrder", {
	title = "Order Squad",
	icon = "icon32/hand_property.png",
	init		= function()
		LocalPlayer():ConCommand("impulse 50")
	end
})