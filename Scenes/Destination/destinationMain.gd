extends Panel

signal toMainMenu()
signal emitFightResult()

var merchantScene = preload("res://Scenes/Merchant/Merchant.tscn")

var destination
var situation

@onready var crewmates = %Crewmates
@onready var inventory = %Inventory
@onready var main = %Main
@onready var crew = %Equipage
@onready var menuNode = %Menu

@onready var settings = %Settings
@onready var optionsNode = %OptionsMenu
@onready var menuSaveNode = %Sauvegarder
@onready var menuSettingsNode = %Options
@onready var menuQuitNode = %Quitter
@onready var objectiveNode = %Objective
@onready var objectiveScreenNode = %ObjectiveScreen
@onready var widgetNode = %ObjectiveWidget

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

func _on_objectiveUpdate_received(data:ObjectiveSettings):
	widgetNode.updateObjective(data)
	objectiveScreenNode.updateObjective(data)

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


func _on_menuSettings_pressed():
	menuNode.hide()
	optionsNode.show()


func _on_menuSauvegarder_pressed():
	pass # Replace with function body.


func _on_menuQuitter_pressed():
	toMainMenu.emit()
	self.queue_free()


func _on_options_menu_exit():
	optionsNode.hide()
	menuNode.show()


func _on_destination_toggled(button_pressed):
	pass # Replace with function body.

func _on_small_objective_container_gui_input(event):
	if (event is InputEventMouseButton) && (event.button_index == MOUSE_BUTTON_LEFT) && (event.pressed):
		for i in main.get_children():
			i.hide()
		objectiveNode.show()
