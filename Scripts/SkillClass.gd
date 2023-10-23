extends Node

class_name Skill

var skillName:String
var skillDescription:String
var baseValue:int
var currentValue:int

func _init(skillNamet = "Default name", skillDescriptiont = "Defaut description.", baseValuet = 6):
	skillName = skillNamet
	skillDescription = skillDescriptiont
	baseValue = baseValuet
	currentValue = baseValue

func get_skill_name():
	return skillName

func get_skill_desc():
	return skillDescription

func get_base_value():
	return baseValue

func get_current_value():
	return currentValue

func set_skill_name(value):
	skillName = value

func set_skill_desc(value):
	skillDescription = value

func set_base_value(value):
	baseValue = value

func set_current_value(value):
	currentValue = value
