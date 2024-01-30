extends PanelContainer
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

@onready var scrollNode = %ScrollContainer
@onready var nameNode = %itemName
@onready var vboxNode = %VBoxContainer
@onready var iconNode = %itemIcon
@onready var priceNode = %itemPrice
@onready var statNode = %statsContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	scrollNode.scroll_horizontal = 0
	if !canBuy:
		currentPrice = snapped(item.itemPrice*0.7,0)
	else:
		currentPrice = item.itemPrice
	priceNode.text = "Acheter - "+str(currentPrice)+"C"
	iconNode.texture = ResourceLoader.load("res://Assets/Items/"+item.itemIconLink)
	nameNode.text = item.itemName
	for stat in item.itemModifiers:
		if item.itemModifiers[stat] != 0:
			var st = Label.new()
			if item.itemModifiers[stat] > 0:
				st.text = "+"+str(item.itemModifiers[stat])+" "+str(stat)
			elif item.itemModifiers[stat] > 0:
				st.text = "-"+str(item.itemModifiers[stat])+" "+str(stat)
			statNode.add_child(st)

func _process(delta):
	if timer > 0:
		timer -= delta
	else:
		scrollNode.scroll_horizontal += 1
		if (previousScroll == scrollNode.scroll_horizontal):
			secondTimer -= delta
			if secondTimer <= 0:
				secondTimer = 0.25
				scrollNode.scroll_horizontal = 0
		else:
			previousScroll = scrollNode.scroll_horizontal
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
					priceNode.text = "Indisponible."
					vboxNode.modulate = Color(1.0,1.0,1.0,0.25)
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
						break
				merchant_success.emit(item.itemName+" a ete vendu avec succes.")
				self.queue_free()
			else:
				merchant_error.emit("Impossible a vendre.")
