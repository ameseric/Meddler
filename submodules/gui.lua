--GUI object file, submodule

gui = {
	gui_image = nil
	,selected_tile = false
	,tile = nil
	,tile_x = 0
	,tile_y = 0
	,tileset = nil
}

function gui:setup( gui_image , tileset , width , height )
	self.gui_image = gui_image
	self.tileset = tileset

	self.x_draw_point = width/5  --(width/4)
	self.y_draw_point = ((height/12) * 9)
end

function gui:draw( scale )
	love.graphics.draw( self.gui_image , self.x_draw_point , self.y_draw_point , 0 , 2.5 , 2 )

	if self.selected_tile then
		draw_main_gui( scale )
	end
end
---==== Helpers =====
	function draw_main_gui( scale )
		local x = gui.x_draw_point + gui.x_draw_point*0.1
		local y = gui.y_draw_point + ((disp.pix_height - gui.y_draw_point) * 0.1 )

		draw_tile_img_in_gui( x , y )
		draw_tile_select( scale )

		set_color( 'black' ); set_font( font_large )

		draw_main_gui_text( x , y )

		set_color('white'); set_font( font_med )
	end
	--====== Helpers ======
		function draw_tile_img_in_gui( x , y )
			local quad = rules:get_quad( gui.tile.type )
			love.graphics.draw( gui.tileset , quad , x , y , 0 , 2 , 2 )
		end
		function draw_tile_select( scale ) 
			love.graphics.rectangle( 'line' , gui.tile_x - disp.x_pix_pos , gui.tile_y - disp.y_pix_pos ,
												 TS*scale , TS*scale )
		end
		function draw_main_gui_text( x , y )
			y = y + gui.y_draw_point*0.1
			lprint( gui.tile.type , x , y )

			y = y + gui.y_draw_point*0.05
			lprint( gui.tile.move_cost .. " move cost" , x , y )

			y = y + gui.y_draw_point*0.05
			lprint( "+"..gui.tile.rate.." "..gui.tile.resource , x , y )
		end






function gui:select( tile , x , y )
	self.tile_x = x
	self.tile_y = y

	if self.tile == tile then
		self.selected_tile = not self.selected_tile
	else
		self.selected_tile = true
		self.tile = tile
	end
end






return gui