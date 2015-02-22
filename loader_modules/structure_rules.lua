


local structure_rules = {
	Village = {
		cost = { stone=5 , wood=10 }
		,units={ 'Citizen' }
		,stats={ health=10 , attack=0 }
	}

	,Town = {
		cost = { stone=10 , wood=20 }
		,units={ 'Citizen' , 'light_infantry' , 'light_calvary'	}
		,stats={ health=10 , attack=0 }
	}

	,City = {
		cost = { stone=5 , wood=10 }
		,units={ 'Citizen' , 'light_infantry' , 'light_calvary' }
		,stats={ health=10 , attack=0 }
	}

	,Fortress = {
		cost = { stone=5 , wood=10 }
		,units={ 'heavy_infantry' , 'heavy_calvary' }
		,stats={ health=10 , attack=0 }
	}

	,Temple = {
		cost = { stone=5 , wood=10 }
		,units={ 'Priest' , 'Mage' }
		,stats={ health=10 , attack=0 }
	}

}



return structure_rules