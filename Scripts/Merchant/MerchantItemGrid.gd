extends GridContainer

var rootNode
var refreshButton
var merchantSignal

var refreshCost = 100
var itemSlot = preload("res://Scenes/Merchant/MerchantItemSlot.tscn")

signal merchant_error(message:String)
signal merchant_success(message:String)

func _ready():
	$"../../HBoxContainer3/HBoxContainer/Refresh".text = "Rafraichir - "+str(refreshCost)+"C"
	makeMerchantItems()
	rootNode = $"../../../.."
	refreshButton =$"../../HBoxContainer3/HBoxContainer/Refresh"
	merchantSignal = $"../../../merchantSignal"
	
func _process(delta):
	pass

func makeMerchantItems():
	var children = get_children()
	for i in children:
		for c in i.get_children():
			c.queue_free()
		var item = JsonHandling.item_data[JsonHandling.item_data.keys()[ randi() % JsonHandling.item_data.size()]]
		var slot = itemSlot.instantiate().init(item)
		slot.merchant_success.connect(_merchant_success)
		slot.merchant_error.connect(_merchant_error)
		i.add_child(slot)

func _on_refresh_pressed():
	if Game.credits >= refreshCost:
		Game.credits -= refreshCost
		refreshCost = refreshCost*4
		refreshButton.text = "Rafraichir - "+str(refreshCost)+"C"
		makeMerchantItems()
		merchant_success.emit("Changement des objets effectue avec succes.")
	else:
		merchant_error.emit("Pas assez de credits.")

# Catching its own messages
func _on_merchant_success(message):
	rootNode.merchantMessageFadeawayTimer = 3.0
	merchantSignal.label_settings.font_color = Color(0,1,0)
	merchantSignal.text = message

func _on_merchant_error(message):
	rootNode.merchantMessageFadeawayTimer = 3.0
	merchantSignal.label_settings.font_color = Color(1,0,0)
	merchantSignal.text = message

# Catching children messages
func _merchant_success(message):
	rootNode.merchantMessageFadeawayTimer = 3.0
	merchantSignal.label_settings.font_color = Color(0,1,0)
	merchantSignal.text = message
	
func _merchant_error(message):
	rootNode.merchantMessageFadeawayTimer = 3.0
	merchantSignal.label_settings.font_color = Color(1,0,0)
	merchantSignal.text = message
