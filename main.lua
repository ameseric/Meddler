 
--[[
	Author: Eric Ames
	Created: December 8th, 2014
	Last Updated: January 2014

	Main love-lua file for Project Meddler

--]]

--===== Globals =========
	TS = 32
	disp = {}

	local img_dir , sound_dir = "images/" , "sounds/"
	local world_width , world_height = 100 , 100
	local scale = 2
	local setting_game_options , loading_game , name_entered , first_confirmation , second_confirmation , temp_str
	local txt_input , reading_keys = "" , false
	local turn_count = 0
	local npc_list , sounds = {} , {}
	local player = nil

	player_turn = false

	top_layer , give_tree , take_tree , alter_tree = true , false , false , false --be careful, global state flags!

	package.path = package.path .. ';Meddler/submodules/?.lua' .. ';Meddler/loader_modules/?.lua'



--========== Core Love Functions ===============



--=== Helpers =====
	local function load_libraries()
		rules = require 'tile_rules';	--race_rules = require 'race_rules'
		genesis = require "genesis";	meddler = require "meddler"
		atlas 	= require "atlas";		--race = require 'race'
		tiles 	= require "tile";
		disp 	= require "display"
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
	local function setup_environment()

		load_images()
		load_sounds()

		--Random Settings (global fonts )
		font_title = love.graphics.setNewFont( 32 )
		font_large = love.graphics.setNewFont( 26 )
		font_med = love.graphics.setNewFont( 22 )
		font_small = love.graphics.setNewFont( 18 )
		love.keyboard.setKeyRepeat( true )
	end


	local function set_new_game()
		setting_game_options = true
		reading_keys = true

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

	local function setup_flags()
		for i , v in ipairs( arg ) do
			if v == '-d' or '--debug' then _debug = true
			elseif v == '-ng' or '--newgame' then print("Not implemented!")
			end
		end
	end

function love.load()							--initial values and files to load for gameplay
	setup_flags()
	load_libraries()
	disp:setup( scale )
	setup_environment() --load images , sounds , and fonts

	if loading_game then
		--load_game()
	else
		set_new_game() --this includes world gen, which will have to be moved for player
						--setup options later...
	end
end



--==== Helpers =======
	function draw_player_options()
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
function love.draw()
	if setting_game_options then
		draw_player_options()

	else
		atlas:draw( scale )
		display:draw_gui( scale )
		if _debug then debug_GUI() end
		lprint( "Turn: "..turn_count , disp.pix_width - (disp.pix_width/10) , 50 )
	end
end





--=== Helpers =====
	local function update_setup_flags()
		if second_confirmation then
			first_confirmation = false; second_confirmation = false
			name_entered = true
			print( temp_str )
		end

		if name_entered then --and other stuff, later
			setting_game_options = false
			reading_keys = false
			just_started_game = true
			player_turn = true
			player = meddler:new( true , temp_str )
		end
	end--[[
	function player_turn()
		--list_options
		--get_input
		--resolve_actions
		
	end--]]
	local function npcs_turn()
		for k,v in pairs( npc_list ) do
			print( v.name )
		end
	end
	--==== Helpers ====
			local function natural_events()
				for i,row in ipairs( atlas.world ) do
					for j,tile in ipairs( row ) do
						tile:time_passes()
					end
				end
			end
	---------------------
	local function time_passes()
		--races_turn_by_ini()
		natural_events()
	end

	local function update_turn_stats()
		turn_count = turn_count + 1
	end
-----------------------
function love.update( dt )


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
end






--========= Keyboard and Mouse IO ===============
--=== Helpers ====
	local function change_scale( num )
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
	local function change_tree_flags( t , l )
		if t == 'g' then
			give_tree = true
			alter_tree = false
			take_tree = false
			top_layer = false
		elseif t == 't' then
			give_tree = false
			take_tree = true
			alter_tree = false
			top_layer = false
		elseif t == 'a' then
			give_tree = false
			take_tree = false
			alter_tree = true
			top_layer = false
		elseif t == 'back' then
			give_tree =  false
			take_tree = false
			alter_tree = false
			top_layer = true
		end
	end
	local function end_player_turn()
		player_turn = false
		change_tree_flags( 'back' )
	end

function love.keypressed(key, isrepeat) --might actually needs to move subs into seperate 'text processing'
	if _debug then print( key ) end

	if reading_keys then --for text input
		process_text_keys( key )

	elseif player_turn then
		if key == '-' and scale > 1 then
			change_scale( scale * -0.5 )
		elseif key == '=' and scale < 4 then
			change_scale( scale )

		elseif key == 'return' and player_turn then
			player_turn = false
		elseif top_layer then
			change_tree_flags( key )
		elseif (give_tree or take_tree or alter_tree) then
			if (key == 'n' or key == 'esc' or key == 'backspace') then
				change_tree_flags( 'back' )
			elseif give_tree then
				if key == 'l' or key == 'b' then
					end_player_turn()
					--if key == 'l' then create_race()
					--elseif key == 'b' then bless() end
				end
			elseif take_tree then
				if key == 'l' or key == 'b' or key == 'g' then
					end_player_turn()
					--if key == 'l' then sacrifice()
					--elseif key == 'b' then curse()
					--elseif key == 'g' then take_land() end
				end
			elseif alter_tree then
				if key == 'l' or key == 'g' or key == 'a' then
					end_player_turn()
					--if key == 'l' then change_life()
					--elseif key == 'g' then change_land()
					--elseif key == 'a' then change_law()
					--end
				end
			end
		end
	end	
end


function love.mousepressed( x , y , button )
		
	if is_button then
		--stuff
	else
		local tile , x , y = atlas:get_tile( x , y , 'translate' )
		disp:gui_select( tile , ttp(x) , ttp(y)  )
	end
end

function love.mousereleased( x , y , button )
	
end






--========== Utility Functions ================
	function debug_GUI()
		lprint("FPS: "..love.timer.getFPS(), 10, 20)
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







