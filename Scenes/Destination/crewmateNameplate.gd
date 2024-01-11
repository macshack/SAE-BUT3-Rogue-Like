extends PanelContainer

@export var test:bool = false
var crewIndex:int = -1
var crewmate

@onready var nameNode = %crewmateName
@onready var iconNode = %crewmateIcon
@onready var hpNode = %crewmateHP

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
					iconNode.texture = load("res://Assets/Portraits/"+crewmate.icon)
					self.show()
	else:
		if (crewIndex is int) && (crewIndex > -1) && (Game.crew.size()>crewIndex):
			if (Game.crew[crewIndex] is Crewmate):
				if (hpNode.value != Game.crew[crewIndex].healthCurrent) || (hpNode.max_value != Game.crew[crewIndex].healthMax) || (nameNode.text != Game.crew[crewIndex].identity):
					hpNode.value = Game.crew[crewIndex].healthCurrent
					hpNode.max_value = Game.crew[crewIndex].healthMax
					nameNode.text = Game.crew[crewIndex].identity
					iconNode.texture = load("res://Assets/Portraits/"+Game.crew[crewIndex].icon)
					self.show()
						
			else:
				self.hide()
		else:
			self.hide()
