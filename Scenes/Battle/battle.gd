extends Control

signal textbox_closed

var is_defending = false

# Called when the node enters the scene tree for the first time.
func _ready():
	set_health($PlayerPanel/PlayerData/ProgressBar, PlayerState.health, PlayerState.health_max)
	set_health($EnnemyContainer/ProgressBar, EnemyState.health, EnemyState.health_max)
	
	$Textbox.hide()
	$ActionPanel.hide()
	
	display_text("A FISHSTICK appears !")
	await textbox_closed
	$ActionPanel.show()

func set_health(progress_bar, health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health
	progress_bar.get_node("Label").text = "Hp: %d/%d" % [health, max_health]
	
func _input(event):
	if (Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) and $Textbox.visible:
		$Textbox.hide()
		emit_signal("textbox_closed")

func display_text(text):
	$Textbox.show()
	$Textbox/Label.text = text

func _process(delta):
	pass

func _on_defend_pressed():
	is_defending = true
	display_text("You are on guard !")
	await textbox_closed	

func _on_attack_pressed():
	display_text("You attack the enemy !")
	await textbox_closed
	
	EnemyState.health -= max(0, EnemyState.health - PlayerState.attack)
	set_health($EnnemyContainer/ProgressBar, EnemyState.health, EnemyState.health_max)
	
	$AnimationPlayer.play("enemy_damaged")
	await $AnimationPlayer.animation_finished
	
	display_text("You dealt %d damage !" % PlayerState.attack)
	await textbox_closed
	
	enemy_turn()
	
func enemy_turn():
	display_text("Fischstick takes a swing at you !")
	await textbox_closed
	
	if is_defending == false:
		PlayerState.health -= max(0, PlayerState.health - EnemyState.attack)
		set_health($PlayerPanel/PlayerData/ProgressBar, PlayerState.health, PlayerState.health_max)
	
	$AnimationPlayer.play("shake")
	await $AnimationPlayer.animation_finished
	
	display_text("Fishstick dealts %d damage !" % EnemyState.attack)
	await textbox_closed
