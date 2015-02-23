--Unit Rules, same as other rule files


local unit_rules = {
	
	Citizen = { 
		cost={food=2} 
		,stats={Life=5,Defense=2} 
		,timer=1 
	}

	,LInfantry = { 
		cost={food=4} 
		,stats={Attack=0.2} 
		,timer=1
	}

	,HInfantry = { 
		cost={food=6,mineral=3} 
		,stats={Defense=0.2,Move=-0.4,Attack=0.2} 
		,timer=1
	}
	
	,LCalvary = { 
		cost={food=4,mineral=1} 
		,stats={Move=0.4} 
		,timer=1
	}

	,HCalvary = {
		cost={food=6,mineral=4} 
		,stats={Move=0.2,Defense=0.2} 
		,timer=1 
	}

}

--[[
All use citizens (for now)



			Sacrificial
				Light Infantry
				Heavy Infantry


			Tribal???
			Caste 
			Scholars 	
			Nomadic 	
			Militant



--]]			


return unit_rules