extends Node

@onready var crew:Array[Crewmate] = []
@onready var enemyCrew:Array[Enemy] = []
@onready var currentScene
@onready var credits=200
@onready var inventory: Array[Item]
@onready var skillList:Dictionary
@onready var roundConstraint:int

func loadSkillList():
	var skillDic = JsonHandling.skill_data
	var skillList = {}
	for s in skillDic:
		var skill = Skill.new(skillDic[s].id,skillDic[s].name,skillDic[s].icon,skillDic[s].description,skillDic[s].flags,skillDic[s].passive,skillDic[s].active);
		skillList[skill.skillId] = skill
	return skillList
