extends Control

#PROBLEMES AVEC LES TEXTBOX,peux attaquer 2x pdt un tour

@onready var EnemyCrewContainer = %EnemyCrewContainer
@onready var PlayerName = %PlayerName
@onready var HP = %HP
@onready var enemyTarget: int = -1
@onready var textboxNode = %Textbox
@onready var textboxLabelNode = %TextboxLabel
@onready var playerActionNode = %Actions
@onready var gameOver = %GameOver
@onready var victory = %Victory
@onready var batlle = %Battle
@onready var Start = %Start

@onready var damageInflicted: int = 0
@onready var damageSuffered: int = 0
@onready var nbEnnemiesKilled: int = 0
@onready var nbRound: int = 0

signal victor
signal gameover
signal start

var startEnd = false

var startFight = false

var enemyBattleNameplate = preload("res://Scenes/Battle/enemyBattleNameplate.tscn")

var character: Character

var order: Array = []

var isFunctionRunning = false

var i = 0

var is_defending = false

signal textbox_closed

# Called when the node enters the scene tree for the first time.
func _ready():
	
	gameOver.hide()
	victory.hide()
	batlle.hide()
	Start.show()
	$".".connect("start", _on_start)

func _on_start():
	
	Start.hide()
	batlle.show()
	
	for i in JsonHandling.crewmate_data.size():
		var tab: Array[int] = [JsonHandling.crewmate_data[str(i)].skills[0], JsonHandling.crewmate_data[str(i)].skills[1]]
		var crewmate = Crewmate.new(JsonHandling.crewmate_data[str(i)].identity, JsonHandling.crewmate_data[str(i)].background, JsonHandling.crewmate_data[str(i)].icon, tab, JsonHandling.crewmate_data[str(i)].hirePrice)
		var enemy = Enemy.new(JsonHandling.crewmate_data[str(i)].identity, JsonHandling.crewmate_data[str(i)].icon)
		crewmate.attackCurrent = 1
		enemy.attackBase = 10
		Game.crew.append(crewmate)
		Game.enemyCrew.append(enemy)
	
	order = orderFight(Game.crew, Game.enemyCrew)
	
	for c in Game.enemyCrew.size():
		var new = enemyBattleNameplate.instantiate().init(c)
		new.click_on_nameplate.connect(_on_enemy_click)
		EnemyCrewContainer.add_child(new)
	
	textboxNode.hide()
	
	display_text("An enemy crew appears !")
	await textbox_closed
	
	character = order[i][0]
	
	startFight = true
	
func _input(event):
	if (Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) and textboxNode.visible:
		textboxNode.hide()
		emit_signal("textbox_closed")

func display_text(text):
	textboxNode.show()
	textboxLabelNode.text = text

func _process(delta):
	if startEnd:
		return 0
	if startFight:
		if EnemyCrewContainer != null and EnemyCrewContainer.get_child_count() <= 0:
			display_text("Victory !")
			await textbox_closed
			emit_signal("victor")
		if character is Crewmate:
			updatePlayerPanel(character)
			for action in playerActionNode.get_children():
				action.disabled = false
		elif character is Enemy:
			for action in playerActionNode.get_children():
				action.disabled = true
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
	#print("ENNEMY INDEX: " + str(enemyTarget))

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
		crewSpeed.append([c,c.speedBase])
	for e in enemyTab:
		enemySpeed.append([e, e.speedBase])
	Speed = crewSpeed +  enemySpeed 
	Speed = tri_insertion(Speed)
	return Speed

func erase_enemy():
	for en in Game.enemyCrew:
		if en.healthCurrent <= 0:
			var id = en.identity
			Game.enemyCrew.erase(en)
			for c in order:
				if c[0] is Enemy and c[0].identity == id:
					order.erase(c)
					#print("ORDER: ", order)

func ko_crewmate():
	for crew in Game.crew:
		if crew.healthCurrent <= 0:
			var id = crew.identity
			for c in order:
				if c[0] is Crewmate and c[0].identity == id:
					order.erase(c)
					#print("ERASE crewmate: ", c)
					#print("ORDER: ", order)

func _on_attack_pressed():
	
	if enemyTarget >= Game.enemyCrew.size() or enemyTarget < 0:
		display_text("Cliquez sur un ennemi !")
		await textbox_closed
		return 0
		
	display_text("You attack the enemy !")
	await textbox_closed
	
	print("BEFORE IF: ", Game.enemyCrew[enemyTarget].weakpoint)
	
	if Game.enemyCrew[enemyTarget].weakpoint[0]:
		print("ON ATTACK: ", Game.enemyCrew[enemyTarget].weakpoint)
		Game.enemyCrew[enemyTarget].healthCurrent = max(0, Game.enemyCrew[enemyTarget].healthCurrent - (character.attackCurrent + 2))
		damageInflicted = damageInflicted + character.attackCurrent + 2
		var val = character.attackCurrent + 2
		display_text("You dealt %d damage !" % val)
		await textbox_closed
	else:
		Game.enemyCrew[enemyTarget].healthCurrent = max(0, Game.enemyCrew[enemyTarget].healthCurrent - character.attackCurrent)
		damageInflicted = damageInflicted + character.attackCurrent
		display_text("You dealt %d damage !" % character.attackCurrent)
		await textbox_closed
	
	if Game.enemyCrew[enemyTarget].healthCurrent <= 0:
		var node_to_remove = %EnemyCrewContainer.get_child(enemyTarget)
		node_to_remove.queue_free()
		erase_enemy()
		nbEnnemiesKilled = nbEnnemiesKilled + 1
	
	enemyTarget = -1
	
	if i >= order.size()-1:
		i = -1
		nbRound = nbRound + 1
	character = order[i+1][0]
	i = i+1

func enemy_turn():
	
	var enemy: Enemy
	var enIndex: int
	
	for i in Game.enemyCrew.size():
		if Game.enemyCrew[i].identity == character.identity:
			enIndex = i	
	
	if Game.enemyCrew[enIndex].weakpoint[0]:
		print("INIT: ", Game.enemyCrew[enIndex].weakpoint)
		Game.enemyCrew[enIndex].weakpoint[1] = Game.enemyCrew[enIndex].weakpoint[1] - 1
		if Game.enemyCrew[enIndex].weakpoint[1] == 0:
			Game.enemyCrew[enIndex].weakpoint[0] = false
		print("FINAL: ", Game.enemyCrew[enemyTarget].weakpoint)
		display_text(Game.enemyCrew[enIndex].identity + " weakpoints STOP")
		await textbox_closed
	
	if Game.enemyCrew[enIndex].burn[0]:
		Game.enemyCrew[enIndex].burn[1] = Game.enemyCrew[enIndex].burn[1] - 1
		Game.enemyCrew[enIndex].healthCurrent = max(0, Game.enemyCrew[enIndex].healthCurrent - Game.enemyCrew[enIndex].burn[2])
		damageInflicted = damageInflicted + Game.enemyCrew[enIndex].burn[2]
		if Game.enemyCrew[enIndex].burn[1] == 0:
			Game.enemyCrew[enIndex].burn[0] = false
		display_text(character.identity + " is burning: " + str(Game.enemyCrew[enIndex].burn[2]))
		await textbox_closed
	
	if Game.enemyCrew[enIndex].stun[0]:
		Game.enemyCrew[enIndex].stun[1] = Game.enemyCrew[enIndex].stun[1] - 1
		if Game.enemyCrew[enIndex].stun[1] == 0:
			Game.enemyCrew[enIndex].stun[0] = false
		display_text(character.identity + " is stunned !")
		await textbox_closed
	else:

		var index: int = -1
		
		while Game.crew[index].healthCurrent <= 0:
			index = randi() % Game.crew.size()
		
		display_text(character.identity + " takes a swing at " + Game.crew[index].identity)
		await textbox_closed
		
		Game.crew[index].healthCurrent = max(0, Game.crew[index].healthCurrent - character.attackBase)
		damageSuffered = damageSuffered + character.attackBase
		
		display_text(character.identity + " dealts %d damage " % character.attackBase + "to " + Game.crew[index].identity)
		await textbox_closed
		
		if Game.crew[index].identity == PlayerName.text:
			updatePlayerPanel(Game.crew[index])
		
		if Game.crew[index].healthCurrent <= 0:
			ko_crewmate()
			i = i-1
	
	if crew_dead():
			startEnd = true
			display_text("Game over !")
			await textbox_closed
			gameover.emit()
	
	if i >= order.size()-1:
		i = -1
		nbRound = nbRound + 1
	character = order[i+1][0]
	i = i+1
	
	isFunctionRunning = false

func crew_dead():
	var val_bool = true
	for c in order:
		if c[0] is Crewmate:
			val_bool = false
	return val_bool
	
func _on_skill_pressed():
	
	if enemyTarget >= Game.enemyCrew.size() or enemyTarget < 0:
		display_text("Cliquez sur un ennemi !")
		await textbox_closed
		return 0
	
	display_text("You use the skill %s" % character.skillOne.skillName)
	await textbox_closed
	
	useSkill(character, character.skillOne, enemyTarget)
	
	if Game.enemyCrew[enemyTarget].healthCurrent <= 0:
		var node_to_remove = %EnemyCrewContainer.get_child(enemyTarget)
		node_to_remove.queue_free()
		erase_enemy()
	
	enemyTarget = -1
	
	if i >= order.size()-1:
		i = -1
		nbRound = nbRound + 1
	character = order[i+1][0]
	i = i+1

func _on_skill_2_pressed():
	
	if enemyTarget >= Game.enemyCrew.size() or enemyTarget < 0:
		display_text("Cliquez sur un ennemi !")
		await textbox_closed
		return 0
	
	display_text("You use the skill %s" % character.skillTwo.skillName)
	await textbox_closed
	
	useSkill(character, character.skillTwo, enemyTarget)
	
	if Game.enemyCrew[enemyTarget].healthCurrent <= 0:
		var node_to_remove = %EnemyCrewContainer.get_child(enemyTarget)
		node_to_remove.queue_free()
		erase_enemy()
	
	enemyTarget = -1
	
	if i >= order.size()-1:
		i = -1
		nbRound = nbRound + 1
	character = order[i+1][0]
	i = i+1

func useSkill(charater: Character, skill: Skill, target: int):
	var general = skill.activeAbility.general
	general = [general.name, general.flavorText, general.weaponType,
	 general.targetNumber, general.weakPointCheck, general.damageSplit]
	
	var damage = skill.activeAbility.damage
	damage = [damage.base, damage.attackModifier, damage.hpModifier]
	
	var status = skill.activeAbility.status
	var stun = [status.stun.valid, status.stun.stunDuration]
	var weakpoint = [status.weakPoint.valid, status.weakPoint.weakpointDuration]
	var burn = [status.burn.valid, status.burn.burnDuration, status.burn.burnDamage]
	
	if weakpoint[0]:
		display_text("You discover weakpoint of " + str(Game.enemyCrew[target].identity))
		await textbox_closed
		Game.enemyCrew[target].weakpoint = weakpoint
	if stun[0]:
		display_text("You stun " + str(Game.enemyCrew[target].identity))
		await textbox_closed
		Game.enemyCrew[target].stun = stun
	if burn[0]:
		display_text("You burn " + str(Game.enemyCrew[target].identity))
		await textbox_closed
		Game.enemyCrew[target].burn = burn
	
	Game.enemyCrew[target].healthCurrent = max(
		0, Game.enemyCrew[target].healthCurrent - (damage[0] + damage[1]))
	damageInflicted = damageInflicted + damage[0] + damage[1]
	
	display_text("You dealt %d damage !" % damage[0])
	await textbox_closed

func _on_start_pressed():
	emit_signal("start")


func _on_victor():
	batlle.hide()
	$ActionPanel.hide()
	$Textbox1.hide()
	victory.show()
	$Victory/StatsFight.text = "damageInflicted: " \
	+ str(damageInflicted) + "\n" + "damageSuffered: " \
	+ str(damageSuffered) + "\n"+ "nbEnnemiesKilled: " \
	+ str(nbEnnemiesKilled) + "\n"+ "nbRound: " + str(nbRound) + "\n"

func _on_gameover():
	batlle.hide()
	$ActionPanel.hide()
	$Textbox1.hide()
	gameOver.show()
	$GameOver/StatsFight.text = "damageInflicted: " \
	+ str(damageInflicted) + "\n" + "damageSuffered: " \
	+ str(damageSuffered) + "\n"+ "nbEnnemiesKilled: " \
	+ str(nbEnnemiesKilled) + "\n"+ "nbRound: " + str(nbRound) + "\n"
