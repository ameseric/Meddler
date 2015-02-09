--[[

	Module for race units.
]]


unit = {
	
	life = 0
	,head = 0
	,mind = 0
	,upper_limb = 0
	,torse = 0
	,lower_limb = 0

	,race = nil

}



function unit:new( race , type )
	local u = {}
	setmetatable( u , self )
	self.__index = self

	u.race = race

	for category , wrapper in pairs( race )
		if type( category ) == 'table' then
			u[ category ] = wrapper.value
		end
	end

	generate_unit_stats( type , u )

	return u
end
--======/ Helpers /============
	function unit:generate_unit_stats( type , u )
		if type:match( "infantry" )  then
			u.upper_limb = u.upper_limb + math.floor( u.upper_limb * .2 )

		elseif type:match( "heavy" ) then
			u.torso = u.torso + math.floor( u.torso * 0.2 )

		elseif type:match( "heavy infantry" ) then
			u.lower_limb = u.lower_limb - math.floor( u.lower_limb * 0.4 )

		elseif type:match( "light calvary" ) then
			u.lower_limb = u.lower_limb + math.floor( u.lower_limb * 0.4 )

		elseif type:match( "heavy calvary" ) then
			u.lower_limb = u.lower_limb + math.floor( u.lower_limb * 0.2 )

		end
	end


function unit:draw()
	--No sprite yet, so redundant.
end

return unit