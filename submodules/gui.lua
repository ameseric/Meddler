--GUI object file, submodule

gui = {
	gui_image = nil
	,selected_tile = false
	,tile = nil
	,tileset = nil
}

function gui:setup( gui_image , tileset , width , height )
	self.gui_image = gui_image
	self.tileset = tileset

	self.x_draw_point = width/5  --(width/4)
	self.y_draw_point = ((height/12) * 9)
end

function gui:draw()
	love.graphics.draw( self.gui_image , self.x_draw_point , self.y_draw_point , 0 , 2.5 , 2 )

	if self.selected_tile then
		self:draw_main_gui()
	end
end
---==== Helpers =====
	function gui:draw_main_gui()
		local x = self.x_draw_point + self.x_draw_point*0.1
		local y = self.y_draw_point + ((disp.pix_height - self.y_draw_point) * 0.1 )

		local quad = rules:get_quad( self.tile.type )
		love.graphics.draw( self.tileset , quad , x , y , 0 , 2 , 2 )

		set_color( 'black' ); set_font( font_large )

		y = y + self.y_draw_point*0.1
		lprint( self.tile.type , x , y )

		y = y + self.y_draw_point*0.05
		lprint( self.tile.move_cost .. " move cost" , x , y )

		y = y + self.y_draw_point*0.05
		lprint( "+"..self.tile.rate.." "..self.tile.resource , x , y )

		set_color('white'); set_font( font_med )
	end



function gui:select( tile )
	self.selected_tile = not self.selected_tile
	self.tile = tile
end






return gui