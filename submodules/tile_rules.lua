

rules = {}
rules.a = { 
			plain = 	{ is_passable = true , prob = 50 }
			,forest = 	{ is_passable = true , prob = 35 }
			,mountain = { is_passable = false , prob = 10 }
			,lake = 	{ is_passable = false , prob = 5 }
		}

rules.b = {
	
}


local count , itr = 0 , 0
for tile_name , tile_tble in pairs( rules.a ) do
	count = tile_tble.prob + count
	tile_tble.prob = count
	tile_tble.quad = love.graphics.newQuad( (itr%4)*TS , math.floor(itr/4)*TS , TS , TS , 128 , 128 ) --might need to add flexibility
	itr = itr + 1
end


return rules