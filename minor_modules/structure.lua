--building/structure object for Meddlers

local structure = {
	life = 0
	,type = 'None'
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
	s:change_host_tile( self.type )

	return s
end

function structure:update()

	if self.order then
		if self.order.type == 'build unit' then
			command.timer = command.timer - 1
			if command.timer <= 0 then
				spawn_unit( self.order.name , self.order.num )
				self.order = nil
			end
		end
	end

end

function structure:draw()
	ldraw( images.structures , ttp(self.tile.x) , ttp(self.tile.y) 
				,scale , scale , struct_rules:get_quad( self.type ) )
end

function structure:spawn_unit( type , num )

	local adj_tiles = scout:get_adj_tiles( self.tile.x , self.tile.y )

	if adj_tiles then
		local spawn_point = adj_tiles[1]
		local new_unit = unit:new( self.race , type , spawn_point )

		spawn_point:set_ocpied( new_unit )
		self.race:add_unit( new_unit )
		dialogue( "Created new "..type.." for "..self.race.meddler.."!")
		return true
	else
		dialogue( "Couldn't create unit- no free spaces.")
		return false
	end
end


function structure:give_command( command )

	if self.order then
		return false
	elseif command.type == 'build_unit' then
		if self:can_create( command.name ) then
			self.order = command
			command.timer = unit_rules[type].timer
			return true
		end
	else
		self.order = command
		return true
	end

	return false
end

function structure:can_create( unit_type )
	for i,v in ipairs( self.units ) do
		if v == unit_type then
			return true
		end
	end
end

function structure:damage( value )
	self.life = self.life - value
end
function structure:heal( value )
	self.life = self.life + value
end

function structure:change_host_tile( type )
	self.tile = tiles:new( type , self.tile.x , self.tile.y )
end

function structure:kill()
	self:change_host_tile( 'Desolate' )
end

function structure:is_dead()
	return life <= 0
end

function structure:tile()
	return self.tile
end


return structure