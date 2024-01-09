extends Panel

var merchantScene = preload("res://Scenes/Merchant/Merchant.tscn")

var destination

var situation

@onready var crewmates = %Crewmates
@onready var inventory = %Inventory
@onready var settings = %Settings
@onready var main = %Main
@onready var crew = %Equipage
var situationNode
#var situation
# Called when the node enters the scene tree for the first time.
func _ready():
	if situation:
		match(situation["type"]):
			"EXPL":
				pass
			"FGHT":
				pass
			"MRCD":
				var merchant = merchantScene.instantiate()
				situationNode = str(merchant)
				main.add_child(merchant)
	else:
		var merchant = merchantScene.instantiate()
		situationNode = str(merchant)
		main.add_child(merchant)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_settings_pressed():
	for i in main.get_children():
		i.hide()
	settings.show()

func init(test:bool,destinationData=null,situationData=null):
	if destinationData:
		pass
	if situationData:
		if situationData.type:
			situation = situationData
	return self

func _on_inventory_pressed():
	for i in main.get_children():
		i.hide()
	inventory.refreshInventory()
	inventory.show()


func _on_situation_pressed():
	for i in main.get_children():
		i.hide()
	for c in main.get_children():
		if str(c) == situationNode:
			c.show()


func _on_equipage_pressed():
	for i in main.get_children():
		i.hide()
	crew.show()
