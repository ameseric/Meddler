--[[

	Test module for separating keystroke functions/parameters

]]


keystrokes = {

	strokes = ""
	,reading_keys = false
	,first_confirmation = false
	,second_confirmation = false
	,temp_strokes = ""

}


function keystrokes:are_reading( value )
	if value == true or value == false then
		self.reading_keys = value
	end

	return self.reading_keys
end


function keystrokes:first_conf()
	return self.first_confirmation
end

function keystrokes:full_conf()
	return self.second_confirmation and self.first_confirmation
end

function keystrokes:stop_reading()
	self.reading_keys = false
	self.first_confirmation = false
	self.second_confirmation = false
	self.temp_strokes = ""
	self.strokes = ""
end

function keystrokes:clear( value )
	if value == 'main' then
		self.strokes = ""
	elseif value == 'temp' then
		self.temp_strokes = ""
	elseif value == 'both' then
		self.strokes = ""
		self.temp_strokes = ""
	end
end
