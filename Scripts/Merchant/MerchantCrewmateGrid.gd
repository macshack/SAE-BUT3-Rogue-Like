extends GridContainer

var crewmateSlot = preload("res://Scenes/Merchant/MerchantCrewmateSlot.tscn")

func _ready():
	var children = get_children()
	for i in children:
		var crewmate = JsonHandling.crewmate_data[str(randi()%3)]
		var slot = crewmateSlot.instantiate().init(crewmate)
		slot.merchant_success.connect(_merchant_success)
		slot.merchant_error.connect(_merchant_error)
		i.add_child(slot)

func _merchant_success(message):
	$"../../merchantSignal".label_settings = LabelSettings.new()
	$"../../merchantSignal".label_settings.font_color = Color(0,1,0)
	$"../../merchantSignal".text = message
	
func _merchant_error(message):
	$"../../merchantSignal".label_settings = LabelSettings.new()
	$"../../merchantSignal".label_settings.font_color = Color(1,0,0)
	$"../../merchantSignal".text = message
