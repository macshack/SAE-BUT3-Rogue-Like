extends Node
@onready var mainMenu = preload("res://Scenes/MainMenu/MainMenuScene.tscn")
@onready var gameStart = preload("res://Scenes/GameStart/GameStartWrapper.tscn")
@onready var objective = preload("res://Scenes/ObjectiveScene.tscn")
@onready var destination = preload("res://Scenes/Destination/destinationMain.tscn")

var objectiveNode
# Called when the node enters the scene tree for the first time.
func _ready():
	var mainMenuScene = mainMenu.instantiate()
	mainMenuScene.toCrewcreator.connect(_on_root_to_crewcreator)
	mainMenuScene.loadGame.connect(_load_game)
	$Game.add_child(mainMenuScene)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_root_to_crewcreator():
	var gameStartScene = gameStart.instantiate()
	gameStartScene.mainMenu.connect(_on_gamestart_to_main_menu)
	gameStartScene.startGame.connect(_on_gamestart_to_start_game)
	$Game.add_child(gameStartScene)


func _back_to_main_menu():
	_save()
	for c in $Game.get_children():
		c.queue_free()
	var mainMenuScene = mainMenu.instantiate()
	mainMenuScene.toCrewcreator.connect(_on_root_to_crewcreator)
	mainMenuScene.loadGame.connect(_load_game)
	$Game.add_child(mainMenuScene)

func _load_game():
	var objectiveScene = objective.instantiate().init(true,{})
	var destinationScene = destination.instantiate().init(true)
	
	destinationScene.save.connect(_save)
	destinationScene.toMainMenu.connect(_back_to_main_menu)
	destinationScene.nextDestination.connect(_on_next_destination)
	
	objectiveScene.defeat.connect(_on_objective_defeat)
	objectiveScene.victory.connect(_on_objective_victory)
	objectiveScene.newData.connect(destinationScene._on_objectiveUpdate_received)
	
	objectiveNode = str(objectiveScene)
	
	for c in $Game.get_children():
		c.queue_free()
		
	$Game.add_child(objectiveScene)
	$Game.add_child(destinationScene)

func _on_gamestart_to_main_menu():
	var mainMenuScene = mainMenu.instantiate()
	mainMenuScene.toCrewcreator.connect(_on_root_to_crewcreator)
	$Game.add_child(mainMenuScene)


func _on_gamestart_to_start_game(objData, crewData):
	var objectiveScene = objective.instantiate().init(false,objData)
	
	Game.gameSettings.reset()
	Game.gameSettings.save()
	
	var destinationSettings = DestinationSettings.load_or_create()
	destinationSettings.name = "Quelques part, dans le vide"
	destinationSettings.flavor = "..."
	destinationSettings.backgroundFile = "BlueRadar/blueRadar (5).png"
	destinationSettings.difficulty = 1
	destinationSettings.type = "MERCHANT"
	destinationSettings.save()
	
	var destinationScene = destination.instantiate().init(false)
	
	destinationScene.save.connect(_save)
	destinationScene.toMainMenu.connect(_back_to_main_menu)
	destinationScene.nextDestination.connect(_on_next_destination)
	
	objectiveScene.defeat.connect(_on_objective_defeat)
	objectiveScene.victory.connect(_on_objective_victory)
	objectiveScene.newData.connect(destinationScene._on_objectiveUpdate_received)
	
	objectiveNode = str(objectiveScene)
	
	Game.crew = crewData
	
	for c in $Game.get_children():
		c.queue_free()
		
	$Game.add_child(objectiveScene)
	$Game.add_child(destinationScene)

func _on_next_destination(value):
	var destinationSettings = DestinationSettings.load_or_create() 
	
	destinationSettings.name = value["name"]
	destinationSettings.flavor = value["flavor"]
	destinationSettings.backgroundFile = value["background"]
	destinationSettings.difficulty = value["difficulty"]
	destinationSettings.type = value["type"]
	destinationSettings.situationDone = false
	destinationSettings.save()
	
	var destinationScene = destination.instantiate().init(true)
	
	destinationScene.save.connect(_save)
	destinationScene.toMainMenu.connect(_back_to_main_menu)
	destinationScene.nextDestination.connect(_on_next_destination)
	
	$Game.get_children()[0].newData.connect(destinationScene._on_objectiveUpdate_received)
	
	for c in $Game.get_children().size():
		if c != 0:
			$Game.get_children()[c].queue_free()
	$Game.add_child(destinationScene)

func _save():
	Game.saveGameSetting()
	for c in $Game.get_children():
		c.forceSave()

func _on_objective_defeat(objectiveResult):
	pass # Replace with function body.


func _on_objective_victory(objectiveResult):
	pass # Replace with function body.
