extends PanelContainer

var item:Item = null

@onready var itemIconNode = %ItemIcon
# Called when the node enters the scene tree for the first time.
func _ready():
	if item:
		itemIconNode.texture = load("res://Assets/Portraits/"+item.itemIconLink)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func init(value:Item=null):
	if value:
		item = value
	return self

func _get_drag_data(at_position):
	set_drag_preview(get_preview())
	return itemIconNode
	
func _can_drop_data(at_position, data):
	return data is TextureRect

func _drop_data(at_position, data):
	var temp = itemIconNode.texture
	itemIconNode.texture = data.texture
	data = temp

func get_preview():
	var preview_texture = TextureRect.new()
 
	preview_texture.texture = itemIconNode.texture
	preview_texture.expand_mode = 1
	preview_texture.size = Vector2(100,100)
 
	var preview = Control.new()
	preview.add_child(preview_texture)
 
	return preview

func refreshTexture():
	if item is Item:
		itemIconNode.texture = load("res://Assets/Portraits/"+item.itemIconLink)
	else:
		itemIconNode.texture = null
