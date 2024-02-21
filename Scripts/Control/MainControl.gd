extends Node
@onready var mainMenu = preload("res://Scenes/MainMenu/MainMenuScene.tscn")
@onready var gameStart = preload("res://Scenes/GameStart/GameStartWrapper.tscn")
@onready var objective = preload("res://Scenes/ObjectiveScene.tscn")
@onready var destination = preload("res://Scenes/Destination/destinationMain.tscn")

@onready var musicChannel = %Music
@onready var vfxChannel = %SFX

var objectiveNode
# Called when the node enters the scene tree for the first time.
func _ready():
	musicChannel.autoplay = true
	musicChannel.stream = ResourceLoader.load("res://Assets/Audio/Music/music (2).mp3")
	musicChannel.play()
	Input.set_custom_mouse_cursor(ResourceLoader.load("res://Assets/Cursors/cursorCanClick.png"),Input.CURSOR_POINTING_HAND,Vector2i(32,32))
	Input.set_custom_mouse_cursor(ResourceLoader.load("res://Assets/Cursors/cursorObserve.png"),Input.CURSOR_HELP,Vector2i(32,32))
	Input.set_custom_mouse_cursor(ResourceLoader.load("res://Assets/Cursors/cursorAim.png"),Input.CURSOR_IBEAM,Vector2i(32,32))
	Input.set_custom_mouse_cursor(ResourceLoader.load("res://Assets/Cursors/cursorCantClick.png"),Input.CURSOR_FORBIDDEN,Vector2i(32,32))
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


func _back_to_main_menu(value:bool = false):
	if value:
		resetSavefiles()
	else:
		_save()
	for c in $Game.get_children():
		c.queue_free()
	var mainMenuScene = mainMenu.instantiate()
	mainMenuScene.toCrewcreator.connect(_on_root_to_crewcreator)
	mainMenuScene.loadGame.connect(_load_game)
	$Game.add_child(mainMenuScene)
	musicChannel.stream = ResourceLoader.load("res://Assets/Audio/Music/music (2).mp3")
	musicChannel.play()

func _load_game():
	var objectiveScene = objective.instantiate().init(true,{})
	var destinationScene = destination.instantiate().init(true)
	
	destinationScene.save.connect(_save)
	destinationScene.toMainMenu.connect(_back_to_main_menu)
	destinationScene.nextDestination.connect(_on_next_destination)
	destinationScene.sendBattlereport.connect(objectiveScene.analyze)
	
	objectiveScene.defeat.connect(destinationScene._on_victory)
	objectiveScene.victory.connect(destinationScene._on_defeat)
	objectiveScene.newData.connect(destinationScene._on_objectiveUpdate_received)
	
	objectiveNode = str(objectiveScene)
	
	for c in $Game.get_children():
		c.queue_free()
		
	$Game.add_child(objectiveScene)
	$Game.add_child(destinationScene)
	musicChannel.stream = ResourceLoader.load("res://Assets/Audio/Music/music (3).mp3")
	musicChannel.play()

func _on_gamestart_to_main_menu():
	for c in $Game.get_children():
		c.queue_free()
	var mainMenuScene = mainMenu.instantiate()
	mainMenuScene.toCrewcreator.connect(_on_root_to_crewcreator)
	mainMenuScene.loadGame.connect(_load_game)
	$Game.add_child(mainMenuScene)
	musicChannel.stream = ResourceLoader.load("res://Assets/Audio/Music/music (2).mp3")
	musicChannel.play()


func _on_gamestart_to_start_game(objData, crewData):
	resetSavefiles()
	var objectiveScene = objective.instantiate().init(false,objData)
	
	Game.gameSettings = GameSettings.create()
	Game.gameSettings.save()
	Game.update()
	
	var destinationSettings = DestinationSettings.load_or_create()
	destinationSettings.name = "Quelques part, dans le vide"
	destinationSettings.flavor = "..."
	destinationSettings.backgroundFile = "BlueRadar/blueRadar (5).png"
	destinationSettings.difficulty = 1
	destinationSettings.type = "MERCHANT"
	destinationSettings.started = true
	destinationSettings.save()
	
	var destinationScene = destination.instantiate().init(false)
	
	destinationScene.save.connect(_save)
	destinationScene.toMainMenu.connect(_back_to_main_menu)
	destinationScene.nextDestination.connect(_on_next_destination)
	destinationScene.sendBattlereport.connect(objectiveScene.analyze)
	
	objectiveScene.defeat.connect(destinationScene._on_defeat)
	objectiveScene.victory.connect(destinationScene._on_victory)
	objectiveScene.newData.connect(destinationScene._on_objectiveUpdate_received)
	
	objectiveNode = str(objectiveScene)
	
	Game.crew = crewData
	
	for c in $Game.get_children():
		c.queue_free()
		
	$Game.add_child(objectiveScene)
	$Game.add_child(destinationScene)
	musicChannel.stream = ResourceLoader.load("res://Assets/Audio/Music/music (3).mp3")
	musicChannel.play()

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
	destinationScene.sendBattlereport.connect($Game.get_children()[0].analyze)
	
	$Game.get_children()[0].victory.connect(destinationScene._on_victory)
	$Game.get_children()[0].defeat.connect(destinationScene._on_defeat)
	$Game.get_children()[0].newData.connect(destinationScene._on_objectiveUpdate_received)
	
	Game.currentRound+=1
	
	for c in $Game.get_children().size():
		if c != 0:
			$Game.get_children()[c].queue_free()
	$Game.add_child(destinationScene)

func _save():
	Game.saveGameSetting()
	for c in $Game.get_children():
		if c.has_signal("save"):
			c.forceSave()

func _on_objective_victory(objectiveResult):
	pass # Replace with function body.

func resetSavefiles():
	var objSett = ObjectiveSettings.load_or_create()
	objSett = objSett.reset()
	objSett.save()
	var destSett = DestinationSettings.load_or_create()
	destSett.reset()
	destSett.save()
	var gameSett = GameSettings.load_or_create()
	gameSett.reset()
	gameSett.save()
