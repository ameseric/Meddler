--[[
	Small file only used for initial world generation, since it's a one-off procedure for each game.


]]

local genesis = {}


--========== Helpers ============
	local function random_tile_type( world , x , y )
		local seed = math.random( 1 , 8 )

		if #world > 0 and #world[x] > 0 then
			local type_a = world[x-1][y].type
			local type_b = world[x][y-1].type

			if type_a == type_b and type_a == 'Forest' then
				return "Deep Forest"
			elseif seed == 1 then
				return type_a
			elseif seed == 2 then
				return type_b
			end
		end


		local int = math.random( 0 , 100 )
		for i , tile_tble in pairs( rules.a ) do
			if int <= tile_tble.prob then
				return tile_tble.type
			end
		end
	end

	local function check_neighbor_tiles()
	end

	local function border_debug( x , y , width , height )
		if x == 0 or x == width or y == 0 or y == height then
			return true
		else
			return false
		end
	end

	local function center_debug( x , y , width , height )
		if x >= 50 and x <= 60 and y >= 50 and y <= 60 then
			return true
		else
			return false
		end
	end

function genesis:create( width , height )
	local world = {}

	for x = 0,width-1 do
		world[ x ] = {}
		for y = 0,height-1 do
			local type = random_tile_type( world , x , y )
			world[ x ][ y ] = tiles:new( type )
			
			if border_debug( x , y , width , height ) then
				world[ x ][ y ] = tiles:new( 'Mountain' )
			end

			if center_debug( x , y , width , height ) then
				world[ x ][ y ] = tiles:new( 'Mountain' )
			end
		end
	end

	return world
end






return genesis