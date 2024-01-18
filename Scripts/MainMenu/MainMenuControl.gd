extends Control

signal toCrewcreator()
signal loadGame()

@onready var mainMenu = %MainMenu
@onready var optionsMenu = %OptionsMenu
@onready var leaderboard = %Leaderboard

# Called when the node enters the scene tree for the first time.
func _ready():
	optionsMenu.hide()
	mainMenu.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_options_menu_exit():
	optionsMenu.hide()
	mainMenu.show()


func _on_options_pressed():
	optionsMenu.show()
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


func _on_leaderboard_pressed():
	optionsMenu.hide()
	mainMenu.hide()
	leaderboard.show()
