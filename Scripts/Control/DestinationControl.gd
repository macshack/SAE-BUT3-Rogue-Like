extends Control

var merchandScene = preload("res://Scenes/Merchant/Merchant.tscn")


@onready var crewmateNode = %Crewmate
@onready var screensNode = %Screens
@onready var optionsNode = %OptionsMenu
@onready var inventoryNode = %InventoryMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	var merchant = merchandScene.instantiate()
	inventoryNode.hide()
	merchant.set_name("situationMenu")
	screensNode.add_child(merchant)
	for c in Game.crew.size():
		var new = crewmateNameplate.instantiate().init(c)
		crewmateNode.add_child(new)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_situation_pressed():
	pass


func _on_objectif_pressed():
	pass # Replace with function body.


func _on_equipage_pressed():
	pass # Replace with function body.


func _on_inventaire_pressed():
	for c in screensNode.get_children():
		c.hide()
	inventoryNode.show()


func _on_options_pressed():
	for c in screensNode.get_children():
		c.hide()
	optionsNode.show()
	
