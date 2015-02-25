--[[
	Main object file for races created by Meddlers.
]]

local race = {
	--/ Globals
	name = "Precursor"
	,food = 10
	,wood = 10
	,mineral = 10
	,upkeep_base = { food=10,mineral=2,wood=2 } --+5 food per unit, +2 mineral&wood per settlement?
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
	,Piety = 0
	,Reproduction = 0
	,Upkeep = 0

	,head_sprite = nil
	,limb_sprite = nil
	,torso_sprite = nil
}

]]

function race:new( config , tile , meddler )
	local o  = {}
	setmetatable( o , self )
	self.__index = self

	o.unit_sprite = images.unit_sprites
	o.buildings = {}
	o.military = {}
	o.citizens = {}
	o.meddler = meddler

	for category , wrapper in pairs( config ) do
		o[ category ] = wrapper
	end
	config = nil

	o:new_structure( 'Village' , tile , o )
	local command = o:format_command( 'build' , 'unit' , 'Citizen' )
	o.buildings[1]:give_command( command )

	return o
end


function race:draw()
	for _,v in ipairs( self.buildings ) do
		v:draw()
	end
	for _,v in ipairs( self.military ) do
		v:draw()
	end
	for _,v in ipairs( self.citizens ) do
		v:draw()
	end
end

function race:get_name()
	return self.name
end

function race:new_structure( type , tile , race )
	table.insert( self.buildings , structure:new( type , tile , race ) )
end

function race:add_unit( unit )
	if unit.type == 'Citizen' then
		table.insert( self.citizens , unit )
	else
		table.insert( self.military , unit )
	end

end

function race:can_afford( resources )
	for res_name,res_value in pairs( resources ) do
		if self[ res_name ] < res_value then
			return false
		end
	end
	return true
end

function race:purchase( resources )
	for res_name,res_value in pairs( resources ) do
		self[ res_name ] = self[ res_name ] - res_value
	end

	return true
end

function race:format_command( command_type , target_type , target )
	local rules

	if target_type == 'unit' then
		rules = unit_rules[ target ]
	elseif target_type == 'structure' then
		rules = struct_rules:get( target )
	end

	return { type=command_type , target=target , cost=rules.cost , timer=rules.timer }
end


function race:update() --main AI logic block

	self:update_structures() --decrement command timers

	--[[
	local threats = check_for_threats() --check 10 tile radius around all structures, 4 around all units
	if threats then
		assign_military_orders( threats )
	end
	--]]

	self:assign_building_projects() --consider adding exploration projects for citizens/calvary units

	local resource_lock = false
	self:assign_unit_production( resource_lock )

	self:update_units()

	return
end

--======/ Helpers /=======
	function race:update_units()
		for _,unit in ipairs( self.military ) do
			unit:update()
		end

		for _,unit in ipairs( self.citizens ) do
			unit:update()
		end
	end

	function race:update_structures()
		for i , building in ipairs( self.buildings ) do
			building:update()
		end
	end

	function race:check_for_threats()
		--TODO
	end

	function race:assign_military_orders( threats )

		for i,unit in ipairs( self.military ) do
			local min_distance = 99--SOME_NUMBER------------------------------
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

		local sbp = self:get_structure_build_priority( #self.citizens )

		for i,build in ipairs( sbp ) do
			if self:can_afford( build.cost ) then
				for i,citizen in ipairs( self.citizens ) do
					if citizen:give_command( build ) then --if citizen accepts command, then move on
						self:purchase( build.cost )
						break
					end
				end
			end
		end
	end
	--======/ Helpers /=========
		function race:get_structure_build_priority( num )
			local sbp = {}
			local key = { mineral='Quarry' , wood='Lumberyard' , food='Farm'}

			for k,v in pairs( self.upkeep_base ) do
				if v*2 > self[ k ] then
					local command = self:format_command( 'build' , 'structure' , key[k] )
					table.insert( sbp , command )
				end
			end

			if #sbp >= num then return sbp end --don't have enough citizens to continue

			--decide logic for military/town/temple building
			--boldness/reproduction/order?

			return sbp
		end


	function race:assign_unit_production() --TODO

		local ubp = self:get_unit_build_priority()  --based on how many turns active, boldness, reproduction

		for i,unit in ipairs( ubp ) do
			for i,structure in ipairs( self.buildings ) do
				if structure:give_command( unit ) then --if citizen accepts command, then move on
					break
				end
			end
		end
	end

	--===/ Helper /======
		function race:get_unit_build_priority()

			local ubp = {}

			for i=1,1 do
				local command = 
					self:format_command( 'build' , 'unit' , 'Citizen' )
				table.insert( ubp , command )
			end

			return ubp			
		end




return race