
hook.Add( "HUDShouldDraw", "HideHUD", function( name )
	if name == "CHudDamageIndicator" and GetConVar("fes_plymod_dmgindicator"):GetBool() then
		return false
	end
end )


hook.Add( "PopulateToolMenu", "FES_NPC_DMG", function()
	spawnmenu.AddToolMenuOption( "Options", "Fesiug's utilities", "FES_NPC_DMG", "Damage mults", "", "", FES_NPC_DMG)
end )

function FES_NPC_DMG( CPanel )
	CPanel:AddControl("Header", {Description = "Remember to hit Apply when you're done!!" })
	CPanel:AddControl("Button", {Label = "Apply", Command = "fes_ply_apply" })
	
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
	CPanel:AddControl("label",    {text =  "Only allow players to sprint when moving forward, JUST LIKE MODERN WARFARE!!!" })
	
	CPanel:AddControl("Button", {Label = "Apply", Command = "fes_ply_apply" })
end

--[[
if ( CLIENT ) then
	concommand.Add( "bones_cl", function( ply )
		local ent = ply:GetEyeTrace().Entity
		if ( !IsValid( ent ) ) then return end

		ent:AddCallback( "BuildBonePositions", function( ent, numbones )
			for i = 0, numbones - 1 do
				local mat = ent:GetBoneMatrix( i )
				if ( !mat ) then continue end

				local scale = mat:GetScale()
				mat:Scale( Vector( 1, 1, 1 ) * 0.5 )
				ent:SetBoneMatrix( i, mat )
			end
		end )
	end )
end
]]

FES_HT = FES_HT or {}
for i, v in pairs(FES_HT) do
    if !IsValid(v) then
        FES_HT[i] = nil
    else
        v:Remove()
        FES_HT[i] = nil
    end
end

list.Set( "DesktopWindows", "SquadOrder", {
    title = "Order Squad",
    icon = "icon64/squadorder.png",
    init		= function()
		LocalPlayer():ConCommand("impulse 50")
    end
})

if false then

local function DoMakeHands( rendergroup, when, scale2, tex )
    table.insert( FES_HT, ClientsideModel( "models/weapons/c_arms_combine.mdl", rendergroup ) )
    FES_HT[#FES_HT].When = when
    FES_HT[#FES_HT].MyScale = 1
    FES_HT[#FES_HT].Tex = tex
    FES_HT[#FES_HT]:AddCallback( "BuildBonePositions", function( ent, numbones )
        for i = 0, numbones - 1 do
            local mat = ent:GetBoneMatrix( i )
            if ( !mat ) then continue end

            local scale = mat:GetScale()
            mat:Scale( Vector( 1, 1, 1 ) * (ent.MyScale * scale2 ) )
            ent:SetBoneMatrix( i, mat )
        end
    end )
end

-- 1
DoMakeHands( RENDERGROUP_VIEWMODEL_TRANSLUCENT, "Post", 1, "models/hhands/white2" )

-- 2
DoMakeHands( RENDERGROUP_VIEWMODEL_TRANSLUCENT, "Pre", 0.9, "models/hhands/white" )

print("\n\tyour new table:")
PrintTable(FES_HT)

local lastarmor = 0
local armorhurt = 0
local armorregennext = 0
local armorhurtat = 0

hook.Add( "Think", "FES_ArmorCHK", function()
	local time = FrameTime()
    local ply = LocalPlayer()
        local al = 1 - ( ply:Armor() / ply:GetMaxArmor() )
        local al2 = ( ply:Armor() / ply:GetMaxArmor() )

    if ply:Alive() then
        local armor = ply:Armor()

        if armor < ( lastarmor or 0 ) then
            armorhurtat = CurTime()
            armorregennext = CurTime() + GetConVarNumber( "armorregen_delay" )
            armorhurt = armorhurt + ( lastarmor - armor )
        end

        armorhurt = math.max( armorhurt - FrameTime(), 0 )
        
        lastarmor = ply:Armor()
    end
end)

local diff = diff or 0
local function DrawHands( i, v, hands, vm, ply, weapon )
    v:SetNoDraw(true)
    local simplemodel = player_manager.TranslateToPlayerModelName(ply:GetModel())
    local info = player_manager.TranslatePlayerHands(simplemodel)
    if info then
        v:SetModel(info.model)
        v:SetSkin(info.skin)
        v:SetBodyGroups(info.body)
    end

    v:SetOwner( ply )

    v:AddEffects( EF_BONEMERGE )
    v:SetParent( hands )
    v:SetMoveType( MOVETYPE_NONE )

    local al = 1 - ( ply:Armor() / ply:GetMaxArmor() )
    local al2 = ( ply:Armor() / ply:GetMaxArmor() )

    diff = ( armorhurtat - CurTime() )
    diff = math.Clamp(diff, -1, 0) + 1
        local tim = diff
        local s = (math.min(al, 0.67) * 1.7) + Lerp(al2*tim, 0, 1.2)

        if al2 > 0 and tim > 0 then s = math.max(s, 1) end

        if al2 <= 0 then
            s = s + math.sin(CurTime()*3) / 20
        end

        
    v:RemoveEffects( EF_BRIGHTLIGHT + EF_DIMLIGHT )
    if al >= 0.7 then
        v:AddEffects( EF_BRIGHTLIGHT )
    elseif al2 > 0 and tim > 0 then
        v:AddEffects( EF_DIMLIGHT )
    end

    v.MyScale = s

    v:SetPos( vector_origin )
    v:SetAngles( angle_zero )        

    v:SetMaterial( v.Tex )
    v:SetColor(Color(255, 25, 0, 0))

    v:DrawModel()
end

end

hook.Add("PreDrawPlayerHands", "FES_PreDrawPlayerHands", function( hands, vm, ply, weapon )
    for i, v in pairs(FES_HT) do
        if v.When != "Pre" then continue end

        DrawHands( i, v, hands, vm, ply, weapon )
    end
end)

hook.Add("PostDrawPlayerHands", "FES_PreDrawPlayerHands", function( hands, vm, ply, weapon )
    for i, v in pairs(FES_HT) do
        if v.When != "Post" then continue end

        DrawHands( i, v, hands, vm, ply, weapon )
    end
end)

--hook.Remove( "PreDrawPlayerHands", "FES_PreDrawPlayerHands" )
--hook.Remove( "PostDrawPlayerHands", "FES_PreDrawPlayerHands" )
