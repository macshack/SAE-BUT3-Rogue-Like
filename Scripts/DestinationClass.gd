extends Node

#Classe parent pour toutes les destinations
class_name Destination

#Variable id sert a identifier la destination grace a une string unique
var id:String
var destinationName:String
var situation: Situation
var image: String
var description: String

func _init(destinationName = "", situation = Situations, image = "", description = "", random = false):
	self.id = createId(destinationName)
	self.destinationName = destinationName
	self.situation = situation
	self.image = image
	self.description = description

func get_id():
	return id

func get_destinationName():
	return self.destinationName

func set_destinationName(value):
	destinationName = value

func get_situation():
	return situation
	
func set_situation(value):
	situation = value

func get_image():
	return image
	
func set_image(value):
	image = value

func get_description():
	return description
	
func set_description(value):
	description = value

func createId(destinationName):
	var id = str(Destinations.destinationsList.size()+1)
	return id

func createRandom():
	pass
