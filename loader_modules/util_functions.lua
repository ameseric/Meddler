--utility function breakdown

	function debug_GUI()
		lprint("FPS: "..love.timer.getFPS(), 500, 20)
	end

	function ttp( unit )
		return tile_to_pixel( unit )
	end
		function tile_to_pixel( unit ) 
			return unit * TS * scale
		end

	function ptt( unit )
		return pixel_to_tile( unit )
	end
		function pixel_to_tile( unit ) 
			return math.floor( unit / (TS*scale) )
		end

	function pwa( x , y )
		return atlas:pixel_wrap_around( x , y )
	end
	function twa( x , y )
		return atlas:tile_wrap_around( x , y )
	end

	function dialogue( text )
		if text == 'lack_emi' then
			text = "Cannot perform action. Not enough eminence."
		elseif text == 'lack_target' then
			text = "Cannot perform action. Lack target."
		end

		disp:gui_dialogue( text )
	end

	function set_fonts()
		font_title = love.graphics.setNewFont( 	44 * window_factor )
		font_large = love.graphics.setNewFont( 	36 * window_factor )
		font_med = love.graphics.setNewFont( 	28 * window_factor )
		font_small = love.graphics.setNewFont( 	24 * window_factor )
	end

	function is_escape_key( key )
		if key == 'escape' or key == 'n' or key == 'q' then
			return 'escape'
		end
		return false
	end

	function configure_screen_settings( perform_disp_setup )
		
		if perform_disp_setup then
			disp:setup( scale , images.gui_image , images.tileset )
		end

		atlas:set_batch( images.tileset , (disp.tile_height+2) * (disp.tile_width+2) ) --extra 2 for buffer to show partial tiles

		if __:at_game_actual() then
			atlas:build_batch()
		end

		set_fonts()
	end

	function alpha_shift( char )
		local chars = {'a','b','c','d','e','f','g','h','i','j','k','l','m','o','p','r','s','t'}

		if type(char) == 'number' then
			return chars[ char ]
		end

		for i,v in ipairs( chars ) do
			if char == v then
				return i
			end
		end
	end

	function percent_inc( value , percent )
		return value + math.floor( value * percent )
	end


	--==========================================


	function timestamp() return love.timer.getTime() end

	function set_color( R , G , B , A )
		if R == 'white' then
			love.graphics.setColor( 240 , 240 , 240 , G )
		elseif R == 'black' then
			love.graphics.setColor( 0 , 0 , 0 , G )
		elseif R == 'green' then
			love.graphics.setColor( 0 , 255 , 0 , G )
		elseif R == 'red' then
			love.graphics.setColor( 255 , 0 , 0 , G )
		elseif R == 'blue' then
			love.graphics.setColor( 0 , 150 , 230 , G )
		elseif R == 'l_grey' then
			love.graphics.setColor( 200 , 200 , 200 , G )
		elseif R == 'grey' then
			love.graphics.setColor( 80 , 80 , 80 , G )
		else
			love.graphics.setColor( R , G , B , A )
		end
	end

	function set_font( font ) love.graphics.setFont( font ) end

	function lprint( text , x , y ) love.graphics.print( text , x , y ) end

	function ldraw( image , x , y , scale_x , scale_y , quad , static , rotation )

		if not static then
			x = x - disp.x_pix_pos
			y = y - disp.y_pix_pos
		end

		x , y = pwa( x , y )

		if quad then
			love.graphics.draw( image , quad , x , y , rotation , scale_x , scale_y )
		else
			love.graphics.draw( image , x , y , rotation , scale_x , scale_y )
		end

	end




	