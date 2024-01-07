extends Control

var itemSlot = load("res://Scenes/Destination/itemInventorySlot.tscn")
var crewmateSlot = load("res://Scenes/Destination/crewmateInventoryNameplate.tscn")
@onready var itemGridNode = %ItemGrid
@onready var crewmatesNode = %Crewmates
# Called when the node enters the scene tree for the first time.
func _ready():
	for c in Game.crew.size():
		var crewmate = crewmateSlot.instantiate().init(c)
		crewmatesNode.add_child(crewmate)
	for i in Game.inventory:
		var item = itemSlot.instantiate().init(i)
		itemGridNode.add_child(item)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
