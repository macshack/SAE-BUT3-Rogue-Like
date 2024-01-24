class_name GameSettings extends Resource

@export var currentRound:int = 1
@export var credits:int = 200
@export var roundConstraint:int = -1
@export var playerCrew = []
@export var ennemyCrew = []
@export var inventory = []

func save():
	ResourceSaver.save(self,"user://game_settings.tres")

static func load_or_create() -> GameSettings:
	var res: GameSettings = ResourceLoader.load("user://game_settings.tres") as GameSettings
	if !res:
		res = GameSettings.new()
	return res

static func create() -> GameSettings:
	var res = GameSettings.new()
	return res

func reset():
	currentRound = 1
	credits = 200
	roundConstraint = -1
	playerCrew = []
	ennemyCrew = []
	inventory = []

func loadPlayercrew()->Array[Crewmate]:
	var list:Array[Crewmate]= []
	for i in playerCrew:
		var skillsTab:Array[int] = []
		var gearTab:Array[int] = []
		for skill in i["skills"]:
			skillsTab.append(int(skill))
		for item in i["gear"]:
			gearTab.append(int(item))
		print(gearTab)
		var crewmate = Crewmate.new(i["identity"],i["icon"],i["background"],skillsTab,i["price"],gearTab,i["healthBase"],i["healthCurrent"],i["attackBase"],i["speedBase"],i["critBase"],i["dodgeBase"])
		list.append(crewmate)
		print("Crewmate loaded")
	return list
	
func loadEnemycrew()->Array[Enemy]:
	var list:Array[Enemy]= []
	for i in ennemyCrew:
		var enemy = Enemy.new(i["identity"],i["icon"],i["healthCurrent"],i["healthMax"],i["attackPower"])
		list.append(enemy)
	return list

func loadInventory()->Array[Item]:
	var list:Array[Item] = []
	for i in inventory:
		var item = Item.new(i,"","","",{},0,true)
		list.append(item)
	return list
