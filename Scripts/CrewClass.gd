extends Node

#Classe Crew cree les personnages
class_name Crew

#On cree un signal qui pourra etre utiliser par d'autres
signal crewmate_added(crewmate)
signal crewmate_removed(crewmate)

var crewName:String
var crewList:Array[Crewmate]

#Constructeur de le classe
func _init(crewName = "defaultCrewName", crewList:Array[Crewmate] = []):
	self.crewName = crewName
	self.crewList = crewList

#Suppression d'un membre de l'equipage - seulement possible si il y a au moins 2 personnages dans l'equipage
func removeCrewmate(position:int):
	if self.crewList.size() > 1:
		self.crewList.remove_at(position)

#Ajout d'un membre a l'equipage - seulement possible si il y a moins de 5 personnages
func addCrewmate(crewmate:Crewmate):
	if self.crewList.size() < 5:
		self.crewList.append(crewmate)
		Characters.addCharacterIdToList(crewmate.get_id())
		crewmate_added.emit(crewmate)
	
#Swap entre deux personnages de l'equipage
func swapCrewmates(first:int,second:int):
	var crewmateOne = self.crewList.pop_at(first)
	var crewmateTwo = self.crewList.pop_at(second)
	self.crewList.insert(second,crewmateOne)
	self.crewList.insert(first,crewmateTwo)

func findCrewmate(id):
	for crewmate in crewList:
		if crewmate.get_id() == id:
			return crewmate
	
func aliveCrew():
	var alive = false
	for i in range(len(crewList)):
		if crewList[i].get_state() == 0:
			return true
	return alive
