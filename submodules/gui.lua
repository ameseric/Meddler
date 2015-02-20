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

	self.x_create_life = (width/4)
	self.y_create_life = (height/8)*7

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

function gui:draw( scale , list_of_powers , name , eminence )

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

	if __:is_player_turn() then
		self:draw_player_options( list_of_powers , turn_action_flags )
	end

	if __:making_race() then
		self:draw_race_creation()
	end

end

--=====/ Additional Draws /=====
	function gui:draw_player_options( list_of_powers )
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

		if __:choosing_trees() then
			if __:top_layer() then text = "Choices"
			elseif __.in_givetree() then text = "Give"
			elseif __.in_taketree() then text = "Take"
			elseif __.in_altertree() then text = "Alter"
			end
		else
			text = "Powers"
		end

		set_color( 'grey' ); set_font( font_large )
		if __:choosing_trees() then
			if __:top_layer() then
				lprint( 'Give: g' , gui.x_choices , gui.y_draw_point + gui.margin*7 )
				lprint( 'Take: t' , gui.x_choices , gui.y_draw_point + gui.margin*10 )
				lprint( 'Alter: a' , gui.x_choices , gui.y_draw_point + gui.margin*13 )
			elseif __:in_givetree() then
				lprint( 'Life: l' , gui.x_choices , gui.y_draw_point + gui.margin*7 )
				lprint( 'Blessing: b' , gui.x_choices , gui.y_draw_point + gui.margin*10 )
				--lprint( 'Alter: a' , gui.x_choices , gui.y_draw_point + gui.margin*10 )
			elseif __:in_taketree() then
				lprint( 'Life: l' , gui.x_choices , gui.y_draw_point + gui.margin*7 )
				lprint( 'Blessing: b' , gui.x_choices , gui.y_draw_point + gui.margin*10 )
				lprint( 'Land: g' , gui.x_choices , gui.y_draw_point + gui.margin*13 )
			elseif __:in_altertree() then
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


	function gui:draw_race_creation()
		set_color( 'grey' )
		love.graphics.rectangle( 'fill' , self.x_create_life , 30 , self.x_create_life*2 , self.y_create_life )
		set_color( 'white' )

		local x = self.x_create_life + self.margin
		local y = self.y_create_life / 7
		local race = __:get_race()

		local xmod = (x*2)/14

		local x_1 = x + xmod*1
		local x_2 = x + xmod*2
		local x_3 = x + xmod*3
		local x_5 = x + xmod*5
		local x_8 = x + xmod*8

		if __:race_treetop() then
			lprint( "New Race Creation" , x_5 , y*1 )
			lprint( "(1) Name" , x , y*1.5 )					
			lprint( "(2) Physical Characteristics" , x , y*2 )
			lprint( "(3) Mental Characteristics " , x , y*2.5 )
			lprint( "(4) Cultural Aspect" , x , y*3 )

			lprint( "Name: "..race.name , x_3 , y*4 );	lprint( "Cost: "..race.cost , x+xmod*7 , y*4 )
			local draw_order = { "break","Attack","Defense","Projection","Will","Move","Profile","Skill","break","Industry","Reproduction",
						"Boldness","Upkeep","Order","break","Mental","Cultural","Head","Torso","Limbs" }
			self:draw_toplevel_overview( race , x , y , draw_order , xmod )

		elseif __:making_race_name() then
			x = self.x_create_life + self.margin*6
			keystrokes:set( "Enter Name: " , x_5 , y*3.5 , font_med )

		else
			local name = "None"
			local names = {}
			local option_draw = {}

			local choices = { _phys_head='Head' , _phys_torso='Torso' , _phys_limbs='Limbs' , _cultural='Cultural' , _mental='Mental' }
			local choice = __:case( choices )

			if choice then
				option_draw = race_rules[ choice ]
				name = choice
			else
				option_draw[1] = race.config.Head;
				option_draw[2] = race.config.Torso;
				option_draw[3] = race.config.Limbs;
				names = { "Heads" , "Torso" , "Limbs" }
			end
			choice , choices = nil , nil


			if #names > 2 then --top menu selecton, Head/Torso/Limbs
				local num = 1

				for i , body_part_categories in ipairs( option_draw ) do
					set_font( font_title )
					lprint( "("..i..") "..names[i] , x , y*num )
					num = num + 0.3
					for category , choice in pairs( body_part_categories ) do
						set_font( font_med )
						lprint( category..": "..choice.name , x_2 , y*num )
						num = num + 0.2
					end
					num = num + 0.6
				end

			else
				y = self.y_create_life / 20
				local count = 2
				local alpha_count = 0

				set_font( font_large )
				lprint( name , x , y*count )
				count = count + 1

				for category , choices in pairs( option_draw ) do
					set_font( font_med )
					lprint( category , x_1 , y*count )
					count = count + 0.6

					for i , choice in ipairs( choices ) do
						set_font( font_small )

						if race.config[ name ][ category ].name == choice.name then
							set_color( 'green' ); set_font( font_med )
						end

						lprint( "("..alpha_shift( i+alpha_count )..") "..choice.name , x_2 , y*count )
						set_font( font_small ); set_color( 'white' )

						local chain = choice.cost.." Cost | "
						local inc = 0
						for key , value in pairs( choice.effects ) do
							if value < 1 and value > -1 then
								value = value * 100
								value = tostring( value )..'%'
							elseif value >= 1 then
								value = '+'..tostring( value )
							end
							chain = chain .. value .. " " .. key .. '/ '

						end
						for key , value in pairs( choice.traits ) do
							chain = chain .. '\n' .. value.desc
							inc = inc + 0.6
						end

						lprint( chain , x_5 , y*count )
						count = count + 0.6 + inc
					end
					alpha_count = alpha_count + #choices
				end
			end

		end
	end

	--=====/ Helpers /=========
		function gui:draw_toplevel_overview( race , x , y , draw_order , xmod )
			local x_header , x_value , y_overview
			local x_count , y_count = 1 , 1
			for i , name in ipairs( draw_order ) do

				if name == 'break' then
					x_header = x + xmod*x_count
					x_value = x + xmod*(x_count+2.2)
					y_overview = y*4.25
					y_count = 1
					x_count = x_count + 3.5

				else
					set_color( 'white' );
					lprint( name..": " , x_header , y_overview )
					set_color( 'green')
					if race.config[ name ] then
						local limb = race.config[name]
						if limb.Base then
							lprint( limb.Base.name.." / "..limb.Build.name , x_value , y_overview )
						else
							lprint( limb.Build.name , x_value , y_overview )
						end
					else
						lprint( race[ name ] , x_value , y_overview )
					end
					y_count = y_count + 1
					y_overview = y*(4+(0.25*y_count))
				end
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