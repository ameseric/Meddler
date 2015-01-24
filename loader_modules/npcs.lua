--[[
	Loader file for pre-set Meddler NPCs
]]

npcs = {}

npcs.meddlers = {
	
	{ name='Aurigna' , gender='Female' , traits = {'Bountiful'} , ai='Benevolent' }

	,{ name='Hagondes' , gender='Male' , traits = {} , ai='Tortured' }

	,{ name='Great-Eyes' , gender='Male' , traits = {} , ai='Old' }

	,{ name='Shynepth' , gender='None' , traits = {} , ai='Cosmic' }

	,{ name='Bethtilk' , gender='Female' , traits = {} , ai='Free' }

}

npcs.affinities = {
	'Bright'	--0,4,0
	,'Free'		--1,3,0
	,'Weary'	--2,2,0
	,'Feared'	--3,1,0
	,'Dark'		--4,0,0
	,'Tortured'	--3,0,1
	,'Mad'		--2,0,2
	,'Cosmic'	--1,0,3
	,'Unknowable'--0,0,4
	,'Old'		--0,1,3
	,'Primal'	--0,2,2
	,'Benevolent'--0,3,1
	,'Grey'		--1,2,1
	,'Chained'	--2,1,1
	,'Knowing'	--1,1,2
}


return npcs