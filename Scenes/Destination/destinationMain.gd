extends Panel

signal toMainMenu()
signal emitFightResult()
signal nextDestination()
signal save()
signal sendBattlereport(boolean, value)

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
	generateNextDestination(Game.currentRound)
	for cr in Game.crew.size():
		var nameplate = crewmateNameplateScene.instantiate().init(int(cr))
		crewmates.add_child(nameplate)
	crewmates.show()
	if situation:
		match(situation["type"]):
			"FIGHT":
				var scene = fightScene.instantiate()
				scene.start.connect(_disable_during_fight)
				scene.reward.connect(_on_battleReward)
				scene.openDestination.connect(_on_destination_pressed)
				situationNode = str(scene)
				main.add_child(scene)
				situationDone = false
				if destinationSettings:
					destinationSettings.situationDone = false
					destinationSettings.save()
			"MERCHANT":
				var merchant = merchantScene.instantiate()
				situationNode = str(merchant)
				situationDone = true
				if destinationSettings:
					destinationSettings.situationDone = true
					destinationSettings.save()
				main.add_child(merchant)

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
		$TextureRect.texture = load("res://Assets/Background/Radar/"+destinationSettings.backgroundFile)
		situation["type"] = destinationSettings.type
		situation["difficulty"] = destinationSettings.difficulty
		situationDone = destinationSettings.situationDone
	else:
		destinationSettings = DestinationSettings.load_or_create()
		destinationSettings.reset()
		$TextureRect.texture = load("res://Assets/Background/Radar/"+destinationSettings.backgroundFile)
		situation["type"] = destinationSettings.type
		situation["difficulty"] = destinationSettings.difficulty
		situationDone = destinationSettings.situationDone
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
	toMainMenu.emit()
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
	destinationSettings.situationDone = false
	destinationSettings.save()
	sendBattlereport.emit(false,value)


func _on_next_destination_data(value:Dictionary):
	nextDestination.emit(value)
	
func generateNextDestination(currentRound:int):
	var merchant:bool = true
	var rand = randi() % 2
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

func _on_victory(value):
	for ch in main.get_children():
		ch.hide()
	%endTitle.text = "VICTOIRE"
	%endScore.text = "Votre score : "+str(calcScore())
	%EndScreen.show()
	$MarginContainer/VBoxContainer/ButtonContainer.hide()
	gameFinished = true

func _on_defeat(value):
	for ch in main.get_children():
		ch.hide()
	%endTitle.text = "DEFAITE"
	%endScore.hide()
	%EndScreen.show()
	$MarginContainer/VBoxContainer/ButtonContainer.hide()
	gameFinished = true

func calcScore()->int:
	return 0

func _on_to_main_menu_pressed():
	toMainMenu.emit()
