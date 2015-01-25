

--[[

forest -> plain
plain -> forest
mountain -> hills
hills -> plain

Add
	hills
	budding plain
	chopped forest
	water frames
	desolate
	cursed
	
	?quarry
	?farm


]]



rules = {}
rules.a = { --order matters! That's how the tile sprite are read, so don't change it!
			{ 	type = 'plain'
				,is_passable = true
				,move_cost = 1
				,prob = 50
				,resource = 'food'
				,rate = 5
				,lifetime = 10
				,next_life = 'desolate' --desolate

			}
			,{ 	type = 'forest'
				,is_passable = true
				,move_cost = 2
				,prob = 20
				,resource = 'wood'
				,rate = 4
				,lifetime = 10
				,next_life = 'cleared plain'
			}
			,{ 	type = 'mountain'
				,is_passable = true
				,move_cost = 3
				,prob = 15
				,resource = 'stone'
				,rate = 2
				,lifetime = 60
				,next_life = 'water'
			}
			,{ 	type = 'water'
				,is_passable = false
				,move_cost = 1
				,prob = 5
				,resource = 'food'
				,rate = 3
				,lifetime = -1
				,next_life = 'none'
			}
			,{ 	type = 'desolate'
				,is_passable = true
				,move_cost = 1
				,prob = 0
				,resource = 'none'
				,rate = 0
				,lifetime = -1
				,next_life = 'none'
			}
			,{ 	type = 'deep forest'
				,is_passable = true
				,move_cost = 3
				,prob = 10
				,resource = 'wood'
				,rate = 2
				,lifetime = 15
				,next_life = 'forest'
			}
			,{ 	type = 'cleared plain'
				,is_passable = true
				,move_cost = 1
				,prob = 0
				,resource = 'wood'
				,rate = 6
				,lifetime = 10
				,next_life = 'plain'
			}
			,{ 	type = 'village'
				,is_passable = true
				,move_cost = 1
				,prob = 0
				,resource = 'none'
				,rate = 0
				,lifetime = -1
				,next_life = 'none'
			}
		}

rules.total_set = {}


local count , itr = 0 , 0
for i , tile_tble in ipairs( rules.a ) do
	count = tile_tble.prob + count
	tile_tble.prob = count
	tile_tble.quad = love.graphics.newQuad( (itr%4)*TS , math.floor(itr/4)*TS , TS , TS , 128 , 128 ) --might need to add flexibility
	itr = itr + 1

	rules.total_set[ tile_tble.type ] = tile_tble
end


return rules