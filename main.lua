
--[[
	Author: Eric Ames
	Created: December 8th, 2014
	Last Updated: January 2014

	Main love-lua file for Project Meddler

--]]

--===== Globals =========
	TS = 32
	window_factor = 0.75
	disp = {}

	local world_width , world_height = 100 , 100
	local img_dir , sound_dir , save_dir = "images/" , "sounds/" , "../saves"
	local scale = 2


	--State Flags
	player_turn = false
	in_start_screen , in_game_actual , in_new_game_options = false , false , false
	give_tree , take_tree , alter_tree = false , false , false --be careful, global state flags!
	choices = true
	creating_race , creating_race_top_level , creating_race_name , creating_race_mental , creating_race_cultural = false , false , false , false , false
	txt_input , reading_keys = "" , false

	setting_game_options , loading_game , name_entered = false , false , false
	first_confirmation , second_confirmation , temp_str = false , false , false



	--World objects
	race_being_created = {}
	local selected_tile = nil
	local player = nil
	npc_list , sounds = {} , {}


	turn_count = 0
	package.path = package.path .. ';Meddler/submodules/?.lua' .. ';Meddler/loader_modules/?.lua'



--========== Core Love Functions ===============



--=== Helpers =====
	local function load_libraries()
		rules = require 'tile_rules';	--race_rules = require 'race_rules'
		genesis = require "genesis";	meddler = require "meddler"
		atlas 	= require "atlas";		--race = require 'race'
		tiles 	= require "tile";		powers = require "powers"
		disp 	= require "display"

		wrapper = require "game_mode_scripts"
		start_screen = wrapper.sss;
		ngo = wrapper.ngo;
		game_actual = wrapper.ga
	end

	--==== Helpers ======
		local function load_images()
			local natural_tiles = love.graphics.newImage( img_dir.."natural_tiles.png" )
			natural_tiles:setFilter( 'nearest' )
			atlas:set_batch( natural_tiles , (disp.tile_height+2) * (disp.tile_width+2) ) --extra 2 for buffer to show partial tiles

			local gui_image = love.graphics.newImage( img_dir.."main_gui.png" )
			gui_image:setFilter( 'nearest' )
			display:setup_gui( gui_image , natural_tiles )
		end

		local function load_sounds()
			sounds.bgm = love.audio.newSource( sound_dir.."rolling_hills.mp3" , "stream" )
		end
	local function load_environment()

		load_images()
		load_sounds()

		font_title = love.graphics.setNewFont( 	44 * window_factor )
		font_large = love.graphics.setNewFont( 	36 * window_factor )
		font_med = love.graphics.setNewFont( 	28 * window_factor )
		font_small = love.graphics.setNewFont( 	24 * window_factor )

		love.keyboard.setKeyRepeat( true )
	end

	local function setup_run_flags()
		for i , v in ipairs( arg ) do
			if v == '-d' or '--debug' then _debug = true
			elseif v == '-ng' or '--newgame' then print("Not implemented!")
			end
		end
	end

function love.load()							--initial values and files to load for gameplay
	setup_run_flags()
	load_libraries()
	disp:setup( scale )
	load_environment() --load images , sounds , and fonts

	in_start_screen = true

end


function love.update( dt )


--[[
	if setting_game_options then
		update_setup_flags()

	else
		if just_started_game then
			love.audio.play( sounds.bgm )
			just_started_game = false
		end

		local build = disp:move()

		if not player_turn then
			--npcs_turn()
			time_passes()
			update_turn_stats()
			player_turn = true
			build = true
		end

		if build then
			atlas:build_batch()
		end

	end
--]]

	if in_start_screen then
		--start_screen:update_flags()

	elseif in_new_game_options then
		if not reading_keys then read_keys( true ) end

		ngo:update_setup_flags()

		if name_entered then
			player = meddler:new( true , temp_str )
			ngo:set_new_game( world_width , world_height , scale )
			print( player.name )
			read_keys( false )
		end

	elseif in_game_actual then

		if just_started_game then
			love.audio.play( sounds.bgm )
			just_started_game = false
		end

		local build = disp:move()

		if not player_turn then			
			game_actual:update()
			player_turn = true
			build = true
		end

		if build then
			atlas:build_batch()
		end

	end

end



function love.draw()

--[[
	if setting_game_options then
		draw_player_options()

	else
		set_color( 'white' );
		atlas:draw( scale )
		display:draw_gui( scale , player , race_being_created )
		if _debug then debug_GUI() end
		--lprint( "Turn: "..turn_count , disp.pix_width - (disp.pix_width/10) , 50 )
	end
--]]

	if in_start_screen then
		set_color( 'grey' ); set_font( font_title )
		start_screen:draw()

	elseif in_new_game_options then
		ngo:draw()

	elseif in_game_actual then
		game_actual:draw( scale , player , race_being_created )

	end


end






--========= Keyboard and Mouse IO ===============
	--=== Helpers ====
		function change_scale( num )
			disp:update_scale( scale , scale + num )
			scale = scale + num
			atlas:update_scale()
		end
		function love.textinput( t )
			txt_input = txt_input .. t
		end
		local function process_text_keys( key )
			if key == 'backspace' then
				txt_input = txt_input:sub( 0 , #txt_input-1 )
			elseif key == 'return' then
				first_confirmation = true
				temp_str = txt_input
				txt_input = ""
			elseif first_confirmation then
				if key == 'y' then
					second_confirmation = true
				elseif key == 'n' then
					first_confirmation = false
					txt_input = temp_str
				end
			end	
		end



	function love.keypressed( key , isrepeat ) --might actually needs to move subs into seperate 'text processing'
		if _debug then print( key ) end

		if reading_keys then
			process_text_keys( key )
		else

			if in_start_screen then
				if key == 'n' then
					in_start_screen = false;
					in_new_game_options = true;
				elseif key == 'nope' then
					in_start_screen = false
					load_game()
					in_game_actual = true
				end

			elseif in_new_game_options then
				--nothing

			elseif in_game_actual and player_turn then
				game_actual:keypress( key , scale )
			end

		end
	end


	function love.mousepressed( x , y , button )
		pressed_x = x; 	pressed_y = y --used for calculating display movement off of mouse press / distance

		if in_start_screen then
			--stuff

		elseif in_new_game_options then
			--stuff

		elseif in_game_actual then
			if creating_race then
				pressed_y = nil; pressed_x = nil
			end
		end

--[[
		if creating_race then
			pressed_x = nil; pressed_y = nil;
			disp:check_gui_buttons( x , y , button )
		end
--]]

	end

	function love.mousereleased( x , y , button )
		pressed_x = nil; pressed_y = nil;

		if in_start_screen then
			--stuff

		elseif in_new_game_options then
			--stuff

		elseif in_game_actual then
			local tile , x , y = atlas:get_tile( x , y , 'translate' )
			disp:gui_select( tile , ttp(x) , ttp(y)  )

			if tile == selected_tile then
				selected_tile = nil
			else
				selected_tile = tile
			end

		end
	end


--========== State Flag Functions =============
	--These need to be global in order for sub-modules to change flags if needed.

	function top_layer()
		return not give_tree and not alter_tree and not take_tree
	end

	function change_tree_flags( t , l )
		if t == 'g' then
			give_tree = true
			alter_tree = false
			take_tree = false
		elseif t == 't' then
			give_tree = false
			take_tree = true
			alter_tree = false
		elseif t == 'a' then
			give_tree = false
			take_tree = false
			alter_tree = true
		elseif t == 'back' then
			give_tree =  false
			take_tree = false
			alter_tree = false
		end
	end

	function end_player_turn()
		player_turn = false
		change_tree_flags( 'back' )
	end


--========== Utility Functions ================
	function debug_GUI()
		lprint("FPS: "..love.timer.getFPS(), 500, 20)
	end

	function tile_to_pixel( unit ) 
		return unit * TS * scale
	end

	function ttp( unit )
		return tile_to_pixel( unit )
	end

	function pixel_to_tile( unit ) 
		return math.floor( unit / (TS*scale) )
	end

	function ptt( unit )
		return pixel_to_tile( unit )
	end

	function dialogue( text )
		disp:gui_dialogue( text )
	end

	function read_keys( value )
		reading_keys = value
		temp_str = ""
		txt_input = ""
	end


--========= Love Wrapper Functions ===================
	function timestamp() return love.timer.getTime() end

	function set_color( R , G , B , A )
		if R == 'white' then
			love.graphics.setColor( 255 , 255 , 255 , G )
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







