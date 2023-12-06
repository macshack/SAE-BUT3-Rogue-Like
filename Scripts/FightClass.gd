extends Node

class_name Fight

var crew:Crew
var ennemiesList:Array

func _init(crew, ennemiesList):
	self.crew = crew
	self.ennemiesList = ennemiesList

func tri_insertion(tableau):
	var longueur = tableau.size()
	for i in range(1, longueur):
		var cle = tableau[i]
		var j = i - 1
		while j >= 0 and tableau[j][1] < cle[1]:
			tableau[j + 1] = tableau[j]
			j = j - 1
		tableau[j + 1] = cle

func findID(id: String):
	var character
	for i in range(len(crew.crewList)):
		if crew.crewList[i].get_id() == id:
			character = crew.crewList[i]
	for i in range(len(ennemiesList)):
		if ennemiesList[i].get_id() == id:
			character = ennemiesList[i]		
	return character
	
func orderFight():
	var tabSpeedEnnemies = []
	var tabSpeedCrew = []
	var tabSpeed = []
	for i in  range(len(self.ennemiesList)):
		tabSpeedEnnemies.append([self.ennemiesList[i].get_id(), self.ennemiesList[i].get_speed()])
	for i in range(len(self.crew.crewList)):
		tabSpeedCrew.append([self.crew.crewList[i].get_id(), self.crew.crewList[i].get_speed()])
	tabSpeed = tabSpeedCrew + tabSpeedEnnemies
	tri_insertion(tabSpeed)
	return tabSpeed
	
func aliveEnnemies():
	var alive = false
	for i in range(len(self.ennemiesList)):
		if self.ennemiesList[i].get_state() == 0:
			return true
	return alive

func startFight():
	var order = orderFight()
	print(order)
	var alive_crew = true
	var alive_ennemies = true
	var count = 1
	
	while alive_ennemies == true and alive_crew == true:
		print("Tour: " + str(count))
		
		for i in range(len(order)):
			var character = self.findID(order[i][0])
			print(character.get_id())
			if character.get_health_current() > 0:
				character.set_state(0)
		
		alive_crew = self.crew.aliveCrew()
		alive_ennemies = self.aliveEnnemies()
		count = count + 1
		alive_ennemies = false #à enlever (pour test)
		print("Fin du tour: " + str(count))
	if alive_crew == true:
		print("WIN")
	else:
		print("LOOSE")
