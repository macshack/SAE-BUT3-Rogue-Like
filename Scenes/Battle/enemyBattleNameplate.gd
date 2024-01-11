extends VBoxContainer

signal click_on_nameplate(index: int) 

@onready var healthbar = %HealthBar
@onready var icon = %Icon

var enemyIndex:int

func _ready():
	if Game.enemyCrew.size() <= 0:
		return 0
	if Game.enemyCrew[enemyIndex] is Enemy:
		icon.texture = load("res://Assets/Portraits/"+Game.enemyCrew[enemyIndex].icon)
		healthbar.max_value = Game.enemyCrew[enemyIndex].healthMax
		healthbar.value = Game.enemyCrew[enemyIndex].healthCurrent
		$HealthBar/Label.text = "Hp: %d/%d" % [healthbar.value, healthbar.max_value]
	
func _process(delta):
	if enemyIndex >= Game.enemyCrew.size():
		return 0
	
	if Game.enemyCrew[enemyIndex] is Enemy:
		icon.texture = load("res://Assets/Portraits/"+Game.enemyCrew[enemyIndex].icon)
		healthbar.max_value = Game.enemyCrew[enemyIndex].healthMax
		healthbar.value = Game.enemyCrew[enemyIndex].healthCurrent
		$HealthBar/Label.text = "Hp: %d/%d" % [healthbar.value, healthbar.max_value]

func init(value):
	enemyIndex = value
	return self

func set_health(progress_bar, health, max_health):
	healthbar.value = health
	healthbar.max_value = max_health
	healthbar.get_node("Label").text = "Hp: %d/%d" % [health, max_health]

func _on_gui_input(event):
	if event is InputEventMouseButton  && event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
		click_on_nameplate.emit(enemyIndex)
