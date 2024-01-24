extends Control

var crewmatePanel = preload("res://Scenes/CrewScreen/crewmatescreenpanel.tscn")

@export var test = false

@onready var boxNode = %crewmateBox
@onready var skillOneNameNode = %skillOneName
@onready var skillOneDescNode = %skillOneDescription
@onready var skillTwoNameNode = %skillTwoName
@onready var skillTwoDescNode = %skillTwoDescription

@onready var extendedBackground = %extendCrewmate

@onready var crewmateIcon = %crewmateIcon
@onready var crewmateName = %crewmateName
@onready var crewmateDescription = %crewmateBackground

@onready var hpBar = %hpBar
@onready var hpBarLabel = %hpBarLabel

@onready var atkLabel = %atkLabel
@onready var atkModifiers = %atkModifiers

@onready var hpLabel = %hpLabel
@onready var hpModifiers = %hpModifiers

@onready var spdLabel = %spdLabel
@onready var spdModifiers = %spdModifiers

@onready var crtLabel = %crtLabel
@onready var crtModifiers = %crtModifiers

@onready var ddgLabel = %ddgLabel
@onready var ddgModifiers = %ddgModifiers

@onready var testCrew :Array[Crewmate] = [Crewmate.new("Brulux","Human (53).jpg","Pas grand chose",[105,106]),Crewmate.new("Boukayo Caca","Human (50).jpg","Pas grand chose",[100,104]),Crewmate.new("Boufux","Human (59).jpg","Pas grand chose",[105,100]),Crewmate.new("Connard","Human (20).jpg","Pas grand chose",[103,104])]
# Called when the node enters the scene tree for the first time.
func _ready():
	updateCrewmateBox()

func updateCrewmateBox():
	for children in boxNode.get_children():
		boxNode.remove_child(children)
	if test:
		for cr in testCrew:
			if cr is Crewmate:
				var panel = crewmatePanel.instantiate().init(cr)
				panel.removeCrewmate.connect(_remove_crewmate)
				panel.extendCrewmate.connect(_extend_crewmate)
				boxNode.add_child(panel)
	else:
		for cr in Game.crew.size():
			if (cr is int) && (Game.crew[cr] is Crewmate):
				var panel = crewmatePanel.instantiate().init(int(cr))
				panel.removeCrewmate.connect(_remove_crewmate)
				panel.extendCrewmate.connect(_extend_crewmate)
				boxNode.add_child(panel)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if test:
		if testCrew.size() != boxNode.get_children().size():
			updateCrewmateBox()
	else:
		if Game.crew.size() != boxNode.get_children().size():
			updateCrewmateBox()


func _remove_crewmate(value):
	if test:
		if (testCrew.size()-1>0):
			if value is Crewmate:
				if testCrew.find(value) > -1:
					testCrew.pop_at(testCrew.find(value))
					updateCrewmateBox()
	else:
		if (Game.crew.size()-1>0):
			if (value is int) && (Game.crew[value] is Crewmate):
					Game.crew.pop_at(value)
					updateCrewmateBox()

func _extend_crewmate(value):
	if test:
		if value is Crewmate:
			crewmateName.text = value.identity
			crewmateIcon.texture = ResourceLoader.load("res://Assets/Portraits/"+value.icon)
			crewmateDescription.text = value.background
			skillOneNameNode.text = value.skillOne.skillName
			skillOneDescNode.text = value.skillOne.skillDescription
			skillTwoNameNode.text = value.skillTwo.skillName
			skillTwoDescNode.text = value.skillTwo.skillDescription
	else:
		if (value is int) && (Game.crew[value] is Crewmate):
			for child in hpModifiers.get_children():
				child.hide()
				child.queue_free()
			for child in atkModifiers.get_children():
				child.hide()
				child.queue_free()
			for child in spdModifiers.get_children():
				child.hide()
				child.queue_free()
			for child in crtModifiers.get_children():
				child.hide()
				child.queue_free()
			for child in ddgModifiers.get_children():
				child.hide()
				child.queue_free()
			Game.crew[value].applyModifiersToCrewmate()
			extendedBackground.show()
			crewmateName.text = Game.crew[value].identity
			crewmateIcon.texture = ResourceLoader.load("res://Assets/Portraits/"+Game.crew[value].icon)
			crewmateDescription.text = Game.crew[value].background
			skillOneNameNode.text = Game.crew[value].skillOne.skillName
			skillOneDescNode.text = Game.crew[value].skillOne.skillDescription
			skillTwoNameNode.text = Game.crew[value].skillTwo.skillName
			skillTwoDescNode.text = Game.crew[value].skillTwo.skillDescription
			
			hpBar.value = Game.crew[value].healthCurrent
			hpBar.max_value = Game.crew[value].healthMax
			hpBarLabel.text = str(Game.crew[value].healthCurrent)+"/"+str(Game.crew[value].healthMax)
			 
			atkLabel.text = str(Game.crew[value].attackCurrent)+" (+"+str((Game.crew[value].attackCurrent-Game.crew[value].attackBase))+") Attaque"
			for item in Game.crew[value].gear.itemList:
				if Game.crew[value].gear.itemList[item] is Item:
					if Game.crew[value].gear.itemList[item].itemModifiers["ATK"] != 0:
						var statValue = Game.crew[value].gear.itemList[item]
						var label = Label.new()
						var labSettings = LabelSettings.new()
						if statValue.itemModifiers["ATK"] > 0:
							labSettings.font_color = Color(0,255,0)
							label.text = "+"+str(statValue.itemModifiers["ATK"])+" "+statValue.itemName
						elif statValue.itemModifiers["ATK"] < 0:
							labSettings.font_color = Color(255,0,0)
							label.text = str(statValue.itemModifiers["ATK"])+" "+statValue.itemName
						labSettings.font_size = 24
						label.label_settings = labSettings
						atkModifiers.add_child(label)
			
			hpLabel.text = str(Game.crew[value].healthMax)+" (+"+str((Game.crew[value].healthMax-Game.crew[value].healthBase))+") Point de vie maximum"
			for item in Game.crew[value].gear.itemList:
				if Game.crew[value].gear.itemList[item] is Item:
					if Game.crew[value].gear.itemList[item].itemModifiers["HP"] != 0:
						var statValue = Game.crew[value].gear.itemList[item]
						var label = Label.new()
						var labSettings = LabelSettings.new()
						if statValue.itemModifiers["HP"] > 0:
							labSettings.font_color = Color(0,255,0)
							label.text = "+"+str(statValue.itemModifiers["HP"])+" "+statValue.itemName
						elif statValue.itemModifiers["HP"] < 0:
							labSettings.font_color = Color(255,0,0)
							label.text = str(statValue.itemModifiers["HP"])+" "+statValue.itemName
						labSettings.font_size = 24
						label.label_settings = labSettings
						hpModifiers.add_child(label)
			
			
			spdLabel.text = str(Game.crew[value].speedCurrent)+" (+"+str((Game.crew[value].speedCurrent-Game.crew[value].speedBase))+") Vitesse"
			for item in Game.crew[value].gear.itemList:
				if Game.crew[value].gear.itemList[item] is Item:
					if Game.crew[value].gear.itemList[item].itemModifiers["SPD"] != 0:
						var statValue = Game.crew[value].gear.itemList[item]
						var label = Label.new()
						var labSettings = LabelSettings.new()
						if statValue.itemModifiers["SPD"] > 0:
							labSettings.font_color = Color(0,255,0)
							label.text = "+"+str(statValue.itemModifiers["SPD"])+" "+statValue.itemName
						elif statValue.itemModifiers["SPD"] < 0:
							labSettings.font_color = Color(255,0,0)
							label.text = str(statValue.itemModifiers["SPD"])+" "+statValue.itemName
						labSettings.font_size = 24
						label.label_settings = labSettings
						spdModifiers.add_child(label)
			
			
			crtLabel.text = str(Game.crew[value].critCurrent)+"% (+"+str((Game.crew[value].critCurrent-Game.crew[value].critBase))+"%) Chances de coup critique"
			for item in Game.crew[value].gear.itemList:
				if Game.crew[value].gear.itemList[item] is Item:
					if Game.crew[value].gear.itemList[item].itemModifiers["CRT"] != 0:
						var statValue = Game.crew[value].gear.itemList[item]
						var label = Label.new()
						var labSettings = LabelSettings.new()
						if statValue.itemModifiers["CRT"] > 0:
							labSettings.font_color = Color(0,255,0)
							label.text = "+"+str(statValue.itemModifiers["CRT"])+"% "+statValue.itemName
						elif statValue.itemModifiers["CRT"] < 0:
							labSettings.font_color = Color(255,0,0)
							label.text = str(statValue.itemModifiers["CRT"])+"% "+statValue.itemName
						labSettings.font_size = 24
						label.label_settings = labSettings
						crtModifiers.add_child(label)
			
			
			ddgLabel.text = str(Game.crew[value].dodgeCurrent)+"% (+"+str((Game.crew[value].dodgeCurrent-Game.crew[value].dodgeBase))+"%) Chance d'esquiver"
			for item in Game.crew[value].gear.itemList:
				if Game.crew[value].gear.itemList[item] is Item:
					if Game.crew[value].gear.itemList[item].itemModifiers["DDG"] != 0:
						var statValue = Game.crew[value].gear.itemList[item]
						var label = Label.new()
						var labSettings = LabelSettings.new()
						if statValue.itemModifiers["DDG"] > 0:
							labSettings.font_color = Color(0,255,0)
							label.text = "+"+str(statValue.itemModifiers["DDG"])+"% "+statValue.itemName
						elif statValue.itemModifiers["DDG"] < 0:
							labSettings.font_color = Color(255,0,0)
							label.text = str(statValue.itemModifiers["DDG"])+"% "+statValue.itemName
						labSettings.font_size = 24
						label.label_settings = labSettings
						ddgModifiers.add_child(label)
