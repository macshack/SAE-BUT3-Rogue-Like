extends Node

@onready var mainMenu = preload("res://Scenes/MainMenuScene.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	self.add_child(mainMenu.instantiate())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func loadNewScene(link):
	for c in self.get_children():
		if !c is AudioStreamPlayer:
			c.queue_free()
		
	var newScene = load(link)
	self.add_child(newScene.instantiate())
