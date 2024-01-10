extends PanelContainer

@onready var textNode = %title
@onready var currentNode = %current
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func updateObjective(data:ObjectiveSettings):
	textNode.text = data.text
	currentNode.value = data.current
	currentNode.max_value = data.goal


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
