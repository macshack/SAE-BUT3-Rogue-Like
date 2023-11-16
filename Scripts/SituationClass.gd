extends Node

#Classe parent pour toutes les Situations
class_name Situation

#Variable id sert a identifier la situation grace a une string unique
var situationName:String
var listEnemies: Array
var description: String

func _init(situationNames = "", listEnemies = [], description = ""):
	self.situationName = situationName
	self.listEnemies = listEnemies
	self.description = description

func get_situationName():
	return situationName

func set_situationName(value):
	self.situationName = value

func get_listEnemies():
	return listEnemies
	
func set_listEnemies(value):
	listEnemies = value

func get_description():
	return description
	
func set_description(value):
	description = value

