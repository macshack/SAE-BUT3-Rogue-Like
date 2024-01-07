extends PanelContainer

var item:Item

@onready var itemIconNode = %ItemIcon
# Called when the node enters the scene tree for the first time.
func _ready():
	if item:
		itemIconNode.texture = load("res://Assets/Portraits/"+item.itemIconLink)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func init(value:Item):
	item = value
