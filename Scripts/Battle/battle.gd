extends Control

#PROBLEMES AVEC LES TEXTBOX,peux attaquer 2x pdt un tour

var bossFight:bool = false
var rewardObtained:bool = false

@onready var EnemyCrewContainer = %EnemyCrewContainer
@onready var PlayerName = %PlayerName
@onready var playerIcon = %crewmateIcon

@onready var attackActionNode = %Attack
@onready var defenseActionNode = %Defend
@onready var skillOneNode = %Skill1
@onready var skillTwoNode = %Skill2

@onready var HP = %HP
@onready var enemyTarget: int = -1
@onready var allyTarget:int = -1
@onready var textboxNode = %Textbox
@onready var textboxScroll = %TextboxScroll
@onready var textboxLabelNode = %TextboxLabel
@onready var playerActionNode = %Actions
@onready var gameOver = %GameOver
@onready var victory = %Victory
@onready var batlle = %Battle
@onready var Start = %Start

@onready var dmgDealt = %dmgDealt
@onready var dmgSuff = %dmgSuffered
@onready var enKilled = %enKilled
@onready var rounds = %rounds

@onready var dmgDealtTwo =%dmgDealt2
@onready var dmgSuffTwo =%dmgSuffered2
@onready var enKilledTwo = %enKilled2
@onready var roundsTwo = %rounds2

@onready var damageInflicted: int = 0
@onready var damageSuffered: int = 0
@onready var nbEnnemiesKilled: int = 0
@onready var nbRound: int = 0

@onready var nextDestButton = %nextDestination
@onready var choiceBox = %choiceBox
@onready var choiceCreditsNumber = %choiceCreditsNumber

@onready var chosenBox = %chosenBox
@onready var chosenText = %rewardText
@onready var chosenNumber = %chosenRewardNumber
@onready var chosenIcon = %chosenRewardIcon
@onready var chosenPanel = %chosenPanelNumber

@onready var actionName = %actionName
@onready var actionDesc = %actionDesc


var waitingForTarget:bool = false

signal crewmateClick()
signal victor
signal gameover
signal start
signal openDestination
signal click_on_rewards(index_rewards: int) 
signal reward(dict: Dictionary)
signal lost(dict: Dictionary)

var startEnd = false

var startFight = false

var enemyBattleNameplate = preload("res://Scenes/Battle/enemyBattleNameplate.tscn")

var characterIndex:int
var character: Character

var order: Array = []

var isFunctionRunning = false

var i = 0

var is_defending = false

signal textbox_closed
signal targetSelected

# Called when the node enters the scene tree for the first time.
func _ready():
	for cr in Game.crew:
		cr.applyModifiersToCrewmate()
	gameOver.hide()
	victory.hide()
	batlle.hide()
	Start.show()
	$".".connect("start", _on_start)

func _on_start():
	
	Start.hide()
	batlle.show()
	var randEnemy = (randi()%Game.crew.size())+1
	for enn in randEnemy:
		var en = JsonHandling.enemy_data[JsonHandling.enemy_data.keys()[ randi() % JsonHandling.enemy_data.size()]]
		var enemy = Enemy.new(en.identity,
		 en.icon, en.health,
		 en.health, en.attackPower)
		Game.enemyCrew.append(enemy)
	orderFight(Game.crew, Game.enemyCrew)
	
	for c in Game.enemyCrew.size():
		var new = enemyBattleNameplate.instantiate().init(c)
		new.click_on_nameplate.connect(_on_enemy_click)
		EnemyCrewContainer.add_child(new)
	newLine_textBox("An enemy crew appears !",0)
	character = order[i][0]
	characterIndex = order[i][2]
	
	startFight = true

func _process(delta):
	if startEnd:
		return 0
	if startFight:
		var victory_bool = true
		for en in Game.enemyCrew:
			if en.healthCurrent > 0:
				victory_bool = false
		if victory_bool:
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
	newLine_textBox(str("> "+character.identity+" entre en posture defensive."),1)
	
	var k = 0
	for c in Game.crew:
		if c.identity == character.identity:
			Game.crew[k].isdefending = true
		k = k +1
	
	_on_enemy_click(-1)
	_on_crew_nameplate_click(-1)
	nextCharacter()
	
func _on_enemy_click(index_en: int):
	enemyTarget = index_en
	for i in EnemyCrewContainer.get_children():
		if i.enemyIndex == index_en:
			i.setTarget(true)
		else:
			i.setTarget(false)
	if enemyTarget != -1:
		targetSelected.emit()

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
	playerIcon.texture = ResourceLoader.load("res://Assets/Portraits/"+crewmate.icon)
	PlayerName.text = crewmate.identity
	skillOneNode.text = crewmate.skillOne.skillName
	skillTwoNode.text = crewmate.skillTwo.skillName
	HP.text = "%d/%d" % [crewmate.healthCurrent, crewmate.healthMax]

func orderFight(crewTab: Array[Crewmate], enemyTab:Array[Enemy]):
	var enemySpeed: Array = []
	var crewSpeed: Array = []
	var Speed: Array = []
	for c in crewTab.size():
		crewSpeed.append([crewTab[c],crewTab[c].speedBase,c])
	for e in enemyTab.size():
		enemySpeed.append([enemyTab[e], enemyTab[e].speedBase,e])
	Speed = crewSpeed +  enemySpeed 
	Speed = tri_insertion(Speed)
	order = Speed

func ko_crewmate():
	for crew in Game.crew:
		if crew.healthCurrent <= 0:
			var id = crew.identity
			for c in order:
				if c[0] is Crewmate and c[0].identity == id:
					order.erase(c)

func _on_attack_pressed():
	if !waitingForTarget:
		waitingForTarget = true
		await targetSelected
		if Game.enemyCrew[enemyTarget].weakpoint[0]:
			Game.enemyCrew[enemyTarget].healthCurrent = max(0, Game.enemyCrew[enemyTarget].healthCurrent - (character.attackCurrent + 2))
			damageInflicted += (character.attackCurrent + 2)
		else:
			Game.enemyCrew[enemyTarget].healthCurrent = max(0, Game.enemyCrew[enemyTarget].healthCurrent - character.attackCurrent)
			damageInflicted += character.attackCurrent
		
		if Game.enemyCrew[enemyTarget].healthCurrent <= 0:
			EnemyCrewContainer.get_child(enemyTarget).hide()
			nbEnnemiesKilled = nbEnnemiesKilled + 1
			erase_enemy()
		
		_on_enemy_click(-1)
		_on_crew_nameplate_click(-1)
		nextCharacter()
		waitingForTarget = false

func enemy_turn():
	var enIndex: int = characterIndex
	if Game.enemyCrew[enIndex].weakpoint[0]:
		Game.enemyCrew[enIndex].weakpoint[1] -= 1
		if Game.enemyCrew[enIndex].weakpoint[1] == 0:
			Game.enemyCrew[enIndex].weakpoint[0] = false
			newLine_textBox(Game.enemyCrew[enIndex].identity + "'s weakpoint fades away.",2)
	
	if Game.enemyCrew[enIndex].burn[0]:
		Game.enemyCrew[enIndex].burn[1] = Game.enemyCrew[enIndex].burn[1] - 1
		Game.enemyCrew[enIndex].healthCurrent = max(0, Game.enemyCrew[enIndex].healthCurrent - Game.enemyCrew[enIndex].burn[2])
		damageInflicted = damageInflicted + Game.enemyCrew[enIndex].burn[2]
		newLine_textBox(character.identity + " suffered "+str(Game.enemyCrew[enIndex].burn[2])+" from burning.",2)
		if Game.enemyCrew[enIndex].burn[1] == 0:
			Game.enemyCrew[enIndex].burn[0] = false
			newLine_textBox(character.identity + " stops burning.",2)
	
	if Game.enemyCrew[enIndex].stun[0]:
		Game.enemyCrew[enIndex].stun[1] = Game.enemyCrew[enIndex].stun[1] - 1
		if Game.enemyCrew[enIndex].stun[1] == 0:
			Game.enemyCrew[enIndex].stun[0] = false
			newLine_textBox(character.identity + " is stunned !",2)
	else:
		var index: int = -42
		index = randi() % Game.crew.size()
		if Game.crew[index].healthCurrent <= 0:
			while Game.crew[index].healthCurrent <= 0:
				index = randi() % Game.crew.size()
		
		if not Game.crew[index].isdefending:
			Game.crew[index].healthCurrent = max(0, Game.crew[index].healthCurrent - character.attackBase)
			damageSuffered = damageSuffered + character.attackBase
			newLine_textBox(character.identity + " deals %d damage " % character.attackBase + "to " + Game.crew[index].identity,2)
		else:
			Game.crew[index].healthCurrent = max(0, Game.crew[index].healthCurrent - (character.attackBase/2))
			damageSuffered = damageSuffered + (character.attackBase/2)
			Game.crew[index].isdefending = false
			newLine_textBox(character.identity + " deals %d damage " % (character.attackBase/2) + "to " + Game.crew[index].identity,2)
		
		if Game.crew[index].identity == PlayerName.text:
			updatePlayerPanel(Game.crew[index])
		
		if Game.crew[index].healthCurrent <= 0:
			ko_crewmate()
			i = i-1
	
	if crew_dead():
			startEnd = true
			newLine_textBox("Game over !",0)
			gameover.emit()
	await get_tree().create_timer(1).timeout
	erase_enemy()
	nextCharacter()
	isFunctionRunning = false

func nextCharacter():
	var nextCharacter
	for act in order.size():
		if order[act][0] == character:
			if act+1 < order.size():
				nextCharacter = order[act+1][0]
	orderFight(Game.crew,Game.enemyCrew)
	for char in order.size():
		if order[char][0] == character:
			i = char
		elif order[char][0] == nextCharacter:
			i = char-1
	i = i+1
	if i > order.size()-1:
		i=0
	character = order[i][0]
	characterIndex = order[i][2]
	

func crew_dead():
	var val_bool = true
	for c in order:
		if c[0] is Crewmate:
			val_bool = false
	return val_bool
	
func _on_skill_used(whichSkill:int):
	var skill
	match(whichSkill):
		1:
			skill = character.skillOne
		2:
			skill = character.skillTwo
	if !waitingForTarget:
		if skill.skillFlags.has("ally"):
			waitingForTarget = true
			await crewmateClick
			newLine_textBox("You use the skill %s" % skill.skillName,1)
			useSkill(character, skill, allyTarget)
		else:
			waitingForTarget = true
			await targetSelected
			newLine_textBox("You use the skill %s" % skill.skillName,1)
			useSkill(character, skill, enemyTarget)
			if Game.enemyCrew[enemyTarget].healthCurrent <= 0:
				EnemyCrewContainer.get_child(enemyTarget).hide()
				nbEnnemiesKilled = nbEnnemiesKilled + 1
				erase_enemy()
		_on_enemy_click(-1)
		_on_crew_nameplate_click(-1)
		nextCharacter()
		waitingForTarget = false


func useSkill(charater: Character, skill: Skill, target: int):
	var general = skill.activeAbility.general
	general = [general.name, general.flavorText, general.weaponType,
	 general.targetNumber, general.weakPointCheck, general.damageSplit]
	if skill.skillFlags.has("heal"):
		var heal = skill.activeAbility.heal
		heal = [heal.base,heal.hpModifier]
		var totalHeal = clamp(heal[0]+snapped(Game.crew[target].healthMax*heal[1],1),0,Game.crew[target].healthMax)
		Game.crew[target].healthCurrent = clamp(Game.crew[target].healthCurrent+totalHeal,0,Game.crew[target].healthMax)
		newLine_textBox("You healed "+str(totalHeal)+" HP to "+ Game.crew[target].identity,1)
	else:
		var damage = skill.activeAbility.damage
		damage = [damage.base, damage.attackModifier, damage.hpModifier]
		var status = skill.activeAbility.status
		var stun = [status.stun.valid, status.stun.stunDuration]
		var weakpoint = [status.weakPoint.valid, status.weakPoint.weakpointDuration]
		var burn = [status.burn.valid, status.burn.burnDuration, status.burn.burnDamage]
		
		if weakpoint[0]:
			newLine_textBox("You discover weakpoint of " + str(Game.enemyCrew[target].identity),1)
			Game.enemyCrew[target].weakpoint = weakpoint
		if stun[0]:
			newLine_textBox("You stun " + str(Game.enemyCrew[target].identity),1)
			Game.enemyCrew[target].stun = stun
		if burn[0]:
			newLine_textBox("You burn " + str(Game.enemyCrew[target].identity),1)
			Game.enemyCrew[target].burn = burn
		
		Game.enemyCrew[target].healthCurrent = max(
			0, Game.enemyCrew[target].healthCurrent - (damage[0] + damage[1]))
		damageInflicted = damageInflicted + damage[0] + damage[1]
		newLine_textBox("You dealt %d damage !" % damage[0],1)

func _on_start_pressed():
	start.emit()

func _on_victor():
	batlle.hide()
	victory.show()
	choiceCreditsNumber.text = str((25 * nbEnnemiesKilled + snapped(50/(1+nbRound),1)))
	dmgDealtTwo.text =  "Degats infliges aux ennemis : "+ str(damageInflicted)
	dmgSuffTwo.text = "Degats subies par l'equipage : "+ str(damageSuffered)
	enKilledTwo.text = "Ennemis tues : "+ str(nbEnnemiesKilled)
	roundsTwo.text = "Duree du combat (en manches) : "+ str(nbRound) 

func _on_gameover():
	batlle.hide()
	gameOver.show()
	dmgDealt.text =  "Degats infliges aux ennemis : "+ str(damageInflicted)
	dmgSuff.text = "Degats subies par l'equipage : "+ str(damageSuffered)
	enKilled.text = "Ennemis tues : "+ str(nbEnnemiesKilled)
	rounds.text = "Duree du combat (en manches) : "+ str(nbRound)

func erase_enemy():
	for en in Game.enemyCrew:
		if en.healthCurrent <= 0:
			for c in order.size():
				if order[c][0] is Enemy && order[c][0] == en:
					Game.enemyCrew.erase(en)
	refreshEnemyNameplates()

func refreshEnemyNameplates():
	for ennemy in EnemyCrewContainer.get_children():
		ennemy.hide()
		ennemy.queue_free()
	
	for c in Game.enemyCrew.size():
		var new = enemyBattleNameplate.instantiate().init(c)
		new.click_on_nameplate.connect(_on_enemy_click)
		EnemyCrewContainer.add_child(new)

func _on_choice_credits_gui_input(event):
	if event is InputEventMouseButton  && event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
		if !rewardObtained:
			var loot = (25 * nbEnnemiesKilled + snapped(50/(1+nbRound),1))
			var fightResult: Dictionary = {
				"credits":loot,
				"total_damage_dealt":damageInflicted,
				"enemies_killed":nbEnnemiesKilled,
				"rounds":nbRound,
				"total_damage_suffered":damageSuffered,
				"fight_result":true,
				"boss_fight":bossFight
				}
			Game.credits += loot
			rewardObtained = true
			choiceBox.hide()
			
			chosenText.text = "Credits"
			chosenIcon.texture = ResourceLoader.load("res://Assets/Items/itemCoin.png")
			chosenPanel.show()
			chosenNumber.text = str(loot)
			
			chosenBox.show()
			reward.emit(fightResult)

func _on_choice_item_gui_input(event):
	if event is InputEventMouseButton  && event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
		if !rewardObtained:
			var index = JsonHandling.item_data[JsonHandling.item_data.keys()[randi()%JsonHandling.item_data.size()]]["itemId"]
			var loot = Item.new(index,'','','',{},0,true)
			var fightResult: Dictionary = {
				"item_drops":1,
				"total_damage_dealt":damageInflicted,
				"enemies_killed":nbEnnemiesKilled,
				"rounds":nbRound,
				"total_damage_suffered":damageSuffered,
				"fight_result":true,
				"boss_fight":bossFight
				}
			rewardObtained = true
			Game.inventory.append(loot)
			choiceBox.hide()
			
			chosenText.text = loot.itemName
			chosenIcon.texture = ResourceLoader.load("res://Assets/Items/"+loot.itemIconLink)
			chosenPanel.hide()
			
			chosenBox.show()
			reward.emit(fightResult)


func _on_next_destination_pressed():
	openDestination.emit()

func newLine_textBox(value:String,messageType:int = 0):
	textboxNode.show()
	var label = Label.new()
	label.label_settings = LabelSettings.new()
	label.label_settings.font_size = 24
	label.label_settings.outline_size = 1
	match(messageType):
		0:
			label.label_settings.font_color = Color("yellow")
			label.label_settings.outline_color = Color("yellow")
		1:
			label.label_settings.font_color = Color(255,255,255)
			label.label_settings.outline_color = Color(255,255,255)
		2:
			label.label_settings.font_color = Color(255,0,0)
			label.label_settings.outline_color = Color(255,0,0)
	label.text = value
	textboxLabelNode.add_child(label)


func _on_skill_1_pressed():
	_on_skill_used(1)


func _on_skill_2_pressed():
	_on_skill_used(2)


func _on_attack_mouse_entered():
	%ActionDescScroll.show()
	if character is Crewmate:
		actionName.text = "Attaque de base"
		actionDesc.text = "L'attaque principale du membre d'equipage."

func _on_defend_mouse_entered():
	%ActionDescScroll.show()
	if character is Crewmate:
		actionName.text = "Posture defensive"
		actionDesc.text = "Le membre d'equipage se met en posture defensive et reduit les degats de la prochaine de 50%."

func _on_skill_1_mouse_entered():
	%ActionDescScroll.show()
	if character is Crewmate:
		actionName.text = character.skillOne.activeAbility.general.name
		actionDesc.text = character.skillOne.activeAbility.general.flavorText

func _on_skill_2_mouse_entered():
	%ActionDescScroll.show()
	if character is Crewmate:
		actionName.text = character.skillTwo.activeAbility.general.name
		actionDesc.text = character.skillTwo.activeAbility.general.flavorText


func _on_view_endscreen_pressed():
	var fightResult: Dictionary = {
		"total_damage_dealt":damageInflicted,
		"enemies_killed":nbEnnemiesKilled,
		"rounds":nbRound,
		"total_damage_suffered":damageSuffered,
		"fight_result":false,
		"boss_fight":bossFight
	}
	lost.emit(fightResult)

func setFightEndScreen(value:Dictionary):
	for i in self.get_children():
		i.hide()
	dmgDealtTwo.text =  "Degats infliges aux ennemis : "+ str(value["total_damage_dealt"])
	dmgSuffTwo.text = "Degats subies par l'equipage : "+ str(value["total_damage_suffered"])
	enKilledTwo.text = "Ennemis tues : "+ str(value["enemies_killed"])
	roundsTwo.text = "Duree du combat (en manches) : "+ str(value["rounds"])
	choiceBox.hide()
	rewardObtained = true
	victory.show()

func _on_crew_nameplate_click(idx:int):
	allyTarget = clamp(idx,-1,Game.crew.size()-1)
	if allyTarget != -1:
		crewmateClick.emit()
	
