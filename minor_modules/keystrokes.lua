--[[

	Test module for separating keystroke functions/parameters

]]


local strokes = ""
local reading_keys = false
local first_confirmation = false
local second_confirmation = false
local temp_strokes = ""

keystrokes = {}



function keystrokes:are_reading( value )
	if value == true or value == false then
		if value == true then
			keystrokes:stop_reading() --clears values
		end
		reading_keys = value
	end
	return reading_keys
end

function keystrokes:add( t )
	strokes = strokes .. t
end

function keystrokes:get_strokes()
	return strokes
end

function keystrokes:get_temp()
	return temp_strokes
end

function keystrokes:first_conf()
	return first_confirmation
end

function keystrokes:full_conf()
	return second_confirmation and first_confirmation
end

function keystrokes:stop_reading()
	reading_keys = false
	first_confirmation = false
	second_confirmation = false
	temp_strokes = ""
	strokes = ""
end

function keystrokes:clear( value )
	if value == 'main' then
		strokes = ""
	elseif value == 'temp' then
		temp_strokes = ""
	elseif value == 'both' then
		strokes = ""
		temp_strokes = ""
	end
end

function keystrokes:process( key )
	if key == 'backspace' then
		strokes = strokes:sub( 0 , #strokes-1 )
	elseif key == 'return' then
		first_confirmation = true
		temp_strokes = strokes
		strokes = ""
	elseif first_confirmation then
		if key == 'y' then
			second_confirmation = true
		elseif key == 'n' then
			first_confirmation = false
			strokes = temp_strokes
		end
	end	
end





return keystrokes
