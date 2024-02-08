extends PanelContainer

@export var test:bool = false
var crewIndex:int = -1
var crewmate

signal clickOnNameplate(idx:int)

@onready var nameNode = %crewmateName
@onready var iconNode = %crewmateIcon
@onready var hpNode = %crewmateHP

@export var currentPlayer = false

# Called when the node enters the scene tree for the first time.
func _ready():
	updatePanel()

func init(value):
	if (value is int) && (value > -1) && (Game.crew.size() > value):
		if (Game.crew[crewIndex] is Crewmate):
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
		if (crewmate is Crewmate):
			if (hpNode.value != crewmate.healthCurrent) || (hpNode.max_value != crewmate.healthMax) || (nameNode.text != crewmate.identity):
					hpNode.value = crewmate.healthCurrent
					hpNode.max_value = crewmate.healthMax
					nameNode.text = crewmate.identity
					iconNode.texture = ResourceLoader.load("res://Assets/Portraits/"+crewmate.icon)
					self.show()
	else:
		if (crewIndex is int) && (crewIndex > -1) && (Game.crew.size()>crewIndex):
			if (Game.crew[crewIndex] is Crewmate):
				if (hpNode.value != Game.crew[crewIndex].healthCurrent) || (hpNode.max_value != Game.crew[crewIndex].healthMax) || (nameNode.text != Game.crew[crewIndex].identity):
					hpNode.value = Game.crew[crewIndex].healthCurrent
					hpNode.max_value = Game.crew[crewIndex].healthMax
					nameNode.text = Game.crew[crewIndex].identity
					iconNode.texture = ResourceLoader.load("res://Assets/Portraits/"+Game.crew[crewIndex].icon)
					self.show()
						
			else:
				self.hide()
		else:
			self.hide()


func _on_mouse_entered():
	pass # Replace with function body.


func _on_mouse_exited():
	pass # Replace with function body.


func _on_gui_input(event):
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
		if !test && crewIndex >= 0:
			clickOnNameplate.emit(crewIndex)
			
