--[[ 
	Attempt at a state machine object, of dubious quality.
]]

local flags = { 

--race_creation_flags
	race = {}
	,_race_status = false
	,_race_toplevel = false
	,_race_name = false
	,_mental = false
	,_cultural = false
	,_phys_top = false
	,_phys_head = false
	,_phys_torso = false
	,_phys_limbs = false
	,_race_finished = true

 --turn_action_flags
	,_givetree = false
	,_taketree = false
	,_altertree = false

--game_flags
	,_player_turn = false
	,_in_start_screen = false
	,_in_game_actual = false
	,_in_new_game_options = false
	,_choice = true
	,_loading_game = false
	,_just_started_game = false
}


sm = {}

--====/ General Helpers /===========
	function sm:toggle( switch , flag_names , set )
		if switch then
			for i , flag_name in ipairs( flag_names ) do
				if set == true or set == false then
					flags[ flag_name ] = set
				else
					flags[ flag_name ] = not flags[ flag_name ]
				end
			end
		end
	end

	function sm:case( flag_calls )
		for flag_name , call in pairs( flag_calls ) do
			if flags[ flag_name ] then
				if type( call ) == 'function' then
					return call() , flag_name
				else
					return call , flag_name
				end
			end
		end
		return false
	end


--=====/ Main Game Flags /==========
	--====/ Checks /======
	function sm:top_layer() return not ( flags._givetree or flags._altertree or flags._taketree ) end
	function sm:at_start_screen() return flags._in_start_screen end
	function sm:at_new_game_options() return flags._in_new_game_options end
	function sm:at_game_actual() return flags._in_game_actual end
	function sm.is_player_turn() return flags._player_turn and flags._in_game_actual end
	function sm:in_givetree() return flags._givetree end
	function sm:in_altertree() return flags._altertree end
	function sm:in_taketree() return flags._taketree end
	function sm:choosing_trees() return flags._choice end


	--=====/ Toggles /=====
	function sm:start_game() flags._in_start_screen = true end
	function sm:change_tree_flags( t )
		if not t then return end
		self:toggle( t=="escape" , {"_givetree",'_altertree','_taketree'} , false )
		self:toggle( t=='g' , {"_givetree"} )
		self:toggle( t=='t' , {"_taketree"} )
		self:toggle( t=='a' , {"_altertree"} )
	end

	function sm:end_player_turn()
		flags._player_turn = false
		self:change_tree_flags( 'escape' )
	end

	function sm:just_started()
		local temp = flags._just_started_game
		self:toggle( temp , {'_just_started_game'} )
		return temp
	end

	function sm:toggle_choice() self:toggle( true , {'_choice'} ) end
	function sm:start_player_turn() flags._player_turn = true end
	function sm:start_screen_to_new_game() self:toggle( true , {'_in_new_game_options' , '_in_start_screen'} ) end
	function sm:new_game_to_game_actual() self:toggle( true , {'_in_new_game_options','_just_started_game','_player_turn','_in_game_actual'} ) end




--=====/  Race Switches /=========
	--=====/ Checks /=======
	function sm:get_race() return flags.race end
	function sm:race_cost() return flags.race.cost end
	function sm:making_race() return flags._race_status end
	function sm:making_race_name() return flags._race_name end
	function sm:finished_making_race() return flags._race_status and flags._race_finished end
	function sm:race_treetop() return flags._race_toplevel end
	--====/ Toggles /=======
	function sm:set_race_name()
		flags.race.name = keystrokes:get_strokes()
		keystrokes:ack()
		self:toggle( true , {"_race_toplevel","_race_name"} )
	end

	function sm:stop_making_race()
		self:toggle( true , {'_race_toplevel','_race_status'} )
	end

	function sm:start_making_race( race )
		self:toggle( true , {'_race_status','_race_toplevel','_race_finished'})
		flags.race = race
	end

	function sm:race_creation_keytree( key )
		if flags._race_toplevel then
			if key == '1' then
				self:toggle( true , {"_race_name","_race_toplevel"} )
				keystrokes:start_reading()
			end
			self:toggle( key=='2' , {"_phys_top" , "_race_toplevel"} )
			self:toggle( key=='3' , {"_mental" , "_race_toplevel"} )
			self:toggle( key=='4' , {"_cultural" , "_race_toplevel"} )
			self:toggle( key=='return' , {'_race_finished'} )
			self:toggle( is_escape_key( key ) , {"_race_status" , "_race_toplevel" , '_race_finished'} )

		elseif flags._race_name then
			--doesn't matter, keypress will grab it.

		elseif flags._phys_top then
			self:toggle( is_escape_key( key ) , {"_race_toplevel" , "_phys_top"} )
			self:toggle( key == '1' , {"_phys_head" , "_phys_top"} )
			self:toggle( key == '2' , {"_phys_torso" ,  "_phys_top"} )
			self:toggle( key == '3' , {"_phys_limbs" ,  "_phys_top"} )

		elseif flags._phys_head then				
			self:toggle( is_escape_key( key ) , {"_phys_head" , "_phys_top"} )
			return 'Head'

		elseif flags._phys_limbs then
			self:toggle( is_escape_key( key ) , {"_phys_top" , "_phys_limbs"} )
			return 'Limbs'

		elseif flags._phys_torso then
			self:toggle( is_escape_key( key ) , {"_phys_top" , "_phys_torso"})
			return 'Torso'

		elseif flags._mental then
			self:toggle( is_escape_key( key ) , {"_mental" , "_race_toplevel"})
			return 'Mental'

		elseif flags._cultural then
			self:toggle( is_escape_key( key ) , {"_cultural" , "_race_toplevel"})
			return 'Cultural'

		end
	end


return sm