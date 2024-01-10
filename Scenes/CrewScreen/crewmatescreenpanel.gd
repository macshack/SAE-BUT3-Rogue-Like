extends PanelContainer

signal extendCrewmate(id)
signal removeCrewmate(id)

@export var test = false

var crewIndex:int
var crewmate:Crewmate

@onready var nameNode = %crewmateName
@onready var iconNode = %crewmateIcon
@onready var skillOneNode = %skillOneName
@onready var skillTwoNode = %skillTwoName
@onready var backgroundNode = %crewmateBackground
# Called when the node enters the scene tree for the first time.
func _ready():
	updatePanel()

func init(value):
	if (value is int) && (value >= 0):
		crewIndex = value
		crewmate = null
	elif (value is Crewmate):
		crewmate = value
		crewIndex = -1
	return self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updatePanel()

func updatePanel():
	if test:
		if crewmate is Crewmate:
			self.show()
			nameNode.text = crewmate.identity
			iconNode.texture = load("res://Assets/Portraits/"+crewmate.icon)
			backgroundNode.text = crewmate.background
			skillOneNode.text = crewmate.skillOne.skillName
			skillTwoNode.text = crewmate.skillTwo.skillName
		else:
			self.hide()
	else:
		if (crewIndex is int) && (Game.crew[crewIndex] is Crewmate):
			self.show()
			nameNode.text = Game.crew[crewIndex].identity
			iconNode.texture = load("res://Assets/Portraits/"+Game.crew[crewIndex].icon)
			backgroundNode.text = Game.crew[crewIndex].background
			skillOneNode.text = Game.crew[crewIndex].skillOne.skillName
			skillTwoNode.text = Game.crew[crewIndex].skillTwo.skillName
		else:
			self.hide()

func _on_gui_input(event):
	if test:
		if crewmate is Crewmate:
			if (event is InputEventMouseButton) && (event.button_index == MOUSE_BUTTON_LEFT && event.pressed):
				extendCrewmate.emit(crewmate)
	else:
		if (crewIndex is int) && (Game.crew[crewIndex] is Crewmate):
			if (event is InputEventMouseButton) && (event.button_index == MOUSE_BUTTON_LEFT && event.pressed):
				extendCrewmate.emit(crewIndex)

func _on_fire_button_pressed():
	if test:
		if crewmate is Crewmate:
				removeCrewmate.emit(crewmate)
	else:
		if (crewIndex is int) && (Game.crew[crewIndex] is Crewmate):
			removeCrewmate.emit(crewIndex)
