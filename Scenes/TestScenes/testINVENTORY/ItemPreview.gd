extends PanelContainer

var item:Item

@onready var itemName = %ItemName
@onready var itemFlavor = %ItemFlavor
@onready var itemIcon = %ItemIcon
@onready var itemPrice = %ItemPrice
@onready var itemStats = %ItemStats

func _set_item(value:Item):
	item = value
	itemName.text = item.itemName
	itemFlavor.text = item.itemFlavorText
	itemIcon.texture = ResourceLoader.load("res://Assets/Items/"+item.itemIconLink)
	itemPrice.text = str(item.itemPrice)
	self.show()
