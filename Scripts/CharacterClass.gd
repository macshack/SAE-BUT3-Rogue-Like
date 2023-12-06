extends Node

#Classe parent pour tous les personnages
#NE PAS CREER DE PERSONNAGE A L'AIDE DE LA CLASSE "CHARACTER"
class_name Character

#Variable id sert a identifier le personnage grace a une string unique
var id:String
var identity:String
var healthMax:int
var healthCurrent:int
var attackPower:int
var speed:int
enum State {
	LIVING,
	KO,
	DEAD,
	GUARD
}
var state:State

func _init(identity = "defaultName", healthMax = 10, healthCurrent = 10, attackPower =1, speed = 1, state = State.LIVING):
	self.identity = identity
	self.healthMax = healthMax
	self.healthCurrent = healthCurrent
	self.attackPower = attackPower
	self.speed = speed
	self.state = state
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

func get_attackPower():
	return self.attackPower

func get_speed():
	return self.speed

func get_id():
	return id

func get_state():
	return self.state

func set_identity(value):
	identity = value

func set_health_current(value):
	healthCurrent = clamp(value,0,healthMax)
	
func set_health_max(value):
	healthMax = value

func set_attackPower(value):
	self.attackPower = value

func set_speed(value):
	self.speed = value

func set_id(value):
	self.id = value

func set_state(value):
	self.state = value

func attack(target: Character):
	if target.get_health_current() - self.get_attackPower() > 0:
		target.set_health_current(target.get_health_current() - self.get_attackPower())
	else:
		target.set_state(State.KO)
