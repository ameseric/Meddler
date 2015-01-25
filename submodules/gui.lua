--GUI object file, submodule

gui = {
	image = nil
}

function gui:setup( image , width , height , scale )
	self.image = image
	print( width , height )
	self.x_draw_point = width/5  --(width/4)
	self.y_draw_point = ((height/12) * 9)
	print( self.x_draw_point , self.y_draw_point)
end

function gui:draw( scale )
	love.graphics.draw( self.image , self.x_draw_point , self.y_draw_point , 0 , 2.5 , 2 )
end

return gui