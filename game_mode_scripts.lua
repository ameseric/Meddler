
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
	function ngs:update_setup_flags()

		if keystrokes:finished() then
			in_new_game_options = false
			just_started_game = true
			player_turn = true
			in_game_actual = true
		end
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


	function gs:draw( scale , player , race_creation_flags )
		set_color( 'white' );
		atlas:draw( scale )
		disp:draw_gui( scale , player , race_creation_flags )
		if _debug then debug_GUI() end
	end

	function gs:update()
		--npcs_turn()
		self:time_passes()
		self:update_turn_stats()
	end

	function gs:keypress( key , scale , player , selected_tile , race_creation_flags )
		local is_player_done = false
		local rcf = race_creation_flags


		if rcf._status then
			self:race_creation_keytree( rcf , key )

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
				choices = not choices

			elseif top_layer() then
				change_tree_flags( key )
			elseif not top_layer() then
				if is_escape_key( key ) then
					change_tree_flags( 'back' )
				else
					is_player_done = powers:resolve( key , selected_tile , player , race_creation_flags )
				end
			end
		end


		if is_player_done then
			end_player_turn()
		end
	end

	--====/ Helpers /=========
		function gs:race_creation_keytree( rcf , key )
			if rcf._toplevel then

				if key == '1' then
					toggle( true , rcf , {"_name","_toplevel"} )
					keystrokes:start_reading()
				end

				toggle( is_escape_key( key ) , rcf , {"_status" , "_toplevel"} )
				toggle( key=='2' , rcf , {"_phys_top" , "_toplevel"} )
				toggle( key=='3' , rcf , {"_mental" , "_toplevel"} )
				toggle( key=='4' , rcf , {"_cultural" , "_toplevel"} )

			elseif rcf._name then
				--doesn't matter, keypress will grab it.

			elseif rcf._phys_top then
				toggle( is_escape_key( key ) , rcf , {"_toplevel" , "_phys_top"} )
				toggle( key == '1' , rcf , {"_phys_head" , "_phys_top"} )
				toggle( key == '2' , rcf , {"_phys_torso" ,  "_phys_top"} )
				toggle( key == '3' , rcf , {"_phys_limbs" ,  "_phys_top"} )

			elseif rcf._phys_head then				
				toggle( is_escape_key( key ) , rcf , {"_phys_head" , "_phys_top"} )
				self:get_option( key , rcf , 'Head' )

			elseif rcf._phys_limbs then
				toggle( is_escape_key( key ) , rcf , {"_phys_top" , "_phys_limbs"} )
				self:get_option( key , rcf , 'Limbs' )

			elseif rcf._phys_torso then
				toggle( is_escape_key( key ) , rcf , {"_phys_top" , "_phys_torso"})
				self:get_option( key , rcf , 'Torso' )

			elseif rcf._mental then
				toggle( is_escape_key( key ) , rcf , {"_mental" , "_toplevel"})
				self:get_option( key , rcf , "Mental" )

			elseif rcf._cultural then
				toggle( is_escape_key( key ) , rcf , {"_cultural" , "_toplevel"})
				self:get_option( key , rcf , "Cultural" )

			end
		end

		--=====/ Helpers /===============
			function gs:get_option( key , rcf , limb )
				key = alpha_shift( key )
				local offset = 0
				if key then
					for i,j in pairs( race_rules[ limb ] ) do
						if key > offset and key <= (#j+offset) then
							rcf.race.config[ limb ][ i ] = j[key-offset]

							for k,v in pairs( rcf.race.config[ limb ][i] ) do
								print( k , v )
							end

						end
						offset = offset + #j
					end
				end

			end


return { sss=sss , ngo=ngs , ga=gs }