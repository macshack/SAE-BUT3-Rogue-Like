extends Control

var loadingNameplate = preload("res://Scenes/MainMenu/loadingCrewmateNameplate.tscn")

signal toCrewcreator()
signal loadGame()

@onready var mainMenu = %MainMenu
@onready var optionsMenu = %OptionsMenu
@onready var leaderboard = %Leaderboard

@onready var loadingPreview = %LoadingPreview
@onready var objLabel = %objLabel
@onready var objBar = %objBar
@onready var objBarLabel = %objBarLabel
@onready var destIcon = %destIcon
@onready var situationType = %situationType
@onready var creditsLabel = %creditsLabel
@onready var crewBox = %crewBox

@onready var tempObjSettings = ObjectiveSettings.load_or_create()
@onready var tempDestSettings = DestinationSettings.load_or_create()
@onready var tempGameSettings = GameSettings.load_or_create()

# Called when the node enters the scene tree for the first time.
func _ready():
	if tempDestSettings.started:
		objLabel.text = tempObjSettings.title
		objBar.value = tempObjSettings.current
		objBar.max_value = tempObjSettings.goal
		objBarLabel.text = str(tempObjSettings.current)+"/"+str(tempObjSettings.goal)
		creditsLabel.text = "Credits : "+str(tempGameSettings.credits)+"C"
		destIcon.texture = ResourceLoader.load("res://Assets/Background/Radar/"+tempDestSettings.backgroundFile)
		match(tempDestSettings.type):
			"FIGHT":
				situationType.texture = ResourceLoader.load("res://Assets/Icons/fightIcon.png")
			"BOSS":
				situationType.texture = ResourceLoader.load("res://Assets/Icons/bossIcon.png")
			_:
				situationType.texture = ResourceLoader.load("res://Assets/Icons/merchantIcon.png")
		for crewmate in tempGameSettings.playerCrew:
			var np = loadingNameplate.instantiate().init(crewmate)
			crewBox.add_child(np)
		loadingPreview.show()
	else:
		loadingPreview.hide()
	optionsMenu.hide()
	mainMenu.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_options_menu_exit():
	optionsMenu.hide()
	loadingPreview.show()
	mainMenu.show()


func _on_options_pressed():
	optionsMenu.show()
	loadingPreview.hide()
	mainMenu.hide()


func _on_quit_pressed():
	get_tree().quit()


func _on_load_pressed():
	loadGame.emit()


func _on_start_pressed():
	toCrewcreator.emit()
	self.queue_free()


func _on_button_pressed():
	optionsMenu.hide()
	leaderboard.hide()
	mainMenu.show()
	loadingPreview.show()


func _on_leaderboard_pressed():
	optionsMenu.hide()
	mainMenu.hide()
	loadingPreview.hide()
	leaderboard.show()
	
