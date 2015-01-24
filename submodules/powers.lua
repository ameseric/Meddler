--[[

	Different functions relating to Meddler powers.

]]


powers = {


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

--=== Basic Powers, available to all Meddlers at start of game =======

	Bless = function bless( tile )
				tile.output_rate = tile.output_rate * 2
			end

	,Blast = function blast( tile )
				tile.type = 'scorched'
				local target = tile:get_resident()
				if target then
					target:damage( 50 )
				end
			end

	,Raise = function raise( tile )
				if tile.type == 'water' then
					tile.type == 'plain'
				elseif tile.type == 'plain' or tile.type == 'forest' then
					tile.type == 'mountain'
				end
			end

	








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


}


return powers