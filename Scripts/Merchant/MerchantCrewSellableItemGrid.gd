extends GridContainer

var itemSlot = preload("res://Scenes/Merchant/MerchantItemSlot.tscn")

@onready var rootNode = $"../../../../../.."
@onready var merchantSignal = %merchantSignal
@onready var soldNode = %CrewSoldItemGrid

# Called when the node enters the scene tree for the first time.
func _ready():
	makeInventoryGrid()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Game.inventory.size() > 0 || Game.inventory.size() != self.get_children().size():
		makeInventoryGrid()

func makeInventoryGrid():
	for c in self.get_children():
		c.queue_free()
	for i in Game.inventory:
		var slot = itemSlot.instantiate().init(i)
		slot.merchant_success.connect(_merchant_success)
		slot.merchant_sold.connect(_merchant_sold)
		slot.merchant_error.connect(_merchant_error)
		slot.canBuy = false
		self.add_child(slot)
		
func _merchant_success(message:String):
	rootNode.merchantMessageFadeawayTimer = 3.0
	merchantSignal.label_settings.font_color = Color(0,1,0)
	merchantSignal.label_settings.font_size = 40
	merchantSignal.text = message
	
func _merchant_sold(item:Item):
	soldNode.soldInventory.append(item)
	
func _merchant_error(message:String):
	rootNode.merchantMessageFadeawayTimer = 3.0
	merchantSignal.label_settings.font_color = Color(1,0,0)
	merchantSignal.label_settings.font_size = 40
	merchantSignal.text = message
