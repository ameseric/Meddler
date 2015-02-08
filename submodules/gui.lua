--GUI object file, submodule

gui = {
	gui_image = nil
	,selected_tile = false
	,tile = nil
	,tile_x = 0
	,tile_y = 0
	,tileset = nil
	,message_log = {}
}

function gui:setup( gui_image , tileset , width , height )
	self.gui_image = gui_image
	self.tileset = tileset

	self.x_draw_point = width/8  --(width/4)
	self.y_draw_point = ((height/12) * 9)
	
	self.margin = (disp.pix_height - gui.y_draw_point) * 0.05

	self.x_tile_info = 	self.x_draw_point + self.x_draw_point * 0.4
	self.x_choices = 	self.x_draw_point * 3.75
	self.x_unit_info = 	self.x_draw_point * 6

	self.x_create_life = (width/3)
	self.y_create_life = (height/3)*2

end



---==== Helpers =====
	--====== Helpers ======
		local function draw_tile_img_in_gui( x , y )
			local quad = rules:get_quad( gui.tile.type )
			set_color( 'white' )
			love.graphics.draw( gui.tileset , quad , x , y , 0 , 2.8*window_factor , 2.8*window_factor )
		end
		local function draw_tile_select( scale )
			set_color( 'white' )
			love.graphics.rectangle( 'line' , gui.tile_x - disp.x_pix_pos , gui.tile_y - disp.y_pix_pos ,
												 TS*scale , TS*scale )
		end
		local function draw_main_gui_text( x )
			lprint( gui.tile.type , x , gui.y_draw_point + gui.margin * 10 )
			lprint( gui.tile.move_cost .. " move cost" , x , gui.y_draw_point + gui.margin * 12 )
			lprint( "+"..gui.tile.rate.." "..gui.tile.resource , x , gui.y_draw_point + gui.margin * 14 )
		end
	local function draw_tile_info( scale )
		draw_tile_img_in_gui( gui.x_tile_info , gui.y_draw_point + gui.margin*4 )
		draw_tile_select( scale )

		set_color( 'black' ); set_font( font_med )
		draw_main_gui_text( gui.x_tile_info )
	end

	local function draw_dialogue()
		set_color( 255 , 255 , 255 , 100 )
		--love.graphics.rectangle( 'fill' , 0 , gui.margin*6 , gui.x_draw_point*1.5 , gui.y_draw_point*0.5 )

		set_color( 'white' ); set_font( font_small );
		local size = #gui.message_log
		for i=1,9 do
			local message = gui.message_log[ i ]
			if message then
				lprint( gui.message_log[ size-i+1 ] , 20 , (gui.margin*6)+(40 * i) )
			end
		end
	end

	local function draw_player_options( list_of_powers )
		local text = ""

		if not list_of_powers then
			list_of_powers = {}
		end
		local diff = 4 - #list_of_powers
		if diff ~= 0 then
			for i=1,diff do
				table.insert( list_of_powers , "None" )
			end
		end

		if choices then
			if top_layer then text = "Choices"
			elseif give_tree then text = "Give"
			elseif take_tree then text = "Take"
			elseif alter_tree then text = "Alter"
			end
		else
			text = "Powers"
		end

		set_font( font_title ); set_color( "black" );
		--lprint( text , gui.x_choices , gui.y_draw_point + gui.margin*4 )
		set_color( 'grey' ); set_font( font_large )

		if choices then
			if top_layer() then
				lprint( 'Give: g' , gui.x_choices , gui.y_draw_point + gui.margin*7 )
				lprint( 'Take: t' , gui.x_choices , gui.y_draw_point + gui.margin*10 )
				lprint( 'Alter: a' , gui.x_choices , gui.y_draw_point + gui.margin*13 )
			elseif give_tree then
				lprint( 'Life: l' , gui.x_choices , gui.y_draw_point + gui.margin*7 )
				lprint( 'Blessing: b' , gui.x_choices , gui.y_draw_point + gui.margin*10 )
				--lprint( 'Alter: a' , gui.x_choices , gui.y_draw_point + gui.margin*10 )
			elseif take_tree then
				lprint( 'Life: l' , gui.x_choices , gui.y_draw_point + gui.margin*7 )
				lprint( 'Blessing: b' , gui.x_choices , gui.y_draw_point + gui.margin*10 )
				lprint( 'Land: g' , gui.x_choices , gui.y_draw_point + gui.margin*13 )
			elseif alter_tree then
				lprint( 'Life: l' , gui.x_choices , gui.y_draw_point + gui.margin*7 )
				lprint( 'Land: g' , gui.x_choices , gui.y_draw_point + gui.margin*10 )
				lprint( 'Law: a' , gui.x_choices , gui.y_draw_point + gui.margin*13 )
			end
		else
			for i,v in ipairs( list_of_powers ) do
				lprint( i..") "..v , gui.x_choices , gui.y_draw_point + gui.margin*((i*3)+4) )
			end
		end

		set_color( 'white' ); set_font( font_med )
	end

function gui:draw( scale , list_of_powers , name , eminence , race_creation_flags )
	local rcf = race_creation_flags

	love.graphics.draw( self.gui_image , self.x_draw_point , self.y_draw_point , 0 , 4*window_factor , 2.7*window_factor )
	set_font( font_med )
	lprint( "Turn: "..turn_count , 10 , 10 )
	lprint( "Eminence: "..eminence , 10 , 30 )
	draw_dialogue()

	set_font( font_title ); set_color( 'black' )
	lprint( name , self.x_choices , self.y_draw_point+4 )

	if self.selected_tile then
		draw_tile_info( scale )
	end

	if player_turn then
		draw_player_options( list_of_powers )
	end

	if rcf._status then
		self:draw_race_creation( rcf )
	end

end



function gui:draw_race_creation( race_creation_flags )
	local rcf = race_creation_flags

	set_color( 'grey' )
	love.graphics.rectangle( 'fill' , self.x_create_life , 30 , self.x_create_life , self.y_create_life )
	set_color( 'white' )

	if rcf._toplevel then
		local x = self.x_create_life + self.margin
		local y = self.y_create_life / 7

		lprint( "New Race Creation" , x + (x/3) , y*1 )

		lprint( "(1) Name" , x , y*2 );						lprint( rcf.race.name , x + (x/1.5) , y*2 )
		lprint( "(2) Physical Characteristics" , x , y*3 );	--lprint( race.)
		lprint( "(3) Mental Characteristics " , x , y*4 );	lprint( rcf.race.mental , x + (x/1.5) , y*4 )
		lprint( "(4) Cultural Aspect" , x , y*5 );			lprint( rcf.race.culture , x+(x/1.5) , y*5 )

	elseif rcf._toplevel then
		--stuff
	elseif rcf._phys then
		--stuff
	elseif rcf._mental then
		--stuff
	elseif rcf._cultural then
		--final stuff
	end
end


function gui:add_dialogue( text )
	table.insert( self.message_log , text )
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