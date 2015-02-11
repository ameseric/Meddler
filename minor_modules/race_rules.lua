


--everything maps to race.phys[attribute] = race.phys[attribute] + attribute.effects[] For every effects
--yeah, that'll probably never be clear to anyone besides me

--[[

	packaging format assumes a few things
		1) If value is a number, then it's the cost
		2) If value is a key pair with value of number, then it's a stat change (+/-)
		3) If value is a key pair with value of function, then it's a battle or other effect

]]

a = {}


	a.Head = {

		Type = {
			Normal = 	{ 0 }
			,Chest = 	{ 2 , torso=1 }
			,Long =		{ 2
							,Snout = {function() --[[25% chance of no hit]]end 
										,phase='battle'
										,desc = "No sneak-attacks."}
						}
			,Stubby = 	{ 2
							,Flatface ={ function() --[[I have no idea]]end 
											,phase='battle'
											,desc = "I have no idea."}
						}
		}

		,Modifier = {
			None =			{ 0 }
			,Multi_Eyed =	{ 2 , mind=1 }
			,No_Mouth = 	{ 2 , upkeep=-0.25 }
			,Multi_Headed=	{ 2 , upkeep=0.25 , mind=3 }
			,Blind = 		{ 1 , mind=1 , upper_limb=-1 }
			,Horned = 		{ 3 , head=1 , upper_limb=1 }
		}
	}
	

	a.Torso = {

		Base = {
			Skin = 		{ 0 }
			,Fur = 		{ 2 , torso=1 }
			,Scale = 	{ 3 , torso=2 }
			,Arthropod= { 4 , torso=3 }
			--,Bone = 	{ ??? }
			--,Slime = 	{}
			--,Mineral = 	{}

		}

		,Build = {
			Thin = 		{ 1 , lower_limb=1 , upper_limb=-1 }
			,Medium = 	{ 0 }
			,Large = 	{ 1 , lower_limb=-1 , upper_limb=1 }
		}

		,Modifier = {
			None = {0}
			,Musuclar = 	{ 1 , upper_limb=1 }
			,Segmented = 	{ 1 , lower_limb=1 }
			,Anorexic = 		{ 1 , torso=-1 , upper_limb=-1 , head=1 , mind=1 }
		}
	}


	a.Limbs = {

		Build = {
			Short = { 2 , profile=-1 , skill=-1 }
			,Medium = { 0 }
			,Long = { 2 , profile=1 , skill=1 }
			,None = { 0 , profile=-3 , upper_limb=0 , lower_limb=-1 }
		}

		,Base = {
			Humanoid = { 0 }
			--,Segmented = { 3 , skill=1 , upper_limb=1 }
			--,Boneless = { 2 , upper_limb=-1 , i have no idea }
		}

		,Tip = {
			--Claws = {  }
			--,Pincers = {  }
			Digits = { 0 , industry=1 }
		}

		,Modifier = {
			Multi_Armed = { 3 , upper_limb=2 }
			,Multi_Legged = { 3 , lower_limb=2 }
			,Wings = { 4 , Flight = { function() --[[Can always move thru terrain]] end 
										,phase='movement' 
										,desc="Can always move through terrain."}
					}
			,Barbed = { 3 , Tearing = { function() --[[Causes damage when attacked]] end
										,phase='battle'
										,desc="Causes extra damage whenever engaged in combat."}
					}
		}
	}


local race_rules = {}

--packaging of the above table for actual use, especially GUI consumption
for k , body_part in pairs( a ) do
	race_rules[ k ] = {}
	for category , choices in pairs( body_part ) do
		race_rules[ k ][ category ] = {}
		for choice , values in pairs( choices ) do			
			race_rules[ k ][ category ][ choice ] = { cost=0 , effects={} , traits={} }
			for key , value in pairs( values ) do

				if type( key ) == 'number' then
					race_rules[ k ][ category ][ choice ].cost = value
					--print( "Cost: "..value)

				elseif type( value ) == 'number' then
					race_rules[ k ][ category ][ choice ].effects[ key ] = value
					--print( "Stat change: " .. value )

				else
					race_rules[ k ][ category ][ choice ].traits[ key ] = value
					--print( "Trait: "..key.." "..value.desc )
				end
			end
		end
	end
end



return race_rules