--[[
	Main object file for races created by Meddlers.
]]

local race = {
	--/ Globals
	name = "Precursor"
	,food = 10
	,wood = 10
	,stone = 10
	,upkeep_base = { food=10,stone=2,wood=2 } --+5 food per unit, +2 stone&wood per settlement?
	--/ Created during race creation

}

--[[ Sample stats input

config = {	
	name = "None"
	,cost = 0
	,config = {
		Head = { Build={ cost=0 , name="Normal" } , Modifier={ cost=0 , name="None" } }
		,Torso = { Base={ cost=0 , name="Skin"} , Build={ cost=0,name="Medium"} , Modifier={cost=0,name="None"} }
		,Limbs = { Build={cost=0,name="Medium"} , Base={cost=0,name="Humanoid"} , Modifier={cost=0,name="None"} , Tip={cost=0,name="Digits"} }
		,Mental = { Build={ name="Zealous" , cost=0 , effects={Boldness=2} } }
		,Cultural = { Build={ name="Sacrificial" , cost=0} }
	}

	,traits = {}

	,Attack = 1
	,Defense = 1
	,Projection = 1
	,Will = 1
	,Move = 3
	,Profile = 1
	,Skill = 1

	,Industry = 1
	,Boldness = 0
	,Order = 0
	,Reproduction = 0
	,Upkeep = 0

	,head_sprite = nil
	,limb_sprite = nil
	,torso_sprite = nil
}

]]

function race:new( config , tile )
	local o  = {}
	setmetatable( o , self )
	self.__index = self

	if type(config) == 'number' then
		generate_random_race( config )
	end


	o.unit_sprite = images.unit_sprites
	o.buildings = {}
	o.military = {}
	o.citizens = {}

	for category , wrapper in pairs( config ) do
		o[ category ] = wrapper
	end
	config = nil

	o:new_structure( 'Village' , tile )
	o.buildings[1]:give_command( {type='Citizen' , force=true , num=3} )

	return o
end
---=== Helpers =======
	function generate_random_race( point_value )
		local temp_stats = {}

	end

function race:get_name()
	return self.name
end

function race:new_structure( type , tile )
	table.insert( self.buildings , structure:new( type , tile ) )
end

function race:draw()
	for k,v in pairs( military ) do
		v:draw()
	end
end

function race:update() --main AI logic block

	check_structure_orders()

	local threats = check_for_threats() --check 10 tile radius around all structures, 4 around all units
	if threats then
		assign_military_orders( threats )
	end

	assign_building_projects() --consider adding exploration projects for citizens/calvary units

	local resource_lock = false
	assign_unit_production( resource_lock )

	update_units()

	return
end

--======/ Helpers /=======
	function race:check_structure_orders()
		for i , building in ipairs( self.buildings ) do
			building:update()
		end
	end

	function race:check_for_threats()
		--TODO
	end

	function race:assign_military_orders( threats )

		for i,unit in ipairs( self.military ) do
			local min_distance = SOME_NUMBER------------------------------
			local chosen_threat = nil
			for i,threat in ipairs( threats ) do


				local distance = check_distance( unit , threat )
				if distance < min_distance then

					min_distance = distance
					chosen_threat = threat
				end
			end

			unit:give_command( {type='attack',target=chosen_threat} )
		end
	end

	function race:assign_building_projects()

		local sbp = get_structure_build_priority( #self.citizens )

		for i,build in ipairs( sbp ) do
			for i,citizen in ipairs( self.citizens ) do
				if citizen:give_command( {type='build',target=build} ) then --if citizen accepts command, then move on
					break
				end
			end
		end
	end
	--======/ Helpers /=========
		function race:get_structure_build_priority( num )
			local sbp = {}

			for k,v in pairs( self.upkeep_base ) do
				if v*2 > self[ k ] then
					table.insert( sbp , k )  --stone/food/wood
				end
			end

			if #sbp >= num then return sbp end --don't have enough citizens to continue

			--decide logic for military/town/temple building
			--boldness/reproduction/order?

			return sbp
		end


	function race:assign_unit_production() --TODO

		local ubp = get_unit_build_priority()  --based on how many turns active, boldness, reproduction

		for i,unit in ipairs( ubp ) do
			for i,structure in ipairs( self.buildings ) do
				if structure:give_command( {type='build',target=unit} ) then --if citizen accepts command, then move on
					break
				end
			end
		end
	end

	--===/ Helper /======
		function race:get_unit_build_priority()
			--TODO
		end




return race