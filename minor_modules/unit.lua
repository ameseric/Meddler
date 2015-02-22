--[[

	Module for race units.
]]


local unit = {
	
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

	for category , wrapper in pairs( race ) do
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
			u.attack = percent_inc( u.attack , 0.2 )

		elseif type:match( "heavy" ) then
			u.defense = percent_inc( u.defense , 0.2 )

		elseif type:match( "heavy infantry" ) then
			u.move = percent_inc( u.move , -0.4 )

		elseif type:match( "light calvary" ) then
			u.move = percent_inc( u.move , 0.4 )

		elseif type:match( "heavy calvary" ) then
			u.move = perdcent_inc( u.move , 0.2 )

		end
	end

function unit:give_command( command , override )
	if self.order and not override then
		return false
	else
		self.order = command
		return true
	end
end

function unit:draw()
	--No sprite yet, so redundant.
end

function unit:update()
	--stuff
end

return unit