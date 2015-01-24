--[[
	Main object file for races created by Meddlers.
]]

race = {
	name = "Precursor"
	,life = 0
	,upper_limb = 0
	,torso = 0
	,mind = 0
	,head = 0
	,lower_limb = 0
}


function race:new( stats )
	local o  = {}
	setmetatable( o , self )
	self.__index = self

	if not stats then
		generate_random_race( o )
	else
		for k,v in pairs( stats ) do
			o[ k ] = v
		end
	end
end
---=== Helpers =======
	function generate_random_race( o )
		





return race