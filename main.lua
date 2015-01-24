 
--[[
	Author: Eric Ames
	Created: December 8th, 2014
	Last Updated: January 2014

	Main love-lua file for Project Meddler

--]]

--===== Globals =========
	TS = 32
	disp = {}

	local img_dir = "images/"
	local world_width , world_height = 100 , 100
	local scale = 2
	local setting_game_options , loading_game , name_entered , first_confirmation , second_confirmation , temp_str
	local txt_input , reading_keys = "" , false
	local player_turn = false
	local turn_count = 0
	local npc_list = {}

	package.path = package.path .. ';Meddler/submodules/?.lua' .. ';Meddler/loader_modules/?.lua'



--========== Core Love Functions ===============

function love.load()							--initial values and files to load for gameplay

	setup_flags()

	load_libraries()
	disp:setup( scale )
	load_images()
	standard_setup() --includes world creation and font settings

	if loading_game then
		--load_game()
	else
		set_new_game() --this includes world gen, which will have to be moved for player
						--setup options later...
	end

end
--=== Helpers =====
	function load_libraries()
		rules = require 'tile_rules';
		genesis = require "genesis";	meddler = require "meddler"
		atlas 	= require "atlas";
		tile 	= require "tile"
		disp 	= require "display"
	end

	function load_images()
		local natural_tiles = love.graphics.newImage( img_dir.."natural_tiles.png" )
		natural_tiles:setFilter( 'nearest' )
		atlas:set_batch( natural_tiles , (disp.tile_height+2) * (disp.tile_width+2) ) --extra 2 for buffer to show partial tiles
	end

	function standard_setup()
		--Random Settings (global fonts )
		font_large = love.graphics.setNewFont( 25 )
		font_med = love.graphics.setNewFont( 18 )
		love.keyboard.setKeyRepeat( true )
	end

	function set_new_game()
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

	function setup_flags()
		for i , v in ipairs( arg ) do
			if v == '-d' or '--debug' then _debug = true
			elseif v == '-ng' or '--newgame' then print("Not implemented!")
			end
		end
	end




function love.draw()
	if setting_game_options then
		draw_player_options()

	else
		atlas:draw()
		if _debug then debug_GUI() end
		lprint( "Turn: "..turn_count , disp.pix_width - (disp.pix_width/10) , 50 )
	end
end
--==== Helpers =======
	function draw_player_options( option )
		
		set_color( 'grey' )

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





function love.update( dt )


	if setting_game_options then
		update_setup_flags()

	else
		local build = disp:move()
		if not player_turn then
			npcs_turn()
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
--=== Helpers =====
	function update_setup_flags()
		if second_confirmation then
			first_confirmation = false; second_confirmation = false
			name_entered = true
			print( temp_str )
		end

		if name_entered then --and other stuff, later
			setting_game_options = false;
			reading_keys = false
			player_turn = true
		end
	end--[[
	function player_turn()
		--list_options
		--get_input
		--resolve_actions
		
	end--]]
	function npcs_turn()
		for k,v in pairs( npc_list ) do
			print( v.name )
		end
	end
	function time_passes() --might want to have a seperate object for time passing...
								--easier to iterate through? Like a manager?
		--races_turn_by_ini()
		natural_events()
	end
		function natural_events()
			for i,row in ipairs( atlas.world ) do
				for j,tilee in ipairs( row ) do
					tilee:time_passes()
				end
			end
		end

	function update_turn_stats()
		turn_count = turn_count + 1
	end






--========= Keyboard and Mouse IO ===============
function love.keypressed(key, isrepeat) --might actually needs to move subs into seperate 'text processing'
	if _debug then print( key ) end

	if reading_keys then --for text input
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

	else --for game controls
		if key == '-' and scale > 1 then
			change_scale( scale * -0.5 )
		elseif key == '=' and scale < 4 then
			change_scale( scale )
		elseif key == 'return' and player_turn then
			player_turn = false
		end
	end	
end
--=== Helpers ====
	function change_scale( num )
		scale = scale + num
		disp:update_scale( scale )
		atlas:update_scale( scale )
	end
	function love.textinput( t )
		txt_input = txt_input .. t
	end

function love.mousepressed( x , y , button )
end

function love.mousereleased( x , y , button )
	
end






--========== Utility Functions ================
	function debug_GUI()
		lprint("FPS: "..love.timer.getFPS(), 10, 20)
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
		elseif R == 'grey' then
			love.graphics.setColor( 200 , 200 , 200 , G )
		else
			love.graphics.setColor( R , G , B , A )
		end
	end

	function set_font( font ) love.graphics.setFont( font ) end

	function lprint( text , x , y ) love.graphics.print( text , x , y ) end







