extends Control

signal send_old_item(oldItem,newItem,parent)

var itemSlot = preload("res://Scenes/TestScenes/testINVENTORY/slottest.tscn")
var crewmatePanel = preload("res://Scenes/TestScenes/testINVENTORY/crewmatepanel.tscn")

@export var test:bool = false
var inventorySize = 0
@onready var grid = %GridContainer
@onready var preview = %ItemPreview
@onready var crewNode = %CrewmateContainer
@onready var itemNumber = %ItemNumber
@onready var crew:Array[Crewmate] = [Crewmate.new("Mickael Jackson","Human (20).jpg","",[102,103],100,[Item.new("Pelle","caca","Human (50).jpg")]),Crewmate.new("Groberto Mascutti","Human (45).jpg","",[102,103],100,[])]
@onready var inventory:Array[Item] = [Item.new("Truc","test","Human (10).jpg"),Item.new("Fusil a pompe","test","Human (20).jpg")]

func _ready():
	preview.hide()
	if test:
		for cr in crew:
			var panel = crewmatePanel.instantiate().init(cr)
			panel.send_old_item.connect(_receive_old_item)
			self.send_old_item.connect(panel._receive_old_item)
			crewNode.add_child(panel)
	else:
		for cr in Game.crew.size():
			var panel = crewmatePanel.instantiate().init(int(cr))
			panel.send_old_item.connect(_receive_old_item)
			self.send_old_item.connect(panel._receive_old_item)
			crewNode.add_child(panel)
	for i in 72:
		var slot = itemSlot.instantiate()
		slot.new_item.connect(_on_item_slot_new_item)
		slot.preview.connect(preview._set_item)
		grid.add_child(slot)
	refreshInventory()


func refreshInventory():
	if test:
		if grid.get_children().size() > 0:
			inventorySize = Game.inventory.size()
			for item in inventory.size():
				grid.get_children()[item].set_property(inventory[item])
	else:
		if grid.get_children().size() > 0:
			inventorySize = Game.inventory.size()
			for item in Game.inventory.size():
				grid.get_children()[item].set_property(Game.inventory[item])

func _receive_old_item(oldItem,newItem,parent):
	if test:
		print("Inventaire - Gestion ancien item")
		print("Parent : "+parent)
		if oldItem is Item:
			if inventory.find(newItem) != -1:
				inventory[inventory.find(newItem)] = oldItem
				print("Remplacer dans l'inventaire")
		else:
			if inventory.find(newItem) != -1:
				inventory.pop_at(inventory.find(newItem))
				print("Supprime de l'inventaire")
	else:
		if oldItem is Item:
			if Game.inventory.find(newItem) != -1:
				Game.inventory[Game.inventory.find(newItem)] = oldItem
		else:
			if Game.inventory.find(newItem) != -1:
				Game.inventory.pop_at(Game.inventory.find(newItem))

func _on_item_slot_new_item(newItem,oldItem,parent):
	if test:
		print("Inventaire - Nouvel item")
		if newItem is Item:
			if oldItem is Item:
				if inventory.find(oldItem) != -1:
					inventory[inventory.find(oldItem)] = newItem
					print("Inventaire - Apres swap"+str(inventory.size()))
			else:
				inventory.append(newItem)
				print("Inventaire - Apres equip"+str(inventory.size()))
		send_old_item.emit(oldItem,newItem,parent)
	else:
		if newItem is Item:
			if oldItem is Item:
				if Game.inventory.find(oldItem) != -1:
					Game.inventory[Game.inventory.find(oldItem)] = newItem
			else:
				Game.inventory.append(newItem)
		send_old_item.emit(oldItem,newItem,parent)

func _process(delta):
	if test:
		if inventorySize != inventory.size():
			inventorySize = inventory.size()
			itemNumber.text = "("+str(inventorySize)+")"
	else:
		if crewNode.get_children().size() != Game.crew.size():
			for c in crewNode.get_children():
				crewNode.remove_child(c)
			for cr in Game.crew.size():
				var panel = crewmatePanel.instantiate().init(int(cr))
				panel.send_old_item.connect(_receive_old_item)
				self.send_old_item.connect(panel._receive_old_item)
				crewNode.add_child(panel)
		if inventorySize != Game.inventory.size():
			inventorySize = Game.inventory.size()
			itemNumber.text = "("+str(inventorySize)+")"
