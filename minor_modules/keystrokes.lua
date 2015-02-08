--[[

	Test module for separating keystroke functions/parameters

]]


local strokes = ""
local reading_keys = false
local first_confirmation = false
local second_confirmation = false
local temp_strokes = ""

local function clear( full_clear )
	first_confirmation = false
	second_confirmation = false
	reading_keys = false

	if full_clear then
		strokes = ""
		temp_strokes = ""
	end
end

keystrokes = {
	message = ""
	,x = 0
	,y = 0
}



function keystrokes:draw()
	set_color( 'white' ); set_font( font_title );

	if first_confirmation then
		lprint( self.message..temp_strokes , self.x , self.y )
		lprint( "Confirm? [y/n]" , self.x , self.y + 100 )
	else
		lprint( self.message..strokes , self.x , self.y )
	end
end

function keystrokes:add( t )
	strokes = strokes .. t
end

function keystrokes:start_reading( message , x , y )
	clear( true )
	reading_keys = true

	if message then self.message = message
	else self.message = "Text entered: "
	end

	if x then self.x = x
	else self.x = 0
	end

	if y then self.y = y
	else self.y = 0
	end

end

function keystrokes:stop_reading()
	clear( false )
end

function keystrokes:are_reading()
	return reading_keys
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

function keystrokes:get_temp()
	return temp_strokes
end

function keystrokes:get_strokes()
	return strokes
end

function keystrokes:finished()
	return first_confirmation and second_confirmation
end




return keystrokes
