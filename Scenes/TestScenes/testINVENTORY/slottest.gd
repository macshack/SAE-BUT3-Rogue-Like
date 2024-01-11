extends PanelContainer

signal preview(item:Item)
signal new_item(newItem,oldItem)

@onready var textureNode = %TextureRect
var droppable = true
var parent:String = ''

func _get_drag_data(at_position):
	set_drag_preview(get_preview())
	return textureNode

func _can_drop_data(at_position, data):
	return data is TextureRect && droppable && data.isInventory != textureNode.isInventory

func _drop_data(at_position, data):
	var temp = textureNode.property
	textureNode.property = data.property
	data.property = temp
	print("Drop item dans un slot")
	print("Ancien parent : "+data.currentOwner)
	if data.currentOwner != "":
		new_item.emit(textureNode.property,data.property,data.currentOwner)
	else:
		new_item.emit(textureNode.property,data.property,"inventory")

func get_preview():
	var previewTexture = TextureRect.new()
	previewTexture.expand_mode = 1
	previewTexture.size = Vector2(100,100)
	previewTexture.texture = textureNode.texture
	var preview = Control.new()
	preview.add_child(previewTexture)
	return preview

func set_property(value:Item):
	textureNode.property = value
	
func set_family(value:bool):
	textureNode.isInventory = value
	
func set_currentOwner(value:String):
	textureNode.currentOwner = value
	
func get_currentOwner():
	return textureNode.currentOwner

func get_property() -> Item:
	return textureNode.property

func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			if textureNode.property is Item && textureNode.property:
				preview.emit(textureNode.property)
func cleanProperty():
	textureNode.property = null
