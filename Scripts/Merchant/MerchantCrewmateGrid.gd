extends HBoxContainer

@onready var rootNode = $"../../../../.."
@onready var refreshButton = %Refresh
@onready var merchantSignal = %merchantSignal

var crewmateSlot = preload("res://Scenes/Merchant/MerchantCrewmateSlot.tscn")

func _ready():
	for i in 3:
		var crewmate = JsonHandling.crewmate_data[JsonHandling.crewmate_data.keys()[ randi() % JsonHandling.crewmate_data.size()]]
		var slot = crewmateSlot.instantiate().init(crewmate)
		slot.merchant_success.connect(_merchant_success)
		slot.merchant_error.connect(_merchant_error)
		add_child(slot)

func _merchant_success(message):
	rootNode.merchantMessageFadeawayTimer = 3.0
	merchantSignal.label_settings.font_color = Color(0,1,0)
	merchantSignal.label_settings.font_size = 40
	merchantSignal.text = message
	
func _merchant_error(message):
	rootNode.merchantMessageFadeawayTimer = 3.0
	merchantSignal.label_settings.font_color = Color(1,0,0)
	merchantSignal.label_settings.font_size = 40
	merchantSignal.text = message
