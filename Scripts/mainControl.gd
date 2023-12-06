extends Node

@onready var mainMenu = preload("res://Scenes/MainMenuScene.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Game.add_child(mainMenu.instantiate())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func loadNewScene(link):
	for c in $Game.get_children():
		c.queue_free()
	var newScene = load(link)
	$Game.add_child(newScene.instantiate())
