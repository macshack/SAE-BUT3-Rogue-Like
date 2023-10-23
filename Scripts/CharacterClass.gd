extends Node

class_name Character

var identity:String
var healthMax:int
var healthCurrent:int

func _init(identity = "", healthMax = 10, healthCurrent = 10):
	self.identity = identity
	self.healthMax = healthMax
	self.healthCurrent = healthCurrent

func get_identity():
	return identity

func get_health_current():
	return healthCurrent
	
func get_health_max():
	return healthMax
