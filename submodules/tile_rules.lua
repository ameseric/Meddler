

--[[

Forest -> Plain
Plain -> Forest
Mountain -> hills
hills -> Plain

Add
	hills
	budding Plain
	chopped Forest
	Water frames
	Desolate
	cursed
	
	?quarry
	?farm


]]



rules = {}
rules.a = { --order matters! That's how the tile sprites are read, so don't change it!
			{ 	type = 'Plain'
				,is_passable = true
				,move_cost = 1
				,prob = 55
				,resource = 'food'
				,rate = 5
				,lifetime = 10
				,next_life = 'Desolate' --Desolate

			}
			,{ 	type = 'Forest'
				,is_passable = true
				,move_cost = 2
				,prob = 30
				,resource = 'wood'
				,rate = 4
				,lifetime = 10
				,next_life = 'Cleared Plain'
			}
			,{ 	type = 'Mountain'
				,is_passable = true
				,move_cost = 3
				,prob = 10
				,resource = 'stone'
				,rate = 2
				,lifetime = 60
				,next_life = 'Water'
			}
			,{ 	type = 'Water'
				,is_passable = false
				,move_cost = 1
				,prob = 5
				,resource = 'food'
				,rate = 3
				,lifetime = -1
				,next_life = 'none'
			}
			,{ 	type = 'Desolate'
				,is_passable = true
				,move_cost = 1
				,prob = 0
				,resource = 'none'
				,rate = 0
				,lifetime = -1
				,next_life = 'none'
			}
			,{ 	type = 'Deep Forest'
				,is_passable = true
				,move_cost = 3
				,prob = 0
				,resource = 'wood'
				,rate = 2
				,lifetime = 15
				,next_life = 'Forest'
			}
			,{ 	type = 'Cleared Plain'
				,is_passable = true
				,move_cost = 1
				,prob = 0
				,resource = 'wood'
				,rate = 6
				,lifetime = 10
				,next_life = 'Plain'
			}
			,{ 	type = 'Village'
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

function rules:get_rules( type )
	return self.total_set[ type ]
end

function rules:get_quad( type )
	return self.total_set[ type ].quad
end


local count , itr = 0 , 0
for i , tile_tble in ipairs( rules.a ) do
	count = tile_tble.prob + count
	tile_tble.prob = count
	tile_tble.quad = love.graphics.newQuad( (itr%4)*TS , math.floor(itr/4)*TS , TS , TS , 128 , 128 ) --might need to add flexibility
	itr = itr + 1

	rules.total_set[ tile_tble.type ] = tile_tble
end


return rules