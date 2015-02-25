
--[[
	Map manager/object pertaining to drawing.
	Map functions dealing with time passing and game mechanics
		are not covered here.
]]

atlas = {
	sprite_batch = nil
	,world = {}
}

function atlas:set_world( world , x , y )
	self.world = world
	world = nil
	self.world_width_tile = x
	self.world_height_tile = y

end


function atlas:set_batch( image , num_of_tiles )
	self.sprite_batch = love.graphics.newSpriteBatch( image , num_of_tiles ) --get rid of magic num
end


function atlas:build_batch()
	self.sprite_batch:bind()
	self.sprite_batch:clear()

	for x = -1 , disp.tile_width do --extra 1's are for buffer , partial tiles
		local i = disp:tile_pos( 'x' ) + x

		for y = -1 , disp.tile_height do
			local j = disp:tile_pos( 'y' ) + y
			local k , l = self:tile_wrap_around( i , j )

			local type = self.world[k][l].type
			local quad = rules:get_quad( type )
			self.sprite_batch:add( quad , i*TS , j*TS )
		end
	end
	self.sprite_batch:unbind()
end


function atlas:draw( scale )
	love.graphics.draw( self.sprite_batch , -disp.x_pix_pos , -disp.y_pix_pos , 0 , scale , scale ) --for buffer
end

function atlas:in_bounds( x , y )
	if x and y then
		return x >= 0 and x < self.world_width_tile and y >= 0 and y < self.world_height_tile
	elseif x then
		return x >= 0 and x < self.world_width_tile
	elseif y then
		return y >= 0 and y < self.world_height_tile
	end
end

function atlas:get_tile( x , y , translate_pixel , wrap_tile )

	if translate_pixel then
		x , y = pwa( x + disp.x_pix_pos , y + disp.y_pix_pos )
		x = pixel_to_tile( x )
		y = pixel_to_tile( y )
	end

	if wrap_tile then
		x , y = twa( x , y )
	end

	return self.world[ x ][ y ]
end

function atlas:set_tile( tile_type , x , y , object )
	self.world[x][y] = tiles:new( 'Plain' , x , y )

	if object == 'clear' then
		self.world[x][y]:set_ocpied()

	elseif object then
		self.world[x][y]:set_ocpied( object )
	end
end

function atlas:get_passable( x , y , wrap )
	local tile = self:get_tile( x , y , nil , wrap )
	--print( "Tried to get " , x , y )
	return tile:passable()
end


--===== Helpers ======
	function atlas:world_width_pix()
		return ttp( self.world_width_tile )
	end

	function atlas:world_height_pix()
		return ttp( self.world_height_tile )
	end

	function atlas:tile_wrap_around( x , y )
		local x_limit = self.world_width_tile
		local y_limit = self.world_height_tile

		if x >= x_limit then
			x = x - x_limit
		elseif x < 0 then
			x = x_limit + x
		end

		if y >= y_limit then
			y = y - y_limit
		elseif y < 0 then
			y = y_limit + y
		end

		return x , y
	end

	function atlas:pixel_wrap_around( x , y )
		if x >= self:world_width_pix() then
			x = x - self:world_width_pix()
		elseif x < 0 then
			x = self:world_width_pix() + x
		end		

		if y >= self:world_height_pix() then
			y = y - self:world_height_pix()
		elseif y < 0 then
			y = self:world_height_pix() + y
		end

		return x , y
	end

return atlas






