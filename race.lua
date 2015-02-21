--[[
	Main object file for races created by Meddlers.
]]

race = {
	--/ Globals
	name = "Precursor"
	--/ Created during race creation 
--[[
	,life = 0			//health indicator
	,head = 0			//psychic defense
	,mind = 0			//psychic damage
	,upper_limb = 0		//physical damage
	,torso = 0			//physical defense
	,lower_limb = 0		//movement speed
	,profile = 0		//chance to evade, i.e. fewer physical attacks hit
	,skill = 0			//chance to hit, i.e. more physical attacks inflicted
--]]

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

function race:new( config )
	local o  = {}
	setmetatable( o , self )
	self.__index = self

	if type(config) == 'number' then
		generate_random_race( config )
	end


	for category , wrapper in pairs( config ) do
		o[ category ] = wrapper
	end
	config = nil

	return o
end
---=== Helpers =======
	function generate_random_race( point_value )
		local temp_stats = {}

	end

function race:get_name()
	return self.name
end

function race:genesis( tile )
	self:new_structure( 'city' , tile )
end

function race:new_structure( type , tile )
	--stuff
end

function race:draw()
	print( "Drawing "..self.name )
end

function race:update()
	--stuff
end




return race