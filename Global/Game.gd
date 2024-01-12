extends Node

@onready var gameSettings:GameSettings = GameSettings.load_or_create()

@onready var crew:Array[Crewmate] = []
@onready var enemyCrew:Array[Enemy] = []
@onready var credits = gameSettings.credits
@onready var inventory: Array[Item] = gameSettings.loadInventory()
@onready var skillList:Dictionary = loadSkillList()
@onready var roundConstraint:int = gameSettings.roundConstraint
@onready var currentRound:int = gameSettings.currentRound

@onready var tier1dest = loadDestList("FIGHT",1)
@onready var tier2dest = loadDestList("FIGHT",2)
@onready var tier3dest = loadDestList("FIGHT",3)
@onready var tier4dest = loadDestList("FIGHT",4)
@onready var merchantdest = loadDestList("MERCHANT",1)

func _ready():
	crew = gameSettings.loadPlayercrew()
	enemyCrew = gameSettings.loadEnemycrew()

func update():
	crew = gameSettings.loadPlayercrew()
	enemyCrew = gameSettings.loadEnemycrew()
	credits = gameSettings.credits
	roundConstraint = gameSettings.roundConstraint
	currentRound = gameSettings.currentRound
	inventory = gameSettings.loadInventory()

func saveGameSetting():
	var savedCrew:Array[Dictionary] = []
	for i in crew:
		savedCrew.append(i.toDictionary())
	gameSettings.playerCrew = savedCrew
	var savedEnnemyCrew:Array[Dictionary] = []
	for i in enemyCrew:
		savedEnnemyCrew.append(i.toDictionary())
	gameSettings.ennemyCrew = savedEnnemyCrew
	var savedInventory:Array[int] = []
	for i in inventory:
		if i is Item:
			savedInventory.append(i.getItemId())
	gameSettings.inventory = savedInventory
	gameSettings.credits=credits
	gameSettings.roundConstraint = roundConstraint
	gameSettings.currentRound = currentRound
	gameSettings.save()

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
		
