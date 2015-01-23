--[[
	Main object for the Meddlers, which the player is one of. Similar to our concept of 'gods'.
]]

wrapper = require 'npcs'
npcs = wrapper.meddlers
affs = wrapper.affinities

meddler = {
	name = "Nihil"
}




function meddler:new( is_player , name )
	new_meddler = {}
	setmetatable( new_meddler , self )
	self.__index = self

	new_meddler.is_player = is_player

	if not is_player then
		load_npc_meddler( new_meddler )
	else
		new_meddler.name = name
	end

	return new_meddler
end
--====== Helpers ======
	function load_npc_meddler( new_meddler )
		local int = math.random( 1 , #npcs )
		local npc = npcs[ int ]
		for type , data in pairs( npc ) do
			new_meddler[ type ] = data
		end
	end






return meddler