
--[[
	Map manager/object pertaining to drawing.
	Map functions dealing with time passing and game mechanics
		are not covered here.
]]

atlas = {
	sprite_batch = nil
	,world = nil
}

function atlas:set_world( world , x , y , scale )
	self.world = world

	self.world_width_tile = x
	self.world_height_tile = y

	self.scale = scale

end


function atlas:set_batch( image , num_of_tiles )
	self.sprite_batch = love.graphics.newSpriteBatch( image , 4000 ) --get rid of magic num
end


function atlas:build_batch()
	self.sprite_batch:bind()
	self.sprite_batch:clear()

	for x = -1 , disp.tile_width do --extra 1's are for buffer , partial tiles
		for y = -1 , disp.tile_height do
			local i = x + disp:x_tile_pos()
			local j = y + disp:y_tile_pos()
			if self:in_bounds( i , j ) then
				local type = self.world[i][j].type
				local quad = rules.total_set[ type ].quad
				self.sprite_batch:add( quad , i*TS , j*TS )
			end
		end
	end
	self.sprite_batch:unbind()
end

function atlas:draw()
	love.graphics.draw( self.sprite_batch , -disp.x_pix_pos , -disp.y_pix_pos , 0 , self.scale , self.scale ) --for buffer
end

function atlas:update_scale( num )
	self.scale = num
	self:build_batch()
end

function atlas:in_bounds( x , y )
	return x >= 0 and x < self.world_width_tile and y >= 0 and y < self.world_height_tile
end


--===== Helpers ======
	function atlas:world_width_pix()
		return self.world_width_tile * TS * self.scale
	end

	function atlas:world_height_pix()
		return self.world_height_tile * TS * self.scale
	end





return atlas