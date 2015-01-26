--[[
	Small file only used for initial world generation, since it's a one-off procedure for each game.


]]

genesis = {}

function genesis:create( width , height )
	local world = {}

	for x = 0,width-1 do
		world[ x ] = {}
		for y = 0,height-1 do
			local type = random_tile_type()
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
--========== Helpers ============
	function random_tile_type()
		local int = math.random( 0 , 100 )
		for i , tile_tble in pairs( rules.a ) do
			if int <= tile_tble.prob then
				return tile_tble.type
			end
		end
	end


	function check_neighbor_tiles()
		
	end


	function border_debug( x , y , width , height )
		if x == 0 or x == width or y == 0 or y == height then
			return true
		else
			return false
		end
	end


	function center_debug( x , y , width , height )
		if x >= 50 and x <= 60 and y >= 50 and y <= 60 then
			return true
		else
			return false
		end
	end


return genesis