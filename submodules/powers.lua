--[[

	Different functions relating to Meddler powers.

]]


all_powers = {}

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


return all_powers