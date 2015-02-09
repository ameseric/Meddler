--[[
	Main object file for races created by Meddlers.
]]

race = {
	--/ Globals
	name = "Precursor"
	,order = 0
	,boldness = 0
	,industry = 0
	,reproduction = 0
	,upkeep = 0

	--/ Created during race creation 
--[[
	,life = 0
	,head = 0
	,mind = 0
	,upper_limb = 0
	,torso = 0
	,lower_limb = 0
--]]

}

--[[ Sample stats input

stats = {	
	name = "Sample"
	,order = 4
	,boldness = 1
	
	...

	life = { value=2 }
	,head = { value=3 , sprite1=normal , sprite2=horned }
	,torse = { value=2 , sprite1=thin , sprite2=segmented }
	,etc
}

]]

function race:new( stats )
	local o  = {}
	setmetatable( o , self )
	self.__index = self

	if type(stats) == 'number' then
		generate_random_race( stats )
	end


	for category , wrapper in pairs( stats ) do
		if type( category ) == 'table' then
			o[ category ] = {}
			for type , value in pairs( wrappers ) do
				o[ category ][ type ] = value
			end

		else
			o[ category ] = wrapper
		end
	end

	return o

end
---=== Helpers =======
	function generate_random_race( point_value )
		local temp_stats = {}

	end




return race