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
			crewmateIcon.texture = load("res://Assets/Portraits/"+value.icon)
			crewmateDescription.text = value.background
			skillOneNameNode.text = value.skillOne.skillName
			skillOneDescNode.text = value.skillOne.skillDescription
			skillTwoNameNode.text = value.skillTwo.skillName
			skillTwoDescNode.text = value.skillTwo.skillDescription
	else:
		if (value is int) && (Game.crew[value] is Crewmate):
			extendedBackground.show()
			crewmateName.text = Game.crew[value].identity
			crewmateIcon.texture = load("res://Assets/Portraits/"+Game.crew[value].icon)
			crewmateDescription.text = Game.crew[value].background
			skillOneNameNode.text = Game.crew[value].skillOne.skillName
			skillOneDescNode.text = Game.crew[value].skillOne.skillDescription
			skillTwoNameNode.text = Game.crew[value].skillTwo.skillName
			skillTwoDescNode.text = Game.crew[value].skillTwo.skillDescription
