
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
		local x , y  = 

		lprint( "Temporary Start Screen" , 500 , 500 )
		lprint( "New Game: N" , 500 , 550 )
		lprint( "Load Game: L" , 500 , 600 )
	end

	sss.name = "start_screen_scripts"





--new_game_scripts
ngs = {}
ngs.name = "new_game_scripts"
--========/ New Game Option Scripts /===========
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


	function gs:update_turn_stats()
		turn_count = turn_count + 1
	end


	function gs:draw( scale , player )
		set_color( 'white' );
		atlas:draw( scale )
		race_manager:draw()
		disp:draw_gui( scale , player )
		if _debug then debug_GUI() end
	end

	function gs:update()
		race_manager:update()
		self:natural_events()
		self:update_turn_stats()
	end

	function gs:race_creation_update( player , tile )
		if __:making_race_name() and keystrokes:finished() then
			__:set_race_name()

		elseif __:finished_making_race() then
			local temp_race = __:get_race()

			if player:purchase( temp_race.cost ) then
				dialogue( player.name.." has created the race "..temp_race.name.."!" )
				race_manager:add_new_race( temp_race , tile )
				__:stop_making_race()

			else
				dialogue( 'Insufficient eminence to create race. Reduce cost.')
			end
		end
	end

	function gs:keypress( key , scale , player , selected_tile )
		local taken_action = false

		if __:making_race() then
			--self:race_creation_keytree( key )
			local limb_name = __:race_creation_keytree( key )
			if limb_name then
				self:get_option( key , limb_name )
			end

		else
			if key == '-' and scale > 1 then
				change_scale( scale * -0.5 )
			elseif key == '=' and scale < 4 then
				change_scale( scale )

			elseif key == ']' and window_factor < 1 then
				window_factor = window_factor + 0.25
				configure_screen_settings( true )
			elseif key == '[' and window_factor > 0.25 then
				window_factor = window_factor - 0.25
				configure_screen_settings( true )

			elseif key == 'p' then
				__:toggle_choice()

			elseif __:top_layer() then
				__:change_tree_flags( key )
			else
				__:change_tree_flags( is_escape_key(key) )
				__:taken_action = powers:resolve( key , selected_tile , player )
			end
		end


		if __:taken_action() then
			__:end_player_turn()
		end
	end

		--=====/ Helpers /===============
			function gs:get_option( key , limb )
				key = alpha_shift( key )
				local offset = 0
				local race = __:get_race()
				if key then
					for i,j in pairs( race_rules[ limb ] ) do
						if key > offset and key <= (#j+offset) then
							self:update_race( race , j[key-offset] , race.config[limb][i] )
							race.config[ limb ][ i ] = j[key-offset]
						end
						offset = offset + #j
					end
				end
			end

			function gs:update_race( race , new_choice , old_choice )
				race.cost = race.cost + new_choice.cost - old_choice.cost
				print( race.cost , new_choice.cost , old_choice.cost )
				
				if old_choice.effects then
					for k , v in pairs( old_choice.effects ) do
						race[ k ] = race[ k ] - v
						print( k , v )
					end
				end

				for k , v in pairs( new_choice.effects ) do
					race[ k ] = race[ k ] + v
					print( k , v )
				end
			end


return { sss=sss , ngo=ngs , ga=gs }