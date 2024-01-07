extends Control

signal toCrewcreator()

@onready var mainMenu = %MainMenu
@onready var loadMenu = %LoadSaveMenu
@onready var optionsMenu = %OptionsMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	optionsMenu.hide()
	loadMenu.hide()
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
	loadMenu.show()
	mainMenu.hide()


func _on_start_pressed():
	toCrewcreator.emit()
	self.queue_free()
