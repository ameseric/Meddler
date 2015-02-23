
--[[
	Author: Eric Ames
	Created: December 8th, 2014
	Last Updated: January 2014

	Main love-lua file for Project Meddler

--]]

--=========/ Globals /=========
	TS = 32
	window_factor = 0.75

	local world_width , world_height = 100 , 100
	scale = 2

	--World objects
	list_of_current_races = {}
	local selected_tile = nil
	local player = nil
	npc_list , sounds , images = {} , {} , {}


	turn_count = 0
	package.path = package.path .. ';Meddler/submodules/?.lua' .. ';Meddler/loader_modules/?.lua' .. ';Meddler/minor_modules/?.lua'



--========== Core Love Functions ===============

	--=== Helpers =====
		local function load_libraries()
			--=== Primary Modules ====
			meddler 		= require "meddler"
			atlas 			= require "atlas";
			tiles 			= require "tile";
			disp 			= require "display";
			wrapper 		= require "game_mode_scripts"
			race 			= require 'race'
			--unit			= require 'unit'
			start_screen 	= wrapper.sss;
			ngo 			= wrapper.ngo;
			game_actual 	= wrapper.ga

			--=== Minor Modules ====
			keystrokes 		= require "keystrokes"
			genesis 		= require "genesis";
			powers 			= require "powers"
			race_manager 	= require 'race_manager'
			race_rules 		= require 'race_rules'
			__ 				= require 'state_machine'
			scout 			= require 'pathfinding'
			--structure 		= require 'structure'

			--=== Sub/Loader Modules ====
			rules 			= require 'tile_rules';
			--struct_rules 	= require 'structure_rules'
			--unit_rules		= require 'unit_rules'
			require 'util_functions'
			--gui.lua, display.lua
			--npcs.lua
		end
		local function setup_run_flags()
			for i , v in ipairs( arg ) do
				if v == '-d' or '--debug' then _debug = true
				elseif v == '-ng' or '--newgame' then print("Not implemented!")
				end
			end
		end


	function love.load()				--initial values and files to load for gameplay
		setup_run_flags() 
		load_libraries()

		local wrapper = require 'game_media'
		images , sounds = wrapper.images , wrapper.sounds

		love.keyboard.setKeyRepeat( true )
		configure_screen_settings( true ) --sets display, GUI, and fonts based on current window_factor
		__:start_game()
	end


	function love.update( dt )
		local build

		keystrokes:clear( 'values' ) --only triggers at start of keystrokes

		if __:at_start_screen() then
			--start_screen:update_flags()

		elseif __:at_new_game_options() then
			if not keystrokes:are_reading() and not keystrokes:finished() then 
				keystrokes:start_reading( "Enter Meddler Name: " , 500 , 500 )
			end

			if keystrokes:finished() then
				__:new_game_to_game_actual()
				player = meddler:new( true , keystrokes:get_strokes() )
				ngo:set_new_game( world_width , world_height , scale )
				keystrokes:ack()
			end

		elseif __:at_game_actual() then
			if __:just_started() then love.audio.play( sounds.bgm ) end			
			if __:is_player_turn() then
				game_actual:race_creation_update( player , selected_tile )
				if not __:making_race() then
					build = disp:move()
				end
			
			else
				game_actual:update()
				__:start_player_turn()
				build = true
			end

			if build then
				atlas:build_batch()
			end
		end
	end



	function love.draw()

		if __:at_start_screen() then
			set_color( 'grey' ); set_font( font_title )
			start_screen:draw()

		elseif __:at_new_game_options() then
			--nothing to see here...

		elseif __:at_game_actual() then
			game_actual:draw( scale , player )
		end

		if keystrokes:are_reading() then
			keystrokes:draw()
		end
	end






--========= Keyboard and Mouse IO ===============
	--=== Helpers ====
		function change_scale( num )
			disp:update_scale( scale , scale + num )
			scale = scale + num
			configure_screen_settings()
		end
		function love.textinput( t )
			keystrokes:add( t )
		end

	function love.keypressed( key , isrepeat ) --might actually needs to move subs into seperate 'text processing'
		if _debug then print( key ) end

		if keystrokes:are_reading() then
			keystrokes:process( key )
		else

			if __:at_start_screen() then
				if key == 'n' then
					__:start_screen_to_new_game()
				elseif key == 'nope' then
					--in_start_screen = false
					--load_game()
					--in_game_actual = true
				end

			elseif __:at_new_game_options() then
				--nothing

			elseif __:is_player_turn() then
				game_actual:keypress( key , scale , player , selected_tile )
			end

		end
	end


	function love.mousepressed( x , y , button )
		pressed_x = x; 	pressed_y = y --used for calculating display movement off of mouse press / distance

		if __:at_start_screen() then
			--nothing

		elseif __:at_new_game_options() then
			--nothing

		elseif __:at_game_actual() then
			if __:making_race() then
				pressed_y = nil; pressed_x = nil
			end
		end
	end


	function love.mousereleased( x , y , button )
		pressed_x = nil; pressed_y = nil;

		if __:at_start_screen() then
			--stuff

		elseif __:at_new_game_options() then
			--stuff

		elseif __:at_game_actual() then
			local tile = atlas:get_tile( x , y , 'translate' )
			disp:gui_select( tile )

			if tile == selected_tile then
				selected_tile = nil
			else
				selected_tile = tile
			end

		end
	end







