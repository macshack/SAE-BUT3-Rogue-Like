extends Node

#Classe parent pour tous les personnages
#NE PAS CREER DE PERSONNAGE A L'AIDE DE LA CLASSE "CHARACTER"
class_name Character

#Variable id sert a identifier le personnage grace a une string unique
var id:String
var identity:String
var healthBase:int
var healthCurrent:int
var attackBase:int
var speedBase:int
var critBase:int
var dodgeBase:float

func _init(identity = "", healthBase = 10, healthCurrent = healthBase, attackBase = 3, speedBase = 5, critBase = 5.0, dodgeBase = 5.0):
	self.identity = identity
	self.healthBase = healthBase
	self.healthCurrent = healthCurrent
	self.attackBase = attackBase
	self.speedBase = speedBase
	self.critBase = critBase
	self.dodgeBase = dodgeBase
	self.id = createId(identity)

func createId(identity):
	var id = str(Characters.charactersList.size()+1)
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
