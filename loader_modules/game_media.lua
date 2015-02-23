--loader modules for game loading

local img_dir , sound_dir , save_dir = "images/" , "sounds/" , "../saves"


local images = {}
local images_to_load = {
	tileset 			= 'natural_tiles.png'
	,gui_image 			= 'main_gui.png'
	,unit_sprites 		= 'sample_unit.png'
	,monster_sprites 	= 'sample_monster.png'
	,structures			= 'structures.png'
}

local sounds = {}
local sounds_to_load = {
	bgm = { name='rolling_hills.mp3' , type='stream'}
}


for image_name , image_loc in pairs( images_to_load ) do
	local temp = love.graphics.newImage( img_dir..image_loc )
	temp:setFilter( 'nearest' )
	images[ image_name ] = temp
end

for sound_name , info in pairs( sounds_to_load ) do
	sounds[ sound_name ] = love.audio.newSource( sound_dir..info.name , info.type )
end

return {images=images , sounds=sounds}