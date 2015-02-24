--building/structure object for Meddlers

local structure = {
	life = 0
	,type = 'None'
	,order = nil
	,x=0
	,y=0
}


function structure:new( struct_type , tile , race )
	local s = {}
	setmetatable( s , self )
	self.__index = self

	for field , values in pairs( struct_rules:get( struct_type ) ) do
		s[field] = {}

		if type( values ) == 'table' then
			for k , v in pairs( values ) do
				s[field][k] = v
			end
		else
			s[field] = values
		end
	end

	s.type = struct_type
	s.x = tile.x
	s.y = tile.y
	s.race = race
	atlas:set_tile( 'Plain' , s.x , s.y , s )

	return s
end

function structure:update()
	local command = self.order

	if command then
		if command.type == 'build' then
			command.timer = command.timer - 1
			if command.timer <= 0 then
				self:spawn_unit( command.target , command.num )
				self.order = nil
			end
		end
	end

end

function structure:draw()
	ldraw( images.structures , ttp(self.x) , ttp(self.y) 
				, scale , scale , struct_rules:get_quad( self.type ) )
end

function structure:spawn_unit( type , num )

	local adj_tiles = scout:get_adj_tiles( self.x , self.y )

	if adj_tiles then
		local spawn_point = adj_tiles[1]
		local new_unit = unit:new( self.race , type , spawn_point )

		spawn_point:set_ocpied( new_unit )
		self.race:add_unit( new_unit )
		dialogue( "Created new "..type.." for "..self.race.meddler.name.."!")
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

function structure:kill()
	atlas:set_tile( 'Desolate' , self.x , self.y , 'clear' )
end

function structure:is_dead()
	return life <= 0
end

function structure:tile()
	return atlas:get_tile( self.x , self.y )
end


return structure