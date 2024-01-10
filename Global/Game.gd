extends Node


@onready var crew:Array[Crewmate] = []
@onready var enemyCrew:Array[Enemy] = []
@onready var credits=200
@onready var inventory: Array[Item]
@onready var skillList:Dictionary = loadSkillList()
@onready var roundConstraint:int
@onready var currentRound:int = 1

@onready var tier1dest = loadDestList("FIGHT",1)
@onready var tier2dest = loadDestList("FIGHT",2)
@onready var tier3dest = loadDestList("FIGHT",3)
@onready var tier4dest = loadDestList("FIGHT",4)
@onready var merchantdest = loadDestList("MERCHANT",1)

func loadSkillList():
	var skillDic = JsonHandling.skill_data
	var skillList = {}
	for s in skillDic:
		var skill = Skill.new(skillDic[s].id,skillDic[s].name,skillDic[s].icon,skillDic[s].description,skillDic[s].flags,skillDic[s].passive,skillDic[s].active);
		skillList[skill.skillId] = skill
	return skillList

func loadDestList(type:String,tier:int=1):
	if (type == "FIGHT"):
		match(tier):
			1:
				var dict = JsonHandling.destTier1_data
				var list = []
				for e in dict:
					list.append(dict[e])
				return list
			2:
				var dict = JsonHandling.destTier2_data
				var list = []
				for e in dict:
					list.append(dict[e])
				return list
			3:
				var dict = JsonHandling.destTier3_data
				var list = []
				for e in dict:
					list.append(dict[e])
				return list
			4:
				var dict = JsonHandling.destTier4_data
				var list = []
				for e in dict:
					list.append(dict[e])
				return list
	elif (type == "MERCHANT"):
		var dict = JsonHandling.destMerchant_data
		var list = []
		for e in dict:
			list.append(dict[e])
		return list
		
