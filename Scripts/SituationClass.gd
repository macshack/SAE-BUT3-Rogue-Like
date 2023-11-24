extends Node

#Classe parent pour toutes les Situations
class_name Situation

#Variable id sert a identifier la situation grace a une string unique
var situationName:String
var description: String

func _init(situationNames = "", description = ""):
	self.situationName = situationName
	self.description = description

func get_situationName():
	return situationName

func set_situationName(value):
	self.situationName = value

func get_description():
	return description
	
func set_description(value):
	description = value
	
