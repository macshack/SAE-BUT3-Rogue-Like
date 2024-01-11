extends Node

#Classe parent pour tous les personnages
#NE PAS CREER DE PERSONNAGE A L'AIDE DE LA CLASSE "CHARACTER"
class_name Character

#Variable id sert a identifier le personnage grace a une string unique
var identity:String
var icon:String
var healthBase:int
var healthCurrent:int
var attackBase:int
var speedBase:int
var critBase:int
var dodgeBase:float
var isdefending: bool

func _init(identity = "",icon = "", healthBase = 10, healthCurrent = healthBase, attackBase = 3, speedBase = 5, critBase = 5.0, dodgeBase = 5.0, isdefending = false):
	self.identity = identity
	self.icon = icon
	self.healthBase = healthBase
	self.healthCurrent = healthCurrent
	self.attackBase = attackBase
	self.speedBase = speedBase
	self.critBase = critBase
	self.dodgeBase = dodgeBase
	self.isdefending = isdefending

func get_identity():
	return self.identity

func get_health_current():
	return healthCurrent
	

func set_identity(value):
	identity = value
