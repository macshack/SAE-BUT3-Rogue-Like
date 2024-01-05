extends Node

class_name Skill

var skillId:int
var skillName:String
var skillIcon:String
var skillDescription:String
var passiveAbility
var activeAbility
var skillFlags:Array

func _init(skillId:int,skillName:String,skillIcon:String,skillDescription:String,skillFlags:Array,passiveAbility,activeAbility):
	self.skillId = skillId
	self.skillName = skillName
	self.skillIcon = skillIcon
	self.skillDescription = skillDescription
	self.skillFlags = skillFlags
	self.passiveAbility = passiveAbility
	self.activeAbility = activeAbility
