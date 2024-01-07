extends PanelContainer

var crewIndex:int
@onready var nameNode = %CrewmateName
@onready var iconNode = %CrewmateIcon
@onready var itemOneNode = %Item1
@onready var itemTwoNode = %Item2
@onready var itemThreeNode = %Item3

# Called when the node enters the scene tree for the first time.
func _ready():
	if Game.crew[crewIndex] is Crewmate:
		nameNode.text = Game.crew[crewIndex].identity
		iconNode.texture = load("res://Assets/Portraits/"+Game.crew[crewIndex].icon)
	#itemOneNode
	#itemTwoNode
	#itemThreeNode
	

func init(value:int):
	crewIndex = value
	return self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Game.crew[crewIndex] is Crewmate:
		nameNode.text = Game.crew[crewIndex].identity
		iconNode.texture = load("res://Assets/Portraits/"+Game.crew[crewIndex].icon)
