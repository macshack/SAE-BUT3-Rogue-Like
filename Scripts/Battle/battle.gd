extends Control

@onready var EnemyCrewContainer = %EnemyCrewContainer

var enemyBattleNameplate = preload("res://Scenes/Battle/enemyBattleNameplate.tscn")

signal textbox_closed

var is_defending = false

var enemyTarget: int

# Called when the node enters the scene tree for the first time.
func _ready():
	
	for i in JsonHandling.crewmate_data.size():
		var tab: Array[int] = [JsonHandling.crewmate_data[str(i)].skills[0], JsonHandling.crewmate_data[str(i)].skills[1]]
		var crewmate = Crewmate.new(JsonHandling.crewmate_data[str(i)].identity, JsonHandling.crewmate_data[str(i)].background, JsonHandling.crewmate_data[str(i)].icon, tab, JsonHandling.crewmate_data[str(i)].hirePrice)
		var enemy = Enemy.new(JsonHandling.crewmate_data[str(i)].identity, JsonHandling.crewmate_data[str(i)].icon)
		Game.crew.append(crewmate)
		Game.enemyCrew.append(enemy)
	
	for c in Game.enemyCrew.size():
		var new = enemyBattleNameplate.instantiate().init(c)
		new.click_on_nameplate.connect(_on_enemy_click)
		EnemyCrewContainer.add_child(new)
	
	$Textbox.hide()
	$ActionPanel.hide()
	
	display_text("An enemy crew appears !")
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

func _on_enemy_click(index: int):
	enemyTarget = index
	print("ENNEMY INDEX: " + str(enemyTarget))

"""func _on_attack_pressed():
	display_text("You attack the enemy !")
	await textbox_closed
	
	EnemyState.health = max(0, EnemyState.health - PlayerState.attack)
	set_health($EnnemyContainer/ProgressBar, EnemyState.health, EnemyState.health_max)
	
	$AnimationPlayer.play("enemy_damaged")
	await $AnimationPlayer.animation_finished
	
	display_text("You dealt %d damage !" % PlayerState.attack)
	await textbox_closed
	
	enemy_turn()"""
	
"""func enemy_turn():
	display_text("Fischstick takes a swing at you !")
	await textbox_closed
	
	if is_defending == false:
		PlayerState.health = max(0, PlayerState.health - EnemyState.attack)
		set_health($PlayerPanel/PlayerData/ProgressBar, PlayerState.health, PlayerState.health_max)
	
	$AnimationPlayer.play("shake")
	await $AnimationPlayer.animation_finished
	
	display_text("Fishstick dealts %d damage !" % EnemyState.attack)
	await textbox_close"""
