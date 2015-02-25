 -- Simple pathfinding utilities. Homemade, not that great, but does the job for now.


local path_finder = {}



--======= Helpers ========
	local function already_traveled( point , history )
		local traveled = false
		for i,v in ipairs( history ) do
			if point.x == v.x and point.y == v.y then
				traveled = true
			end
		end
		return traveled
	end

	local function score_tiles( tile_array , target , history )
		local temp_array = {}
		local scored_array = {}
		local max = 0

		for i,v in ipairs( tile_array ) do

			if not already_traveled( v , history ) then
				score = path_finder:get_dist( target , v )
				if score > max then max = score end
				table.insert( temp_array , { score=score , x=v.x , y=v.y } )
			end
		end

		for j=0,max do
			for i,v in ipairs( temp_array ) do
				if v.score == j then 	--if matches, add to scored array, clear
					table.insert( scored_array , v )
					temp_array[ i ] = nil
				end
			end
		end
		return scored_array
	end

	local function get_adj_tiles( current_pt , target_pt , history )
		local x,y = current_pt.x,current_pt.y
		local adj_tiles = {}

		for j=-1,1,2 do
			if atlas:get_passable( x , y+j , true ) then
				table.insert( adj_tiles , { x=x , y=y+j } )
			end
			if atlas:get_passable( x+j , y , true ) then
				table.insert( adj_tiles , { x=x+j , y=y } )
			end
		end

		return score_tiles( adj_tiles , target_pt , history )
	end

	local function root_setup( current_pt , target_pt )
		local dist = path_finder:get_dist( target_pt , current_pt )
		return 0 , {} , dist+(dist*0.35)
	end

--call with current {x,y} , target {x,y}
function path_finder:find_path( current_pt , target_pt , prev_pts , depth , target_depth )
	if not ( depth and prev_pts and target_depth ) then
		depth , prev_pts , target_depth = root_setup( current_pt , target_pt )
	end

	if depth > target_depth then return false end

	local path , history = {} , prev_pts
	table.insert( history, current_pt ) --update path history

	local adj_tiles = get_adj_tiles( current_pt , target_pt , history )

	for i,v in ipairs( adj_tiles ) do
		if v.score == 0 then
			return { v , current_pt }
		else
			path = self:find_path( { x=v.x , y=v.y } , target_pt , history , depth+1 , target_depth )
		end

		if path then 
			table.insert( path , current_pt )
			if depth == 0 then path[ #path ] = nil end --removes starting pt
			return path
		end
	end
	return false
end



--to clear confusion, pt1 is the TARGET, pt2 is the CURRENT POSITION
--I know, it's weird.
function path_finder:get_dist( pt1 , pt2 )
	local result_norm = math.abs( pt1.x - pt2.x ) + math.abs( pt1.y - pt2.y )
	local result_wrap = math.abs( (pt1.x - atlas.world_width_tile) - pt2.x )
							+ math.abs( (pt1.y - atlas.world_height_tile) - (pt2.y) )
	--print( atlas.world_width_tile , atlas.world_height_tile )
	--print( pt1.x , pt1.y , pt2.x , pt2.y )
	--print( result_norm , result_wrap )

	if result_norm <= result_wrap then
		return result_norm
	else
		return result_wrap
	end
end

function path_finder:get_adj_tiles( x , y )
	local adj_tiles = {}

	for j=-1,1,2 do
		if atlas:get_passable( x , y+j ) then
			table.insert( adj_tiles , atlas:get_tile( x , y+j ) )
		end
		if atlas:get_passable( x+j , y ) then
			table.insert( adj_tiles , atlas:get_tile( x+j , y ) )
		end
	end

	return adj_tiles
end


return path_finder