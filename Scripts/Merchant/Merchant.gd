extends Node2D

var merchantData
var itemData

func _ready():
	if randi() % 2 == 0:
		merchantData = JsonHandling.merchant_data["0"];
	else:
		merchantData = JsonHandling.merchant_data["1"];
	
	$VBoxContainer/HBoxContainer/HBoxContainer/VBoxContainer/MerchantName.text = merchantData.name
	$VBoxContainer/HBoxContainer/HBoxContainer/VBoxContainer/MerchantDescription.text = merchantData.description
	$VBoxContainer/HBoxContainer/HBoxContainer/MerchantIcon.texture = load("res://Assets/Portraits/"+merchantData.icon)

func _process(delta):
	$VBoxContainer/Credits.text = "Credits : "+str(Game.credits)
