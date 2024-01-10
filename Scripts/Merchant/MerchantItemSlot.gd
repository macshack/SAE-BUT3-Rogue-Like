extends MarginContainer
class_name MerchantItemSlot

signal merchant_error(message:String)
signal merchant_success(message:String)
signal merchant_sold(item:Item)

#Vaut True si il est dispo a la vente, passe en False quand l'item est achete
var available = true
var item:Item
var currentPrice

#Vaut True si il s'agit d'un objet vendu par un marchand, False si il est vendu par le joueur
var canBuy = true

#Vaut True si il s'agit d'un objet vendu pouvant etre rachete, False si il est vendu par le joueur
var reverseBuy = false

#Pour l'auto scroll
var previousScroll
var timer = 0.05
var secondTimer = 0.25

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/ScrollContainer.scroll_horizontal = 0
	if !canBuy:
		currentPrice = snapped(item.itemPrice*0.7,0)
	else:
		currentPrice = item.itemPrice
	$VBoxContainer/Label.text = str(currentPrice)+"C"
	$VBoxContainer/TextureRect.texture = load("res://Assets/Portraits/"+item.itemIconLink)
	$VBoxContainer/ScrollContainer/Label2.text = item.itemName

func _process(delta):
	if timer > 0:
		timer -= delta
	else:
		$VBoxContainer/ScrollContainer.scroll_horizontal += 1
		if (previousScroll == $VBoxContainer/ScrollContainer.scroll_horizontal):
			secondTimer -= delta
			if secondTimer <= 0:
				secondTimer = 0.25
				$VBoxContainer/ScrollContainer.scroll_horizontal = 0
		else:
			previousScroll = $VBoxContainer/ScrollContainer.scroll_horizontal
		timer = 0.05

func init(itemParam):
	item = Item.new(itemParam.itemId,itemParam.itemName,itemParam.itemFlavorText,itemParam.itemIconLink,itemParam.itemModifiers,itemParam.itemPrice)
	return self

func _on_gui_input(event):
	if canBuy:
		if event is InputEventMouseButton  && event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			if available:
				if ((Game.credits - currentPrice) >= 0):
					available = false
					$VBoxContainer/Label.text = "Indisponible."
					$VBoxContainer.modulate = Color(1.0,1.0,1.0,0.25)
					Game.credits -= currentPrice
					Game.inventory.append(item)
					merchant_success.emit(item.itemName+" a ete ajoute a l'inventaire.")
				else:
					merchant_error.emit("Pas assez de credits.")
	elif reverseBuy:
		if event is InputEventMouseButton  && event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			if ((Game.credits - currentPrice) >= 0):
				Game.credits -= currentPrice
				Game.inventory.append(item)
				merchant_sold.emit(item)
				merchant_success.emit(item.itemName+" a ete ajoute a l'inventaire.")
			else:
				merchant_error.emit("Pas assez de credits.")
	else:
		if event is InputEventMouseButton  && event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			if available:
				Game.credits += currentPrice
				for i in Game.inventory:
					if i.itemName == item.itemName:
						Game.inventory.erase(i)
						merchant_sold.emit(i)
				merchant_success.emit(item.itemName+" a ete vendu avec succes.")
				self.queue_free()
			else:
				merchant_error.emit("Impossible a vendre.")
