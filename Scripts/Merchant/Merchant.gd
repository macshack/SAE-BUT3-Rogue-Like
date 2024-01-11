extends Control

var merchantData
var itemData
var refreshCost = 100
var merchantMessageFadeawayTimer = 3.0

@onready var buyContainer= %BuyContainer
@onready var sellContainer= %SellContainer

@onready var credits = %Credits

@onready var merchantName = %MerchantName
@onready var merchantDesc = %MerchantDescription
@onready var merchantIcon = %MerchantIcon

@onready var merchantSignal = %merchantSignal

func _ready():
	buyContainer.show()
	sellContainer.hide()
	if randi() % 2 == 0:
		merchantData = JsonHandling.merchant_data["0"];
	else:
		merchantData = JsonHandling.merchant_data["1"];
	
	merchantName.text = merchantData.name
	merchantDesc.text = merchantData.description
	merchantIcon.texture = load("res://Assets/Portraits/"+merchantData.icon)

func _process(delta):
	credits.text = "Credits : "+str(Game.credits)+"C"
	if merchantSignal.label_settings.font_color.a > 0:
		merchantMessageFadeawayTimer -= delta
	else:
		merchantMessageFadeawayTimer = 3.0
	if merchantMessageFadeawayTimer <= 0.0:
		merchantSignal.label_settings.font_color.a -= 0.005
		


func _on_buy_button_pressed():
	sellContainer.hide()
	buyContainer.show()

func _on_sell_button_pressed():
	sellContainer.show()
	buyContainer.hide()
