extends Node

class_name Skill

var skillName:String
var baseValue:int
var currentValue:int

func _init(skillNamet = "Default name", baseValuet = 6):
	skillName = skillNamet
	baseValue = clamp(baseValuet,2,11)
	currentValue = clamp(baseValue,2,11)

func get_skill_name():
	return skillName

func get_base_value():
	return baseValue

func get_current_value():
	return currentValue

func set_skill_name(value):
	skillName = value

func set_base_value(value):
	baseValue = clamp(value,2,11)

func set_current_value(value):
	currentValue = clamp(value,2,11)
