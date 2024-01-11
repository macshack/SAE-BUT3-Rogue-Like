extends TextureRect

@onready var currentOwner:String:
	set(value):
		currentOwner = value

@onready var isInventory:bool = true:
	set(value):
		isInventory = value

@onready var property:Item:
	set(value):
		property = value
		if property is Item:
			self.texture = load("res://Assets/Portraits/"+property.itemIconLink)
		else:
			self.texture = null

