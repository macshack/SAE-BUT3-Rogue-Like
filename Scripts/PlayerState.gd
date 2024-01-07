extends Node

var crewList = []

func createCrew():
	var crew = Crew.new()
	for i in range(4):
		var Cr = Crewmate.new()
		crew.addCrewmate(Cr)
	return crew

var crew = createCrew()

var health = crew.crewList[0].get_health_current()
var health_max = crew.crewList[0].get_health_max()
var attack = crew.crewList[0].get_attackPower()


