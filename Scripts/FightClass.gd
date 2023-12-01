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

func removeEnemy(id):
	var tab = []
	for i in range(self.ennemiesList.size()):
		if int(self.ennemiesList[i].get_id()) != id:
			tab.append(self.ennemiesList[i])
	self.ennemiesList = tab

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
	
func startFight():
	var order = orderFight()
	print(order)
	var alive_crew = true
	while self.ennemiesList != [] and alive_crew == true:
		print("Tour")
		removeEnemy(1)
		alive_crew = self.crew.aliveCrew()
		print(alive_crew)
	print("Combat terminé")
