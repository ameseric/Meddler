
--[[
	Class to keep track of the position and size of the game window. Not to be confused with the game world itself, whose
	size is consistent.

	#x_pix_pos
	#y_pix_pos
	#scale

	!setup
	!move
		@in_bounds
	!update_scale
	!x_tile_pos - function of pix pos
	!y_tile_pos - ""

]]


display = {
	x_pix_pos = 0
	,y_pix_pos = 0
}

local gui = require 'gui'


--===== Main Functions =======
	function display:setup( scale )
		local width , height = love.window.getDesktopDimensions()

		width = math.floor( (width / ( TS * scale ))*0.75)
		height = math.floor( (height / ( TS * scale ))*0.75)

		self.tile_width = width
		self.pix_width = tile_to_pixel( width )

		self.tile_height = height
		self.pix_height = tile_to_pixel( height )

		love.window.setMode( self.pix_width , self.pix_height )
	end

	function display:move() --later, add velocity factor. Further over the cursor, faster movement. 1/2/3/4/5
		local x , y = love.mouse.getPosition()
		local step = 4
		local old_x , old_y = self.x_pix_pos , self.y_pix_pos

		if x > (self.pix_width / 6)*5 then
			self.x_pix_pos = self.x_pix_pos + step
		elseif x < (self.pix_width / 6) then
			self.x_pix_pos = self.x_pix_pos - step
		end

		if y > (self.pix_height / 5)*4 then
			self.y_pix_pos = self.y_pix_pos + step
		elseif y < (self.pix_height / 5) then
			self.y_pix_pos = self.y_pix_pos - step
		end

		self:in_bounds()
		return ( old_x - self.x_pix_pos ~= 0 ) or ( old_y - self.y_pix_pos ~= 0 ) --see whether to build spritebatch or not
	end
	--===== Helpers =======
		function display:in_bounds()
			local atlas_width , atlas_height = atlas:world_width_pix() , atlas:world_height_pix()

			if self.x_pix_pos + self.pix_width  > atlas_width then
				self.x_pix_pos = atlas_width - self.pix_width
			elseif self.x_pix_pos < 0 then
				self.x_pix_pos = 0
			end

			if self.y_pix_pos + self.pix_height  > atlas_height then
				self.y_pix_pos = atlas_height - self.pix_height
			elseif self.y_pix_pos < 0 then
				self.y_pix_pos = 0
			end
		end


	function display:update_scale( scale , new_scale )
		local ratio = scale / new_scale
		local delta = new_scale - scale

		self.tile_width = math.ceil( self.tile_width * ratio )
		self.x_pix_pos = ( self.x_pix_pos / ratio ) + ( (1-ratio) * self.pix_width * (1/ratio) * 0.5 ) --want to use old self.pix_(width/height)


		self.tile_height = math.ceil( self.tile_height * ratio )
		self.y_pix_pos = ( self.y_pix_pos / ratio ) + ( (1-ratio) * self.pix_height * (1/ratio) * 0.5 )
	end




--====== GUI calls =========
	function display:setup_gui( gui_main , tileset )
		gui:setup( gui_main , tileset , self.pix_width , self.pix_height )
	end

	function display:draw_gui( scale )
		gui:draw( scale )
	end

	function display:gui_select( tile , x , y )
		gui:select( tile , x , y )
	end




function display:x_tile_pos()
	return pixel_to_tile( self.x_pix_pos )
end
function display:y_tile_pos()
	return pixel_to_tile( self.y_pix_pos )
end



return display