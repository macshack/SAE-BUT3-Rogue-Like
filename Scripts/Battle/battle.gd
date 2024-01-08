extends Control

@onready var EnemyCrewContainer = %EnemyCrewContainer
@onready var PlayerName = %PlayerName
@onready var HP = %HP
@onready var enemyTarget: int

var enemyBattleNameplate = preload("res://Scenes/Battle/enemyBattleNameplate.tscn")

var character: Character

var isFunctionRunning = false

var i = 0

var is_defending = false

signal textbox_closed

# Called when the node enters the scene tree for the first time.
func _ready():
	
	#Update le PlayerPanel a chaque changement de tour
	#Faire les fonctions attack, ennemyTurn, (defend, skill)
	#Mettre au propre l'interface
	
	for i in JsonHandling.crewmate_data.size():
		var tab: Array[int] = [JsonHandling.crewmate_data[str(i)].skills[0], JsonHandling.crewmate_data[str(i)].skills[1]]
		var crewmate = Crewmate.new(JsonHandling.crewmate_data[str(i)].identity, JsonHandling.crewmate_data[str(i)].background, JsonHandling.crewmate_data[str(i)].icon, tab, JsonHandling.crewmate_data[str(i)].hirePrice)
		var enemy = Enemy.new(JsonHandling.crewmate_data[str(i)].identity, JsonHandling.crewmate_data[str(i)].icon)
		Game.crew.append(crewmate)
		Game.enemyCrew.append(enemy)
	
	var order = orderFight(Game.crew, Game.enemyCrew)
	print(order)
	
	for c in Game.enemyCrew.size():
		var new = enemyBattleNameplate.instantiate().init(c)
		new.click_on_nameplate.connect(_on_enemy_click)
		EnemyCrewContainer.add_child(new)
	
	$Textbox.hide()
	$ActionPanel.hide()
	
	display_text("An enemy crew appears !")
	await textbox_closed
	$ActionPanel.show()
	
	character = order[i][0]
	print("HEALTHMAX: " + str(character.healthMax))
	print("HEALTHCURRENT: " + str(character.healthCurrent))
	
func _input(event):
	if (Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) and $Textbox.visible:
		$Textbox.hide()
		emit_signal("textbox_closed")

func display_text(text):
	$Textbox.show()
	$Textbox/Label.text = text

func _process(delta):
	if character is Crewmate:
		updatePlayerPanel(character)
	elif character is Enemy:
		if not isFunctionRunning:
			# Si elle n'est pas en cours d'exécution, la démarrer
			startFunction()

func startFunction():
	# Marquer la fonction comme étant en cours d'exécution
	isFunctionRunning = true

	# Appeler la fonction à exécuter
	enemy_turn()

func _on_defend_pressed():
	is_defending = true
	display_text("You are on guard !")
	await textbox_closed	

func _on_enemy_click(index: int):
	enemyTarget = index
	print("ENNEMY INDEX: " + str(enemyTarget))

func tri_insertion(tableau):
	var longueur = tableau.size()
	for i in range(1, longueur):
		var cle = tableau[i]
		var j = i - 1
		while j >= 0 and tableau[j][1] < cle[1]:
			tableau[j + 1] = tableau[j]
			j = j - 1
		tableau[j + 1] = cle
	return tableau

func updatePlayerPanel(crewmate: Crewmate):
	PlayerName.text = crewmate.identity
	HP.text = "Hp: %d/%d" % [crewmate.healthCurrent, crewmate.healthMax]

func orderFight(crewTab: Array[Crewmate], enemyTab:Array[Enemy]):
	var enemySpeed: Array = []
	var crewSpeed: Array = []
	var Speed: Array = []
	for c in crewTab:
		crewSpeed.append([c, c.speedBase])
	for e in enemyTab:
		enemySpeed.append([e, e.speedBase])
	Speed = crewSpeed +  enemySpeed 
	Speed = tri_insertion(Speed)
	return Speed

func _on_attack_pressed():
	display_text("You attack the enemy !")
	await textbox_closed
	
	Game.enemyCrew[enemyTarget].healthCurrent = max(0, Game.enemyCrew[enemyTarget].healthCurrent - character.attackCurrent)
	
	$AnimationPlayer.play("enemy_damaged")
	await $AnimationPlayer.animation_finished
	
	display_text("You dealt %d damage !" % character.attackBase)
	await textbox_closed
	
	var order = orderFight(Game.crew, Game.enemyCrew)
	if i >= order.size()-1:
		i = -1
	character = order[i+1][0]
	i = i+1
	
func enemy_turn():
	
	var index = randi() % Game.crew.size()
	
	display_text(character.identity + " takes a swing at " + Game.crew[index].identity)
	await textbox_closed
	
	Game.crew[index].healthCurrent = max(0, Game.crew[index].healthCurrent - character.attackBase)
	
	$AnimationPlayer.play("shake")
	await $AnimationPlayer.animation_finished
	
	display_text(character.identity + " dealts %d damage " % character.attackBase + "to " + Game.crew[index].identity)
	await textbox_closed
	
	var order = orderFight(Game.crew, Game.enemyCrew)
	if i >= order.size()-1:
		i = -1
	character = order[i+1][0]
	i = i+1
	
	isFunctionRunning = false

