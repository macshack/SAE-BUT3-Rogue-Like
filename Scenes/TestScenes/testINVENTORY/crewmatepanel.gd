extends PanelContainer

signal send_old_item(oldItem,newItem,parent)

var previousScroll
var timer = 0.05
var secondTimer = 0.25

var crewmate:Crewmate = null
var crewIndex:int = -1

@onready var nameNode = %CrewmateName
@onready var iconNode = %CrewmateIcon
@onready var itemNode = %ItemContainer
@onready var scrollNode = %ScrollContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	if crewmate is Crewmate:
		nameNode.text = crewmate.identity
		iconNode.texture = load("res://Assets/Portraits/"+crewmate.icon)
		updateCrewmateGear(true)
	elif (crewIndex is int) && (crewIndex > -1):
		nameNode.text = Game.crew[crewIndex].identity
		iconNode.texture = load("res://Assets/Portraits/"+Game.crew[crewIndex].icon)
		updateCrewmateGear(false)

func getSelfNodeName():
	return str(self)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
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
	
func updateCrewmateGear(test:bool):
	if test:
		if crewmate is Crewmate:
			for itemIdx in crewmate.gear.itemList:
				if crewmate.gear.itemList[itemIdx] is Item:
					itemNode.get_children()[itemIdx].set_property(crewmate.gear.itemList[itemIdx])
			for node in itemNode.get_children():
				node.set_currentOwner(getSelfNodeName())#New line here
				node.set_family(false)
	else:
		if (crewIndex is int) && (crewIndex > -1):
			for itemIdx in Game.crew[crewIndex].gear.itemList:
				if Game.crew[crewIndex].gear.itemList[itemIdx] is Item:
					itemNode.get_children()[itemIdx].set_property(Game.crew[crewIndex].gear.itemList[itemIdx])
			for node in itemNode.get_children():
				node.set_currentOwner(getSelfNodeName())#New line here
				node.set_family(false)
		
# Game.crew[crewIndex]
func init(value):
	if value is int:
		crewIndex = value
		crewmate = null
	elif value is Crewmate:
		crewmate = value
		crewIndex = -1
	return self

func _receive_old_item(oldItem,newItem,ownerName):
	if crewmate is Crewmate:
		if ownerName == getSelfNodeName():
			if oldItem is Item:
				print("Crewmate - Avant equip : "+str(crewmate.gear.getList()))
				crewmate.gear.equipItem(oldItem,crewmate.gear.getList().find_key(newItem))
				print("Crewmate - Apres equip : "+str(crewmate.gear.getList()))
			else:
				print("Crewmate - Avant remove : "+str(crewmate.gear.getList()))
				crewmate.gear.removeItem(crewmate.gear.getList().find_key(newItem))
				print("Crewmate - Apres remove : "+str(crewmate.gear.getList()))
	elif (crewIndex is int) && (crewIndex > -1):
		if ownerName == getSelfNodeName():
			if oldItem is Item:
				Game.crew[crewIndex].gear.equipItem(oldItem,Game.crew[crewIndex].gear.getList().find_key(newItem))
			else:
				print("Avant remove - "+str(Game.crew[crewIndex].gear.getList()))
				Game.crew[crewIndex].gear.removeItem(Game.crew[crewIndex].gear.getList().find_key(newItem))
	

func _on_item_slot_1_new_item(newItem,oldItem,owner):
	if crewmate is Crewmate:
		print("Crewmate - Nouvel item")
		if newItem is Item:
			crewmate.gear.equipItem(newItem,0)
			print(crewmate.gear.getList())
		send_old_item.emit(oldItem,newItem,getSelfNodeName())
	elif (crewIndex is int) && (crewIndex > -1):
		if newItem is Item:
			Game.crew[crewIndex].gear.equipItem(newItem,0)
		send_old_item.emit(oldItem,newItem,getSelfNodeName())

func _on_item_slot_2_new_item(newItem,oldItem,owner):
	if crewmate is Crewmate:
		print("Crewmate - Nouvel item")
		if newItem is Item:
			crewmate.gear.equipItem(newItem,1)
			print(crewmate.gear.getList())
		send_old_item.emit(oldItem,newItem,getSelfNodeName())
	elif (crewIndex is int) && (crewIndex > -1):
		if newItem is Item:
			Game.crew[crewIndex].gear.equipItem(newItem,1)
		send_old_item.emit(oldItem,newItem,getSelfNodeName())

func _on_item_slot_3_new_item(newItem,oldItem,owner):
	if crewmate is Crewmate:
		print("Crewmate - Nouvel item")
		if newItem is Item:
			crewmate.gear.equipItem(newItem,2)
			print(crewmate.gear.getList())
		send_old_item.emit(oldItem,newItem,getSelfNodeName())
	elif (crewIndex is int) && (crewIndex > -1):
		if newItem is Item:
			Game.crew[crewIndex].gear.equipItem(newItem,2)
		send_old_item.emit(oldItem,newItem,getSelfNodeName())
