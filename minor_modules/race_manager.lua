

race_manager = {
	
	list_of_current_races = {}
	,list_of_monsters = {}

}

function race_manager:add_new_race( config , tile )
	local new_race = race:new( config , tile )
	list_of_current_races[ config.name ] = new_race


end


function race_manager:draw()
	for k,v in pairs( list_of_current_races ) do
		v:draw()
	end
end

function race_manager:update()
	for k,v in pairs( list_of_current_races ) do
		v:update()
	end
end

return race_manager