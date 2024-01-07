extends Node
@onready var mainMenu = preload("res://Scenes/MainMenu/MainMenuScene.tscn")
@onready var gameStart = preload("res://Scenes/GameStart/GameStartWrapper.tscn")
@onready var objective = preload("res://Scenes/ObjectiveScene.tscn")
@onready var destination = preload("res://Scenes/DestinationScene.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	var mainMenuScene = mainMenu.instantiate()
	mainMenuScene.toCrewcreator.connect(_on_root_to_crewcreator)
	$Game.add_child(mainMenuScene)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_root_to_crewcreator():
	var gameStartScene = gameStart.instantiate()
	gameStartScene.mainMenu.connect(_on_gamestart_to_main_menu)
	gameStartScene.startGame.connect(_on_gamestart_to_start_game)
	$Game.add_child(gameStartScene)


func _on_gamestart_to_main_menu():
	var mainMenuScene = mainMenu.instantiate()
	mainMenuScene.toCrewcreator.connect(_on_root_to_crewcreator)
	$Game.add_child(mainMenuScene)


func _on_gamestart_to_start_game(objData, crewData):
	var objectiveScene = objective.instantiate().init(objData)
	var destinationScene = destination.instantiate()
	objectiveScene.defeat.connect(_on_objective_defeat)
	objectiveScene.victory.connect(_on_objective_victory)
	Game.crew = crewData
	for c in $Game.get_children():
		c.queue_free()
	$Game.add_child(objectiveScene)
	$Game.add_child(destinationScene)


func _on_objective_defeat(objectiveResult):
	pass # Replace with function body.


func _on_objective_victory(objectiveResult):
	pass # Replace with function body.
