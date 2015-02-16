--[[

	Test module for separating keystroke functions/parameters

]]


local strokes = ""
local reading_keys = false
local first_confirmation = false
local finished = false
local temp_strokes = ""
local ignore_char = true

local function clear( set )
	
	if set == 'flags' or set == 'both' then
		first_confirmation = false
		reading_keys = false
	end

	if set == 'values' or set == 'both' then
		strokes = ""
		temp_strokes = ""
	end
end

keystrokes = {
	message = ""
	,x = 0
	,y = 0
	,font = nil
}



function keystrokes:draw()
	set_color( 'white' ); set_font( self.font );

	if first_confirmation then
		lprint( self.message..temp_strokes , self.x , self.y )
		lprint( "Confirm? [y/n]" , self.x , self.y + 100 )
	else
		lprint( self.message..strokes , self.x , self.y )
	end
end

function keystrokes:add( t )

	if ignore_char then
		ignore_char = false
		return
	end

	if first_confirmation then
		--nothing
	elseif #strokes > 15 then
		first_confirmation = true
		temp_strokes = strokes
		strokes = ""

	else
		strokes = strokes .. t
	end
end

function keystrokes:start_reading( message , x , y , font )
	reading_keys = true
	finished = false
	self:set( message , x , y , font )
	self.begin = true
end

function keystrokes:set( message , x , y , font )
	if message then self.message = message
	else self.message = "Text entered: "
	end

	if x then self.x = x
	else self.x = 0
	end

	if y then self.y = y
	else self.y = 0
	end

	if font then self.font = font
	else self.font = font_large
	end
end

function keystrokes:clear()
	if self.begin then
		clear( 'values' )
		self.begin = false
	end
end

function keystrokes:stop_reading()
	clear( 'flags' )
	finished = true
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
			self:stop_reading()--second_confirmation = true
		elseif key == 'n' then
			first_confirmation = false
			if #temp_strokes > 15 then
				clear( 'values' )
			end
			strokes = temp_strokes
			ignore_char = true
		end
	end	
end

function keystrokes:get_strokes()
	return temp_strokes
end

function keystrokes:finished()
	return finished
end

function keystrokes:ack()
	finished = false
end



return keystrokes
