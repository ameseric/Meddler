--[[
	Author: Eric Ames
	Last Updated: December 2014
	Purpose: O2 object for tiles in map creation.
]]

local tile = {
	holds = nil
	,is_passable = false
	,type = "nope"
	,timer = -1
}



function tile:new( type , x , y )
	new_tile = {}
	setmetatable( new_tile, self )
	self.__index = self
	new_tile.type = type
	new_tile.is_ocpied = false

	new_tile.x , new_tile.y = x , y 

	for k,v in pairs( rules.total_set[type] ) do --watch out for tables
		new_tile[k] = v
	end

	return new_tile
end


function tile:set_ocpied( npc )
	if npc then
		self.holds = npc
	else
		self.holds = nil
	end
		
end

function tile:time_passes()
	self.lifetime = self.lifetime - 1; --change, only for testing
	if self.lifetime == 0 then
		for k,v in pairs( rules.total_set[self.next_life] ) do
			if type(v) ~= 'function' then
				self[k] = v
			end
		end
	end
end


function tile:get_type() return self.type end

function tile:passable() return self.is_passable and not self.holds end

function tile:habitable() return (self.type == 'Forest' or self.type == 'Plain' ) end

function tile:get_resident() return self.holds end

--function tile:get_speech() return self.holds:get_speech() end


return tile