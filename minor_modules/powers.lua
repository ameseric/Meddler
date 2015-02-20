--[[

	Different functions relating to Meddler powers.

]]
local default_race = {	
	name = "None"
	,cost = 0
	,config = {
		Head = { Build={ cost=0 , name="Normal" } , Modifier={ cost=0 , name="None" } }
		,Torso = { Base={ cost=0 , name="Skin"} , Build={ cost=0,name="Medium"} , Modifier={cost=0,name="None"} }
		,Limbs = { Build={cost=0,name="Medium"} , Base={cost=0,name="Humanoid"} , Modifier={cost=0,name="None"} , Tip={cost=0,name="Digits"} }
		,Mental = { Build={ name="Zealous" , cost=0 , effects={Boldness=2} } }
		,Cultural = { Build={ name="Sacrificial" , cost=0} }
	}

	,traits = {}

	,Attack = 1
	,Defense = 1
	,Projection = 1
	,Will = 1
	,Move = 3
	,Profile = 1
	,Skill = 1

	,Industry = 1
	,Boldness = 0
	,Order = 0
	,Reproduction = 0
	,Upkeep = 0

	,head_sprite = nil
	,limb_sprite = nil
	,torso_sprite = nil
}

local function Bless( tile , meddler )
	if not tile then
		dialogue( "lack_target" )
		return false

	elseif meddler:purchase( 4 ) then
		return false

	else
		tile.rate = math.ceil( tile.rate * 1.5 )
		tile.timer = 4
		return true
	end
end


local function create_race( meddler , tile )
	if not tile then
		dialogue( "lack_target" )

	elseif not tile:passable() or not tile:habitable() then
		dialogue( "Tile is not clear. Please select a clear plain or forest." )

	else
		dialogue( meddler.name.." is creating a race!" )
		__:start_making_race( default_race )

		return true
	end
end


local function Sacrifice( tile , meddler )
	if not tile then
		dialogue( "lack_target" )
	else
		local unit = tile:get_resident()
		if not unit then
			dialogue( "lack_target")
			return false
		elseif meddler:purchase( 5 ) then
			tile:set_ocpied()
			return true
		end
	end
	return false
end


local function Curse( tile )
	if not tile then
		dialogue( "lack_target")
		return false
	elseif meddler:purchase( 5 ) then
		tile.rate = 0
		tile.timer = 4
		return true
	end
	return false
end

local function Change_land( tile )
	--stuff
end




powers = {}

function powers:resolve( key , tile , meddler )
	local is_player_done = false

	if __:in_givetree() then
		if key == 'l' then 
			is_player_done = create_race( meddler )

		elseif key == 'b' then 
			is_player_done = Bless( tile , meddler )
		end

	elseif __:in_taketree() then		
		if key == 'l' then
			is_player_done = Sacrifice( tile , meddler )

		elseif key == 'b' then
			is_player_done = Curse( tile )
		end

	elseif __:in_altertree() then
		is_player_done = true
		--if key == 'l' then change_life()
		--if key == 'g' then Change_land() end
		--elseif key == 'a' then change_law()
		--end
	end
	return is_player_done
end


--[[
	'Bright'	--0,4,0
	,'Free'		--1,3,0
	,'Weary'	--2,2,0
	,'Feared'	--3,1,0
	,'Dark'		--4,0,0
	,'Tortured'	--3,0,1
	,'Mad'		--2,0,2
	,'Cosmic'	--1,0,3
	,'Unknowable'--0,0,4
	,'Old'		--0,1,3
	,'Primal'	--0,2,2
	,'Benevolent'--0,3,1
	,'Grey'		--1,2,1
	,'Chained'	--2,1,1
	,'Knowing'	--1,1,2
	]]



return powers