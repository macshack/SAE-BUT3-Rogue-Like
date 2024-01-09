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
		if property is Item && property:
			texture = load("res://Assets/Portraits/"+property.itemIconLink)
		else:
			texture = null
