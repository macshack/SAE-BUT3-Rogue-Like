extends Control

var merchantData
var itemData
var refreshCost = 100
var merchantMessageFadeawayTimer = 3.0

var buyContainer
var sellContainer

func _ready():
	buyContainer = $VBoxContainer/BuyContainer
	sellContainer = $VBoxContainer/SellContainer
	buyContainer.show()
	sellContainer.hide()
	if randi() % 2 == 0:
		merchantData = JsonHandling.merchant_data["0"];
	else:
		merchantData = JsonHandling.merchant_data["1"];
	
	$VBoxContainer/HBoxContainer/HBoxContainer/VBoxContainer/MerchantName.text = merchantData.name
	$VBoxContainer/HBoxContainer/HBoxContainer/VBoxContainer/MerchantDescription.text = merchantData.description
	$VBoxContainer/HBoxContainer/HBoxContainer/MerchantIcon.texture = load("res://Assets/Portraits/"+merchantData.icon)
	

func _process(delta):
	$VBoxContainer/Credits.text = "Credits : "+str(Game.credits)
	if $VBoxContainer/merchantSignal.label_settings.font_color.a > 0:
		merchantMessageFadeawayTimer -= delta
	else:
		merchantMessageFadeawayTimer = 3.0
	if merchantMessageFadeawayTimer <= 0:
		$VBoxContainer/merchantSignal.label_settings.font_color.a -= 0.005
		


func _on_check_button_toggled(button_pressed):
	if button_pressed:
		buyContainer.hide()
		sellContainer.show()
	else:
		buyContainer.show()
		sellContainer.hide()
