
--[[
	Going to try holding the three game states here, that is
		Starting Screen
		New Game Options
		Game Actual

]]


--start_screen_scripts
sss = {}
--========/ Start Screen Scripts /===========
	function sss:draw()
		lprint( "Temporary Start Screen" , 500 , 500 )
		lprint( "New Game: N" , 500 , 550 )
		lprint( "Load Game: L" , 500 , 600 )
	end

	sss.name = "start_screen_scripts"





--new_game_scripts
ngs = {}
ngs.name = "new_game_scripts"
--========/ New Game Option Scripts /===========
	function ngs:update_setup_flags()
		if second_confirmation then
			first_confirmation = false; second_confirmation = false
			name_entered = true
			print( temp_str )
		end

		if name_entered then --and other stuff, later
			in_new_game_options = false
			just_started_game = true
			player_turn = true
			in_game_actual = true
		end

		--return in_new_game_options , just_started_game , player_turn , in_game_actual

	end


	function ngs:set_new_game( world_width , world_height , scale )
		--World Creation
		math.randomseed( os.time() )	--set pseudo-random seed value for map generation
		local world = genesis:create( world_width , world_height )
		atlas:set_world( world , world_width , world_height , scale )
		atlas:build_batch()

		--NPCs
		local num_of_npcs = 3
		for i = 1,num_of_npcs+1 do
			local med = meddler:new()
			npc_list[ med.name ] = med
		end
	end


	function ngs:draw()
		set_color( 'l_grey' )

		if not name_entered then
			if first_confirmation and not second_confirmation then
				lprint( "Enter Meddler Name: " .. temp_str , 500 , 500 )
				lprint( "Confirm name choice [y/n]? " .. txt_input , 500 , 600 )
			else
				lprint( "Enter Meddler Name: " .. txt_input , 500 , 500 )
			end
		end

		set_color( 'white' )
	end






--game_scripts
gs = {}
gs.name = "game_actual_scripts"
--========/ Game Actual Scripts /===========
	function gs:npcs_turn()
		for k,v in pairs( npc_list ) do
			print( v.name )
		end
	end


	function gs:natural_events()
		for i,row in ipairs( atlas.world ) do
			for j,tile in ipairs( row ) do
				tile:time_passes()
			end
		end
	end


	function gs:time_passes()
		--races_turn_by_ini()
		self:natural_events()
	end



	function gs:update_turn_stats()
		turn_count = turn_count + 1
	end


	function gs:draw( scale , player , race_being_created )
		set_color( 'white' );
		atlas:draw( scale )
		display:draw_gui( scale , player , race_being_created )
		if _debug then debug_GUI() end
	end

	function gs:update()
		--npcs_turn()
		self:time_passes()
		self:update_turn_stats()
	end

	function gs:keypress( key , scale )
		local is_player_done = false

		if key == '-' and scale > 1 then
			change_scale( scale * -0.5 )
		elseif key == '=' and scale < 4 then
			change_scale( scale )

		elseif key == ']' and window_factor < 1 then
			window_factor = window_factor + 0.25
			configure_screen_settings()
			atlas:build_batch()
		elseif key == '[' and window_factor > 0.25 then
			window_factor = window_factor - 0.25
			configure_screen_settings()
			atlas:build_batch()

		elseif key == 'p' then
			choices = not choices

		elseif top_layer() then
			change_tree_flags( key )
		elseif not top_layer() then
			if (key == 'n' or key == 'esc' or key == 'backspace') then
				change_tree_flags( 'back' )
			else
				is_player_done = powers:resolve( key , selected_tile , player )
			end
		end



		if is_player_done then
			end_player_turn()
		end
	end






return { sss=sss , ngo=ngs , ga=gs }