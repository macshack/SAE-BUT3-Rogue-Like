extends PanelContainer

@onready var nameNode = %objectiveName
@onready var descNode = %objectiveDescription
@onready var textNode = %objectiveText
@onready var currentNode = %objectiveCurrent


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func updateObjective(data:ObjectiveSettings):
	nameNode.text = data.title
	descNode.text = data.desc
	textNode.text = data.text
	currentNode.value = data.current
	currentNode.max_value = data.goal

func init():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
