--building/structure object for Meddlers

local structure = {
	health = 0
	,type = 'None'
	,x = 0
	,y = 0
	,order = nil
}


function structure:new( type , tile )
	local s = {}
	setmetatable( s , self )
	self.__index = self

	for field , values in pairs( struct_rules[ type ] ) do
		s[field] = {}
		for k , v in pairs( values ) do
			s[field][k] = v
		end
	end

	s.type = type
	s.tile = tile
	s:update_tile()

	return s
end

function structure:update()
	-- check order countdown
	-- if complete, execute order.




function structure:give_command( command )
	if self.order then
		return false
	else
		self.order = command
		return true
	end
end

function structure:

function structure:can_create( unit_type )
	for i,v in ipairs( self.units ) do
		if v == unit_type then
			return true
		end
	end
end

function structure:damage( value )
	self.health = self.health - value
end
function structure:heal( value )
	self.health = self.health + value
end

function structure:update_tile()
	self.tile = self.type
end

function structure:is_dead()
	return health <= 0
end

function structure:location()
	return self.x , self.y
end

function structure:tile()
	return atlas:get_tile( x , y )
end


return structure