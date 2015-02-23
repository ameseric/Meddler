


local structure_rules = {}

local structure_rules.a = {
	Village = {
		cost = { mineral=5 , wood=10 }
		,units={ 'Citizen' }
		,stats={ life=10 , attack=0 }
	}

	,Town = {
		cost = { mineral=10 , wood=20 }
		,units={ 'Citizen' , 'LInfantry' , 'LCalvary'	}
		,stats={ life=10 , attack=0 }
	}

	,City = {
		cost = { mineral=5 , wood=10 }
		,units={ 'Citizen' , 'LInfantry' , 'LCalvary' }
		,stats={ life=10 , attack=0 }
	}

	,Fortress = {
		cost = { mineral=5 , wood=10 }
		,units={ 'HInfantry' , 'HCalvary' }
		,stats={ life=10 , attack=0 }
	}

	,Temple = {
		cost = { mineral=5 , wood=10 }
		,units={ }--'Priest' , 'Mage' }
		,stats={ life=10 , attack=0 }
	}

	,Quarry = {
		cost = { wood=5 }
		,units={ }
		,stats={ life=5 , attack=0 }
	}

	,Farm = {
		cost = { wood=5 }
		,units={ }
		,stats={ life=5 , attack=0 }
	}

	,Lumberyard = {
		cost = { mineral=5 }
		,units={ }
		,stats={ life=5 , attack=0 }
	}

}


structure_rules.total_set = {}

function structure_rules:get_rules( type )
	return self.total_set[ type ]
end

function structure_rules:get_quad( type )
	return self.total_set[ type ].quad
end


local itr = 0
for i , tile_tble in ipairs( structure_rules.a ) do
	tile_tble.quad = love.graphics.newQuad( (itr%4)*TS , math.floor(itr/4)*TS , TS , TS , 128 , 128 ) --might need to add flexibility
	itr = itr + 1

	structure_rules.total_set[ tile_tble.type ] = tile_tble
end


return structure_rules