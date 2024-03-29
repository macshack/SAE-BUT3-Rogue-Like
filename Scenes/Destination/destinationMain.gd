extends Panel

signal toMainMenu()
signal emitFightResult()
signal nextDestination()
signal save()
signal sendBattlereport(boolean, value)
signal newRound()
signal sendVictoryScore(score,obj)

var situationDone = false

var currentFight = false

var merchantScene = preload("res://Scenes/Merchant/Merchant.tscn")
var fightScene = preload("res://Scenes/Battle/battle.tscn")

var nextDestinationScene = preload("res://Scenes/Destination/nextDestinationScene.tscn")

var crewmateNameplateScene = preload("res://Scenes/Destination/crewmateNameplate.tscn")

var destination = {}
var situation = {}

var nameplateUpdateTimer = 1

var gameFinished = false

@onready var crewmates = %Crewmates
@onready var inventory = %Inventory
@onready var main = %Main
@onready var crew = %Equipage
@onready var menuNode = %Menu

@onready var settings = %Settings
@onready var optionsNode = %OptionsMenu
@onready var menuSaveNode = %Sauvegarder
@onready var menuSettingsNode = %Options
@onready var menuQuitNode = %Quitter
@onready var objectiveNode = %Objective
@onready var objectiveScreenNode = %ObjectiveScreen
@onready var widgetNode = %ObjectiveWidget

@onready var nextDestinationNode = %NewDestination
@onready var nextDestinationContainerNode = %HBoxContainer

var situationNode

var destinationSettings:DestinationSettings

# Called when the node enters the scene tree for the first time.
func _ready():
	print(Game.currentRound)
	generateNextDestination(Game.currentRound)
	if situation:
		match(situation["type"]):
			"FIGHT":
				var scene = fightScene.instantiate()
				scene.start.connect(_disable_during_fight)
				scene.reward.connect(_on_battleReward)
				scene.lost.connect(_on_situation_lost)
				scene.openDestination.connect(_on_destination_pressed)
				situationNode = str(scene)
				main.add_child(scene)
				if situationDone:
					scene.setFightEndScreen(destinationSettings.situationResult)
				if destinationSettings:
					destinationSettings.situationDone = situationDone
					destinationSettings.save()
			"BOSS":
				var scene = fightScene.instantiate().init(true,Game.bosstemplate[randi() % Game.bosstemplate.size()])
				scene.start.connect(_disable_during_fight)
				scene.reward.connect(_on_battleReward)
				scene.lost.connect(_on_situation_lost)
				scene.openDestination.connect(_on_destination_pressed)
				situationNode = str(scene)
				main.add_child(scene)
				if situationDone:
					scene.setFightEndScreen(destinationSettings.situationResult)
				if destinationSettings:
					destinationSettings.situationDone = situationDone
					destinationSettings.save()
			"MERCHANT":
				var merchant = merchantScene.instantiate()
				situationNode = str(merchant)
				situationDone = true
				if destinationSettings:
					destinationSettings.situationDone = true
					destinationSettings.save()
				main.add_child(merchant)
	for cr in Game.crew.size():
		var nameplate = crewmateNameplateScene.instantiate().init(int(cr))
		var node = NodePath(situationNode)
		if situation["type"] == "FIGHT":
			nameplate.clickOnNameplate.connect(main.get_node(node)._on_crew_nameplate_click)
		crewmates.add_child(nameplate)
	crewmates.show()
	save.emit()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if gameFinished == false:
		if (nameplateUpdateTimer <= 0):
			if crewmates.get_children().size() != Game.crew.size():
				updateCrewmatesNameplates()
			nameplateUpdateTimer = 0.5
		else:
			nameplateUpdateTimer -= delta

func _on_objectiveUpdate_received(data:ObjectiveSettings):
	widgetNode.updateObjective(data)
	objectiveScreenNode.updateObjective(data)

func _on_settings_pressed():
	for i in main.get_children():
		i.hide()
	settings.show()

func init(load:bool):
	if load:
		destinationSettings = DestinationSettings.load_or_create()
		$TextureRect.texture = ResourceLoader.load("res://Assets/Background/Radar/"+destinationSettings.backgroundFile)
		situation["type"] = destinationSettings.type
		situation["difficulty"] = destinationSettings.difficulty
		situationDone = destinationSettings.situationDone
		
	else:
		destinationSettings = DestinationSettings.load_or_create()
		destinationSettings.reset()
		$TextureRect.texture = ResourceLoader.load("res://Assets/Background/Radar/"+destinationSettings.backgroundFile)
		situation["type"] = destinationSettings.type
		situation["difficulty"] = destinationSettings.difficulty
		situationDone = destinationSettings.situationDone
		destinationSettings.started = true
		destinationSettings.save()
	return self

func _on_inventory_pressed():
	if gameFinished == false && currentFight == false:
		for i in main.get_children():
			i.hide()
		inventory.refreshInventory()
		inventory.show()

func forceSave():
	if gameFinished == false && currentFight == false:
		destinationSettings.save()

func _on_situation_pressed():
	for i in main.get_children():
		i.hide()
	for c in main.get_children():
		crewmates.show()
		if str(c) == situationNode:
			c.show()


func _on_equipage_pressed():
	if gameFinished == false && currentFight == false:
		for i in main.get_children():
			i.hide()
		crew.show()


func _on_menuSettings_pressed():
	menuNode.hide()
	optionsNode.show()


func _on_menuSauvegarder_pressed():
	save.emit()


func _on_menuQuitter_pressed():
	save.emit()
	toMainMenu.emit(false)
	self.queue_free()


func _on_options_menu_exit():
	optionsNode.hide()
	menuNode.show()

func _on_small_objective_container_gui_input(event):
	if (event is InputEventMouseButton) && (event.button_index == MOUSE_BUTTON_LEFT) && (event.pressed):
		for i in main.get_children():
			i.hide()
		objectiveNode.show()

func updateCrewmatesNameplates():
	for n in crewmates.get_children():
		n.queue_free()
	for cr in Game.crew.size():
		var nameplate = crewmateNameplateScene.instantiate().init(int(cr))
		crewmates.add_child(nameplate)

func _on_battleReward(value:Dictionary):
	Game.enemyCrew = []
	currentFight = false
	situationDone = true
	destinationSettings.situationResult = {
		"total_damage_dealt":value["total_damage_dealt"],
		"enemies_killed":value["enemies_killed"],
		"rounds":value["rounds"],
		"total_damage_suffered":value["total_damage_suffered"],
	}
	destinationSettings.situationDone = true
	destinationSettings.save()
	for i in Game.crew:
		var heal = clamp(i.healthCurrent+snapped(i.healthMax/4,1),0,i.healthMax)
		i.healthCurrent = heal
	sendBattlereport.emit(false,value)

func _on_situation_lost(value:Dictionary):
	sendBattlereport.emit(true)

func _on_next_destination_data(value:Dictionary):
	nextDestination.emit(value)
	
func generateNextDestination(currentRound:int):
	var merchant:bool = true
	var rand = randi() % 2
	if (currentRound+1)%5 == 0:
		var dest = Game.tier1dest[randi()%Game.tier1dest.size()]
		dest.type = "BOSS"
		var scene = nextDestinationScene.instantiate().init(dest)
		scene.click.connect(_on_next_destination_data)
		nextDestinationContainerNode.add_child(scene)
	else:
		if rand == 1:
			var scene = nextDestinationScene.instantiate().init(Game.merchantdest[randi()%Game.merchantdest.size()])
			scene.click.connect(_on_next_destination_data)
			nextDestinationContainerNode.add_child(scene)
		for i in 2:
			if currentRound < 5:
				var scene = nextDestinationScene.instantiate().init(Game.tier1dest[randi()%Game.tier1dest.size()])
				scene.click.connect(_on_next_destination_data)
				nextDestinationContainerNode.add_child(scene)
			elif currentRound < 10:
				var scene = nextDestinationScene.instantiate().init(Game.tier1dest[randi()%Game.tier1dest.size()])
				scene.click.connect(_on_next_destination_data)
				nextDestinationContainerNode.add_child(scene)
			elif currentRound < 15:
				var scene = nextDestinationScene.instantiate().init(Game.tier2dest[randi()%Game.tier2dest.size()])
				scene.click.connect(_on_next_destination_data)
				nextDestinationContainerNode.add_child(scene)
			elif currentRound < 20:
				var scene = nextDestinationScene.instantiate().init(Game.tier3dest[randi()%Game.tier3dest.size()])
				scene.click.connect(_on_next_destination_data)
				nextDestinationContainerNode.add_child(scene)
			elif currentRound > 20:
				var scene = nextDestinationScene.instantiate().init(Game.tier4dest[randi()%Game.tier4dest.size()])
				scene.click.connect(_on_next_destination_data)
				nextDestinationContainerNode.add_child(scene)


func _on_destination_pressed():
	if (situationDone):
		for i in main.get_children():
			i.hide()
		nextDestinationNode.show()

func _disable_during_fight():
	currentFight = true

func _input(event):
	if gameFinished == false && currentFight == false:
		if Input.is_key_pressed(KEY_ESCAPE):
			if optionsNode.visible:
				_on_options_menu_exit()
			elif !settings.visible:
				_on_settings_pressed()
			elif settings.visible:
				_on_situation_pressed()
		if Input.is_key_pressed(KEY_E):
			if !crew.visible:
				_on_equipage_pressed()
			elif crew.visible:
				_on_situation_pressed()
		if Input.is_key_pressed(KEY_TAB)||(Input.is_key_pressed(KEY_S)):
				_on_situation_pressed()
		if Input.is_key_pressed(KEY_B)||Input.is_key_pressed(KEY_I):
			if !inventory.visible:
				_on_inventory_pressed()
			elif inventory.visible:
				_on_situation_pressed()

func _on_victory(value:ObjectiveSettings):
	for ch in main.get_children():
		ch.hide()
	var finalScore = calcScore(value)
	%endTitle.text = "VICTOIRE"
	%endScore.text = "Votre score : "+str(finalScore)
	%EndScreen.show()
	%ButtonContainer.hide()
	sendGameResultToDB()
	gameFinished = true

func _on_defeat(value):
	for ch in main.get_children():
		ch.hide()
	%endTitle.text = "DEFAITE"
	%endScore.hide()
	%EndScreen.show()
	%ButtonContainer.hide()
	gameFinished = true

func calcScore(value:ObjectiveSettings)->int:
	var score = 2000+value.scoringWins*20-value.scoringRounds*10
	return score

func _on_to_main_menu_pressed():
	toMainMenu.emit(true)

#A faire
func sendGameResultToDB():
	pass
