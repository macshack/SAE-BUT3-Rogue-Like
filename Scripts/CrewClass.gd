extends Node

class_name Crew

signal crewmate_added(crewmate)

const machin = "truc"
var crewName:String
var crewList:Array[Crewmate]

#Constructeur de le classe
func _init(crewNamet = "defaultCrewName", crewListt:Array[Crewmate] = []):
	crewName = crewNamet
	crewList = crewListt

#Suppression d'un membre de l'equipage - seulement possible si il y a au moins 2 personnages dans l'equipage
func removeCrewmate(position:int):
	if self.crewList.size() > 1:
		self.crewList.remove_at(position)
		print("Crewmate removed")

#Ajout d'un membre a l'equipage - seulement possible si il y a moins de 5 personnages
func addCrewmate(crewmate:Crewmate):
	if self.crewList.size() < 5:
		self.crewList.append(crewmate)
		crewmate_added.emit(crewmate)
		print("Crewmate added")
	
#Swap entre deux personnages de l'equipage
#
func swapCrewmates(first:int,second:int):
	var crewmateOne = self.crewList.pop_at(first)
	var crewmateTwo = self.crewList.pop_at(second)
	self.crewList.insert(second,crewmateOne)
	self.crewList.insert(first,crewmateTwo)
	print("Crewmates swapped")
