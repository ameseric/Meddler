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
	,_finished = true

 --turn_action_flags
	,_give_tree = false
	,_take_tree = false
	,_alter_tree = false

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



	function top_layer()
		local taf = turn_action_flags
		return not ( taf._givetree or taf._altertree or taf._taketree )
	end

	function change_tree_flags( t )
		local taf = turn_action_flags
		toggle( t=="n" , taf , {"_givetree",'_altertree','_taketree'} , false )
		toggle( t=='g' , taf , {"_givetree"} )
		toggle( t=='t' , taf , {"_taketree"} )
		toggle( t=='a' , taf , {"_altertree"} )
	end

	function end_player_turn()
		game_flags._player_turn = false
		change_tree_flags( 'n' )
	end





function sm:get_race() return flags.race end

function sm:at_start_screen() return flags._in_start_screen end

function sm:at_new_game_options() return flags._in_new_game_options end

function sm:at_game_actual() return flags._in_game_actual end

function sm:just_started()
	local temp = flags._just_started_game
	self:toggle( temp , {'_just_started_game'} )
	return temp
end

function sm.is_player_turn() return flags._player_turn and flags._in_game_actual end

function sm:making_race() return flags._race_status end

function sm:start_player_turn()
	flags._player_turn = true
end

function sm:start_screen_to_new()
	toggle( true , {'_in_new_game_options' , '_in_start_screen'} )
end










