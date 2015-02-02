--[[

	Different functions relating to Meddler powers.

]]


local function Bless( tile )
	if not tile then
		dialogue( "Cannot bless. No tile selected." )
	else
		tile.rate = math.ceil( tile.rate * 1.5 )
		tile.timer = 4
	end
end

local function create_race()
	print( "Creating race..." )
	creating_race = true
	creating_race_top_level = true
	race_being_created = { name = "None" , mental = "None" , culture = "None" }
end


local function Sacrifice( tile , meddler )
	if not tile then
		dialogue( "Cannot sacrifice. No unit selected." )
	else
		local unit = tile:get_resident()
		if not unit then
			dialogue( "Cannot sacrifice. No unit selected.")
		else
			tile:set_ocpied()
			meddler:change_emi( 5 )
		end
	end
end


local function Curse( tile )
	if not tile then
		dialogue( "Cannot curse. No tile selected.")
	else
		tile.rate = 0
		tile.timer = 4
	end
end

local function Change_land( tile )
	--stuff
end




powers = {}

function powers:resolve( key , tile , meddler )
	local is_player_done = false

	if give_tree then
		if key == 'l' or key == 'b' then
			is_player_done = true
			if key == 'l' then create_race()
			elseif key == 'b' then Bless( tile ) end
		end
	elseif take_tree then
		if key == 'l' or key == 'b' or key == 'g' then
			is_player_done = true
			if key == 'l' then Sacrifice( tile , meddler )
			elseif key == 'b' then Curse( tile )
			end--elseif key == 'g' then take_land() end
		end
	elseif alter_tree then
		if key == 'l' or key == 'g' or key == 'a' then
			is_player_done = true
			--if key == 'l' then change_life()
			--if key == 'g' then Change_land() end
			--elseif key == 'a' then change_law()
			--end
		end
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





--[[
function powers.Harvest( city , atlas.world , med )
	local x , y = city.location
	powers.inf( 10 , med )

	for i=0,2 do
		for j=0,2 do
			if atlas.world[ i+x ][ j+y ].type == 'farm' then
				city.wealth = city.wealth + 50
			end
		end
	end
end

function powers.Observe()
	stuff
end


function powers.Wander()
	--all races created by this Meddler are granted +1 activity for the turn
end


function powers.Warp( med , world , loc_a , loc_b ) --switches any two tiles of the world map
	powers.inf( 10 , med )

	local temp = world[ loc_a.x ][ loc_a.y ]
	world[ loc_a.x ][ loc_a.y ] = world[ loc_b.x ][ loc_b.y ]
	world[ loc_b.x ][ loc_b.y ] = temp
end



function powers.inf( cost , med )
	med.influence = med.influence - cost
end
--]]


return powers