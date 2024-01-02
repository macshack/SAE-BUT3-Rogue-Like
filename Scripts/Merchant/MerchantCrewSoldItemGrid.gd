extends GridContainer

var itemSlot = preload("res://Scenes/Merchant/MerchantItemSlot.tscn")

var soldInventory:Array[Item] = []

var rootNode
var merchantSignal
var sellingNode
# Called when the node enters the scene tree for the first time.
func _ready():
	merchantSignal = $"../../../../merchantSignal"
	rootNode = $"../../../../.."
	sellingNode = $"../../ScrollContainer/CrewSellableItemGrid"
	makeSoldItemsGrid()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if soldInventory.size() > 0:
		makeSoldItemsGrid()
	else:
		if self.get_children().size() > 0:
			for c in self.get_children():
				c.queue_free()

func makeSoldItemsGrid():
	for c in self.get_children():
		c.queue_free()
	for i in soldInventory:
		var slot = itemSlot.instantiate().init(i)
		slot.merchant_success.connect(_merchant_success)
		slot.merchant_sold.connect(_merchant_reverse)
		slot.merchant_error.connect(_merchant_error)
		slot.canBuy = false
		slot.reverseBuy = true
		self.add_child(slot)
		
func _merchant_success(message:String):
	rootNode.merchantMessageFadeawayTimer = 3.0
	merchantSignal.label_settings.font_color = Color(1,0,0)
	merchantSignal.text = message
	
func _merchant_reverse(item:Item):
	for i in soldInventory:
		if i.itemName == item.itemName:
			soldInventory.erase(i)
	
	
func _merchant_error(message:String):
	rootNode.merchantMessageFadeawayTimer = 3.0
	merchantSignal.label_settings.font_color = Color(1,0,0)
	merchantSignal.text = message
