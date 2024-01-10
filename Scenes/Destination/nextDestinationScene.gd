extends PanelContainer

signal click()

var destinationData

@onready var backgroundNode = %destinationBackground
@onready var difficultyNode = %destinationDifficulty
@onready var nameNode = %destinationName
@onready var flavorNode = %destinationFlavor

# Called when the node enters the scene tree for the first time.
func _ready():
	print(destinationData)
	backgroundNode.texture = load("res://Assets/Background/Radar/"+destinationData["background"])
	difficultyNode.value = destinationData["difficulty"]
	nameNode.text = destinationData["name"]
	flavorNode.text = destinationData["flavor"]

func init(value):
	if (value is Dictionary):
		destinationData = value
	return self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_gui_input(event):
	if (event is InputEventMouseButton) && (event.button_index == MOUSE_BUTTON_LEFT) && (event.pressed):
		click.emit(destinationData)
