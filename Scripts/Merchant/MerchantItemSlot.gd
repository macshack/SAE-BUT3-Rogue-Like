extends Node2D
class_name MerchantItemSlot

signal merchant_error(message:String)
signal merchant_success(message:String)

var available = true
var item:Item

#Pour l'auto scroll
var previousScroll
var timer = 0.05

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/Label.text = str(item.itemPrice)
	$VBoxContainer/TextureRect.texture = load("res://Assets/Portraits/"+item.itemIconLink)
	$VBoxContainer/ScrollContainer/Label2.text = item.itemName

func _process(delta):
	if timer > 0:
		timer -= delta
	else:
		$VBoxContainer/ScrollContainer.scroll_horizontal += 1
		if (previousScroll == $VBoxContainer/ScrollContainer.scroll_horizontal):
			$VBoxContainer/ScrollContainer.scroll_horizontal = 0
		else:
			previousScroll = $VBoxContainer/ScrollContainer.scroll_horizontal
		timer = 0.05

func init(itemParam):
	item = Item.new(itemParam.itemName,itemParam.itemFlavorText,itemParam.itemIconLink,itemParam.itemModifiers,itemParam.itemPrice)
	return self

func _on_input_slot(event):
	if event is InputEventMouseButton  && event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
		if available:
			if ((Game.credits - item.itemPrice) >= 0):
				available = false
				$VBoxContainer/Label.text = "Indisponible."
				$VBoxContainer.modulate = Color(1.0,1.0,1.0,0.25)
				Game.credits -= item.itemPrice
				Game.inventory.append(item)
				merchant_success.emit(item.itemName+" a ete ajoute a l'inventaire.")
			else:
				merchant_error.emit("Pas assez de credits.")
	
