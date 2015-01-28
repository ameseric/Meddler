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
	
	self.y_margin = (disp.pix_height - gui.y_draw_point) * 0.05

	self.x_tile_info = 	self.x_draw_point + self.x_draw_point * 0.1
	self.x_choices = 	self.x_draw_point * 2.2
	self.x_unit_info = 	self.x_draw_point * 3.4

end



---==== Helpers =====
	--====== Helpers ======
		local function draw_tile_img_in_gui( x , y )
			local quad = rules:get_quad( gui.tile.type )
			love.graphics.draw( gui.tileset , quad , x , y , 0 , 2 , 2 )
		end
		local function draw_tile_select( scale ) 
			love.graphics.rectangle( 'line' , gui.tile_x - disp.x_pix_pos , gui.tile_y - disp.y_pix_pos ,
												 TS*scale , TS*scale )
		end
		local function draw_main_gui_text( x )
			lprint( gui.tile.type , x , gui.y_draw_point + gui.y_margin * 10 )
			lprint( gui.tile.move_cost .. " move cost" , x , gui.y_draw_point + gui.y_margin * 12 )
			lprint( "+"..gui.tile.rate.." "..gui.tile.resource , x , gui.y_draw_point + gui.y_margin * 14 )
		end
	local function draw_tile_info( scale )
		draw_tile_img_in_gui( gui.x_tile_info , gui.y_draw_point + gui.y_margin*4 )
		draw_tile_select( scale )

		set_color( 'black' ); set_font( font_med )
		draw_main_gui_text( gui.x_tile_info )
		set_color('white'); --set_font( font_small )
	end
	local function draw_player_options()
		local text = ""
		if top_layer then text = "Choices"
		elseif give_tree then text = "Give"
		elseif take_tree then text = "Take"
		elseif alter_tree then text = "Alter"
		end

		set_font( font_title ); set_color( "black" );
		lprint( text , gui.x_choices , gui.y_draw_point + gui.y_margin )
		set_color( 'grey' ); set_font( font_large )


		if top_layer then
			lprint( 'Give: g' , gui.x_choices , gui.y_draw_point + gui.y_margin*5 )
			lprint( 'Take: t' , gui.x_choices , gui.y_draw_point + gui.y_margin*8 )
			lprint( 'Alter: a' , gui.x_choices , gui.y_draw_point + gui.y_margin*11 )
		elseif give_tree then
			lprint( 'Life: l' , gui.x_choices , gui.y_draw_point + gui.y_margin*5 )
			lprint( 'Blessing: b' , gui.x_choices , gui.y_draw_point + gui.y_margin*8 )
			--lprint( 'Alter: a' , gui.x_choices , gui.y_draw_point + gui.y_margin*10 )
		elseif take_tree then
			lprint( 'Life: l' , gui.x_choices , gui.y_draw_point + gui.y_margin*5 )
			lprint( 'Blessing: b' , gui.x_choices , gui.y_draw_point + gui.y_margin*8 )
			lprint( 'Land: g' , gui.x_choices , gui.y_draw_point + gui.y_margin*11 )
		elseif alter_tree then
			lprint( 'Life: l' , gui.x_choices , gui.y_draw_point + gui.y_margin*5 )
			lprint( 'Land: g' , gui.x_choices , gui.y_draw_point + gui.y_margin*8 )
			lprint( 'Law: a' , gui.x_choices , gui.y_draw_point + gui.y_margin*11 )
		end


		set_color( 'white' ); set_font( font_med )
	end

function gui:draw( scale )
	love.graphics.draw( self.gui_image , self.x_draw_point , self.y_draw_point , 0 , 2.5 , 2 )

	if self.selected_tile then
		draw_tile_info( scale )
	end

	if player_turn then
		draw_player_options()
	end

end





function gui:draw_race_creation()
	love.graphics.rectangle( 'fill' , 500 , 500 , 800 , 800 )
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