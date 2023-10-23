extends Node

#Classe parent pour tous les personnages
#NE PAS CREER DE PERSONNAGE A L'AIDE DE LA CLASSE "CHARACTER"
class_name Character

#Variable id sert a identifier le personnage grace a une string unique
var id:String
var identity:String
var healthMax:int
var healthCurrent:int

func _init(identity = "", healthMax = 10, healthCurrent = 10):
	self.identity = identity
	self.healthMax = healthMax
	self.healthCurrent = healthCurrent
	self.id = createId(identity)

func createId(identity):
	var id = identity + str(Random.rng.randi_range(100000,9999999))
	while id in Characters.charactersList:
		id = identity + str(Random.rng.randi_range(100000,9999999))
	if not id in Characters.charactersList:
		Characters.addCharacterIdToList(id)
	return id

func get_identity():
	return self.identity

func get_health_current():
	return healthCurrent
	
func get_health_max():
	return healthMax

func get_id():
	return id

func set_identity(value):
	identity = value

func set_health_current(value):
	healthCurrent = clamp(value,0,healthMax)
	
func set_health_max(value):
	healthMax = value
