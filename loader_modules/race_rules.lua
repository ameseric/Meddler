


--everything maps to race.phys[attribute] = race.phys[attribute] + attribute.effects[] For every effects
--yeah, that'll probably never be clear to anyone besides me

--[[

	packaging format assumes a few things
		1) If value is a number, then it's the cost
		2) If value is a key pair with value of number, then it's a stat change (+/-)
		3) If value is a key pair with value of function, then it's a battle or other effect

]]

local a = {}


	a.Head = {

		Build = {
			Normal = 	{ 0 }
			,Chest = 	{ 2 , Defense = 1 }
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
			,Multi_Eyed =	{ 2 , Will=1 }
			,No_Mouth = 	{ 2 , Upkeep=-0.25 }
			,Multi_Headed=	{ 2 , Upkeep=0.25 , Projection=3 }
			,Blind = 		{ 1 , Will=1 , Attack=-1 }
			,Horned = 		{ 3 , Projection=1 , Attack=1 }
		}
	}
	

	a.Torso = {

		Base = {
			Skin = 		{ 0 }
			,Fur = 		{ 2 , Defense=1 }
			,Scale = 	{ 3 , Defense=2 }
			,Arthropod= { 4 , Defense=3 }
			--,Bone = 	{ ??? }
			--,Slime = 	{}
			--,Mineral = 	{}

		}

		,Build = {
			Thin = 		{ 1 , Move=1 , Attack=-1 }
			,Medium = 	{ 0 }
			,Large = 	{ 1 , Move=-1 , Attack=1 }
		}

		,Modifier = {
			None = {0}
			,Musuclar = 	{ 1 , Attack=1 }
			,Segmented = 	{ 1 , Move=1 }
			,Anorexic = 		{ 1 , Defense=-1 , Attack=-1 , Projection=1 , Will=1 }
		}
	}


	a.Limbs = {

		Build = {
			Short = { 2 , Profile=-1 , Skill=-1 }
			,Medium = { 0 }
			,Long = { 2 , Profile=1 , Skill=1 }
			,None = { 0 , Profile=-3 , Attack=0 , Move=-1 }
		}

		,Base = {
			Humanoid = { 0 }
			,Segmented = { 3 , Skill=1 , Attack=1 }
			,Boneless = { 2 , Attack=-1 }
		}

		,Tip = {
			--Claws = {  }
			--,Pincers = {  }
			Digits = { 0 }
		}

		,Modifier = {
			None = { 0 }
			,Multi_Armed = { 3 , Attack=2 }
			,Multi_Legged = { 3 , Move=2 }
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

	a.Mental = {

		Build = {
			Zealous 	= { Boldness=2 }
			,Relaxed 	= { Industry=-1 , Reproduction=2 }
			,Greedy 	= { Upkeep=-1 , Industry=1 }
			,Focused 	= { Reproduction=-1 , Industry=2 }
			,Pious 		= { Order=2 , Boldness=-1 }
			,Reserved 	= { Upkeep=-1 }
		}
	}


	a.Cultural = {

		Build = { --Social
			Sacrificial = { sac={desc="Increases Eminence gained and halves Order penalty for Take-Life."} }
			,Caste 		= { a={desc="All Order penalties halved."} }
			,Scholars 	= { a={desc="Upgrades cheaper?"} }
			,Nomadic 	= { building_move={desc="Buildings can move 1 tile per turn."} }
			,Militant 	= { a={desc="10% military stat increase, Heavy units available at Towns."} }
		}

		,Aesthetic = {
			Hive		= { a={desc="Large central mound structure."} }
			,Frontier	= { a={desc="Scattering of smaller wood dwellings, generally used by explorers."} }
			,Imperial	= { a={desc="Similar to Frontier, but uses more stone. Later structures are soley stone."} }
			,Etheral	= { a={desc="Allows construction of mages at all buildings."} }
			,Natural	= { a={desc="No stone or wood upkeep."} }
			,Hallow		= { a={desc="Give bonuses to undead races, or those that practice magic."} }
			
		}

		--,Biome = {

	}


local race_rules = {}

--packaging of the above table for actual use, especially GUI consumption
for k , body_part in pairs( a ) do
	race_rules[ k ] = {}
	for category , choices in pairs( body_part ) do
		race_rules[ k ][ category ] = {}
		for choice , values in pairs( choices ) do			
			local temp = { cost=0 , effects={} , traits={} , name="" }
			temp.name = choice			


			for key , value in pairs( values ) do

				if type( key ) == 'number' then
					temp.cost = value

				elseif type( value ) == 'number' then
					temp.effects[ key ] = value

				else
					temp.traits[ key ] = value
				end
			end

			if not temp.cost then temp.cost = 0 end

			table.insert( race_rules[ k ][ category ] , temp )

		end
	end
end



return race_rules