extends Control

var itemSlot = load("res://Scenes/Destination/itemInventorySlot.tscn")
var crewmateSlot = load("res://Scenes/Destination/crewmateInventoryNameplate.tscn")
@onready var itemGridNode = %ItemGrid
@onready var crewmatesNode = %Crewmates

var testingCrewmate = [Crewmate.new("Michel","","Human (10).jpg")]
var testingItems = [Item.new("Caca","Lance de caca","Human (1).jpg"),Item.new("Pipi","Lance de caca","Human (1).jpg"),Item.new("Vomi","Lance de caca","Human (1).jpg")]


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in testingItems:
		var item = itemSlot.instantiate().init(i)
		itemGridNode.add_child(item)
	while itemGridNode.get_children().size() < 30:
		var item = itemSlot.instantiate().init()
		itemGridNode.add_child(item)
	"""for c in Game.crew.size():
		var crewmate = crewmateSlot.instantiate().init(c)
		crewmatesNode.add_child(crewmate)
	"""
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
