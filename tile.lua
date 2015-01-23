--[[
	Author: Eric Ames
	Last Updated: December 2014
	Purpose: O2 object for tiles in map creation.
]]

local tile = {
	holds = nil
	,is_passable = false
	,type = "nope"
}
rules = require "tile_rules"



function tile:new( type )
	new_tile = {}
	setmetatable( new_tile, self )
	self.__index = self

	new_tile.type = type
	new_tile.is_passable = rules.a[ type ].is_passable
	--etc.

	new_tile.is_ocpied = false
	return new_tile
end


function tile:set_ocpied( npc, clear )
	if clear then
		self.holds = nil
	else
		self.holds = npc
	end
		
end


function tile:get_type() return self.type end

function tile:passable() return self.is_passable and not self.holds end

function tile:get_resident() return self.holds end

--function tile:get_speech() return self.holds:get_speech() end


return tile