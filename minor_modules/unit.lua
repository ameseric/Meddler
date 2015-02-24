--[[

	Module for race units.
]]


local unit = {
	
	Life = 1
	,Attack = 0
	,Defense = 0
	,Projection = 0
	,Will = 0
	,Move = 0
	,Profile = 0
	,Skill = 0

	,head_sprite = 0
	,limb_sprite = 0
	,torso_sprite = 0

	,pixel_x = 0
	,pixel_y = 0

	,tile_x = 0
	,tile_y = 0
}



function unit:new( race , type , tile )
	local u = {}
	setmetatable( u , self )
	self.__index = self

	if type ~= 'Citizen' then
		for k,v in pairs( u ) do
			u[k] = race[k]
		end
	end

	u.race = race
	u.type = type
	print( u.type )
	u.pixel_x = ttp( tile.x )
	u.pixel_y = ttp( tile.y )
	u.cost = {}
	self:generate_unit_stats( u )

	return u
end
--======/ Helpers /============
	function unit:generate_unit_stats( u ) --look at unit_rules for values
		
		for category,values in pairs( unit_rules[ u.type ] ) do
			if type(values) == 'table' then
				for value_name,value in pairs( values ) do

					if value < 1 and value > -1 then
						u[ value_name ] = percent_inc( u[value_name] , value )
					elseif category == 'stats' then
						u[ value_name ] = value
					else
						u[ category ][ value_name ] = value
					end

				end
			end
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

function unit:draw()--placeholder, TODO
	ldraw( images.unit_sprites , self.pixel_x , self.pixel_y , scale , scale )
end

function unit:update()
	--need to add "walking" here later, to move by pixel instead of tile
	return end
	--[[
	if self.order then
		if self.order.type == 'attack' then
			local dist = scout:get_distance( self , self.order.target ) --not correct

			if dist == 1 then
				self:attack( self.order.target )
			else
				self:move()
			end

		end
	end
end
--]]
return unit