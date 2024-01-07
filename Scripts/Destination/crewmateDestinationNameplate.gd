extends PanelContainer

signal clicked()


var crewIndex:int
@onready var iconNode = %crewmateIcon
@onready var hpNode = %crewmateHP

# Called when the node enters the scene tree for the first time.
func _ready():
	if Game.crew[crewIndex] is Crewmate:
		iconNode.texture = load("res://Assets/Portraits/"+Game.crew[crewIndex].icon)
		hpNode.max_value = Game.crew[crewIndex].healthMax
		hpNode.value = Game.crew[crewIndex].healthCurrent


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Game.crew[crewIndex] is Crewmate:
		iconNode.texture = load("res://Assets/Portraits/"+Game.crew[crewIndex].icon)
		hpNode.max_value = Game.crew[crewIndex].healthMax
		hpNode.value = Game.crew[crewIndex].healthCurrent
	
func init(value:int):
	crewIndex = value
	return self

func _on_gui_input(event):
	if event is InputEventMouseButton  && event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
		clicked.emit()
