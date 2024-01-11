extends PanelContainer

signal click()

var destinationData

@onready var backgroundNode = %destinationBackground
@onready var difficultyNode = %destinationDifficulty
@onready var nameNode = %destinationName
@onready var flavorNode = %destinationFlavor
@onready var scrollNode = %ScrollContainer

var secondTimer = 0.25
var timer = 0.05
var previousScroll = 0

# Called when the node enters the scene tree for the first time.
func _ready():
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
	if self.visible:
		if timer > 0:
			timer -= delta
		else:
			scrollNode.scroll_horizontal += 1
			if (previousScroll == scrollNode.scroll_horizontal):
				secondTimer -= delta
				if secondTimer <= 0:
					secondTimer = 0.25
					scrollNode.scroll_horizontal = 0
			else:
				previousScroll = scrollNode.scroll_horizontal
			timer = 0.05


func _on_gui_input(event):
	if (event is InputEventMouseButton) && (event.button_index == MOUSE_BUTTON_LEFT) && (event.pressed):
		click.emit(destinationData)
