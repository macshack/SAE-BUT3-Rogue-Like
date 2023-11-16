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
	if random == false:
		self.id = createId(destinationName)
		self.destinationName = destinationName
		self.situation = situation
		self.image = image
		self.description = description
	else:
		createRandom()

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

func getRandomImageFromFolder(folderPath: String) -> String:
	var dir = DirAccess.new.call()
	var files = []
	
	# Parcourir les fichiers du dossier
	while dir.next() != "":
		files.append(dir.get_file())
	
	dir.close()
	
	if files.size() > 0:
		var randomIndex = randi() % files.size()
		return files[randomIndex]
	else:
		return ""



func createRandom():
	var destinationLib = load("res://Library/destinationLib.gd")
	var randomIndex = randi() % 2 
	if randomIndex == 0:
		destinationName = destinationLib.shipName[randi() % destinationLib.shipName.size()]
		image = getRandomImageFromFolder("res://Images/Ship")
	else:
		destinationName = destinationLib.planetShip[randi() % destinationLib.planetName.size()]
		image = getRandomImageFromFolder("res://Images/Planet")
	self.id = createId(destinationName)
	self.destinationName = destinationName
	self.image = image
	self.description = ""
	#crer situation aléatoirement
