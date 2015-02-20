--[[
	Main object for the Meddlers, which the player is one of. Similar to our concept of 'gods'.
]]

wrapper = require 'npcs'
npcs = wrapper.meddlers
affs = wrapper.affinities

local meddler = {
	name = "Nihil"
	,eminence = 100
}



--===== Helpers =======
	local function load_npc_meddler( new_meddler )
		local int = math.random( 1 , #npcs )
		local npc = npcs[ int ]
		for type , data in pairs( npc ) do
			new_meddler[ type ] = data
		end
	end

function meddler:new( is_player , name )
	new_meddler = {}
	setmetatable( new_meddler , self )
	self.__index = self

	new_meddler.is_player = is_player
	new_meddler.affs = { give=1 , take=1 , change=1 }

	if not is_player then
		load_npc_meddler( new_meddler )
	else
		new_meddler.name = name
	end

	return new_meddler
end

function meddler:gained( value )
	self.eminence = self.eminence + value
end

function meddler:purchase( value )
	if self.eminence >= value then
		self.eminence = self.eminence - value
		return true
	else
		dialogue( 'lack_emi' )
		return false
	end
end



return meddler