--[[
	Loader file for pre-set Meddler NPCs
]]

npcs = {}

npcs.meddlers = {
	
	{ name='Aurigna' , gender='Female' , traits = {'Bountiful'} , powers = { 'Harvest' } , affinity='Benevolent' }

	,{ name='Hagondes' , gender='Male' , traits = {} , powers = {} , affinity='Tortured' }

	,{ name='Great-Eyes' , gender='Male' , traits = {} , powers = { 'Observe' } , affinity='Old' }

	,{ name='Shynepth' , gender='None' , traits = {} , powers = { 'Warp' } , affinity='Cosmic' }

	,{ name='Bethtilk' , gender='Female' , traits = {} , powers = { 'Wander' } , affinity='Free' }

}

npcs.affinities = {
	'Bright'
	,'Free'
	,'Weary' --Tarnished?
	,'Feared'
	,'Dark'
	,'Tortured'
	,'Mad'
	,'Cosmic'
	,'Unknowable'
	,'Old'
	,'Primal'
	,'Benevolent'
}


return npcs