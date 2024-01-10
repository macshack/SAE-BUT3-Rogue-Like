extends Panel

signal toMainMenu()
signal emitFightResult()
signal nextDestination()

var situationDone = false

var merchantScene = preload("res://Scenes/Merchant/Merchant.tscn")
var fightScene = preload("res://Scenes/Battle/battle.tscn")

var nextDestinationScene = preload("res://Scenes/Destination/nextDestinationScene.tscn")

var crewmateNameplateScene = preload("res://Scenes/Destination/crewmateNameplate.tscn")

var destination = {}
var situation = {}

var nameplateUpdateTimer = 1

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
				pass
			"MERCHANT":
				var merchant = merchantScene.instantiate()
				situationNode = str(merchant)
				situationDone = true
				if destinationSettings:
					destinationSettings.situationDone = true
					destinationSettings.save()
				main.add_child(merchant)
	else:
		var merchant = merchantScene.instantiate()
		situationNode = str(merchant)
		situationDone = true
		if destinationSettings:
			destinationSettings.situationDone = true
			destinationSettings.save()
		
		main.add_child(merchant)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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

func init(test:bool):
	destinationSettings = DestinationSettings.load_or_create()
	$TextureRect.texture = load("res://Assets/Background/Radar/"+destinationSettings.backgroundFile)
	situation["type"] = destinationSettings.type
	situation["difficulty"] = destinationSettings.difficulty
	situationDone = destinationSettings.situationDone
	return self

func _on_inventory_pressed():
	for i in main.get_children():
		i.hide()
	inventory.refreshInventory()
	inventory.show()

func forceSave():
	destinationSettings.save()

func _on_situation_pressed():
	for i in main.get_children():
		i.hide()
	for c in main.get_children():
		crewmates.show()
		if str(c) == situationNode:
			c.show()


func _on_equipage_pressed():
	for i in main.get_children():
		i.hide()
	crew.show()


func _on_menuSettings_pressed():
	menuNode.hide()
	optionsNode.show()


func _on_menuSauvegarder_pressed():
	pass # Replace with function body.


func _on_menuQuitter_pressed():
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
			print(Game.tier1dest[randi()%Game.tier1dest.size()])
			var scene = nextDestinationScene.instantiate().init(Game.tier1dest[randi()%Game.tier1dest.size()])

			scene.click.connect(_on_next_destination_data)
			nextDestinationContainerNode.add_child(scene)
		elif currentRound == 5:
			pass
		elif currentRound < 10:
			var scene = nextDestinationScene.instantiate().init(Game.tier1dest[randi()%Game.tier1dest.size()])
			scene.click.connect(_on_next_destination_data)
			nextDestinationContainerNode.add_child(scene)
		elif currentRound == 10:
			pass
		elif currentRound < 15:
			var scene = nextDestinationScene.instantiate().init(Game.tier2dest[randi()%Game.tier2dest.size()])
			scene.click.connect(_on_next_destination_data)
			nextDestinationContainerNode.add_child(scene)
		elif currentRound == 15:
			pass
		elif currentRound < 20:
			var scene = nextDestinationScene.instantiate().init(Game.tier3dest[randi()%Game.tier3dest.size()])
			scene.click.connect(_on_next_destination_data)
			nextDestinationContainerNode.add_child(scene)
		elif currentRound == 20:
			pass
		elif currentRound > 20:
			var scene = nextDestinationScene.instantiate().init(Game.tier4dest[randi()%Game.tier4dest.size()])
			scene.click.connect(_on_next_destination_data)
			nextDestinationContainerNode.add_child(scene)


func _on_destination_pressed():
	if (situationDone):
		for i in main.get_children():
			i.hide()
		nextDestinationNode.show()
