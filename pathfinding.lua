 -- Simple pathfinding utilities. Homemade, not that great, but does the job for now.


path_finder = {}



--======= Helpers ========
	local function get_adj_tiles( current_pt , target_pt , history )
		local x,y = current_pt.x,current_pt.y
		local adj_tiles = {}

		for j=-1,1,2 do
			if map:get_passable( x , y+j ) then
				table.insert( adj_tiles , { x=x , y=y+j } )
			end
			if map:get_passable( x+j , y ) then
				table.insert( adj_tiles , { x=x+j , y=y } )
			end
		end

		return score_tiles( adj_tiles , target_pt , history )
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

	local function already_traveled( point , history )
		local traveled = false
		for i,v in ipairs( history ) do
			if point.x == v.x and point.y == v.y then
				traveled = true
			end
		end
		return traveled
	end

	local function root_setup( current_pt , target_pt )
		local dist = path_finder:get_dist( target_pt , current_pt )
		return 0 , {} , dist+(dist*0.35)
	end

function path_finder:find_path( current_pt , target_pt , prev_pts , depth , target_depth )
	if not depth or not prev_pts or not target_depth then
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




function path_finder:get_dist( pt1 , pt2 )
	return math.abs( pt1.x - pt2.x ) + math.abs( pt1.y - pt2.y )
end


return path_finder