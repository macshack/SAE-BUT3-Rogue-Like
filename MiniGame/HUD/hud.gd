extends Control

var pLifeIcon := preload("res://MiniGame/HUD/life_icon.tscn")

@onready var lifeContainer := %LifeContainer
@onready var scoreLabel := %Score

var score: int = 0

func _ready():
	clearLives()
	
	Signals.connect("on_player_life_changed", _on_player_life_changed)
	Signals.connect("on_score_increment", _on_score_increment)

func clearLives():
	for child in lifeContainer.get_children():
		lifeContainer.remove_child(child)
		child.queue_free()

func setLives(lives: int):
	clearLives()
	for i in range(lives):
		lifeContainer.add_child(pLifeIcon.instantiate())

func _on_player_life_changed(life: int):
	setLives(life)

func _on_score_increment(amount: int):
	score += amount
	scoreLabel.text = str(score)


func _on_button_pressed():
	self.queue_free()
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
	
