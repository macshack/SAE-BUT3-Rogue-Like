extends Node2D

class_name MerchantCrewmateSlot

var crewmate:Crewmate
var available = true

#Pour l'auto scroll
var previousScroll
var timer = 0.05
var secondTimer = 0.5

signal merchant_error(message:String)
signal merchant_success(message:String)

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/ScrollContainer.scroll_horizontal = 0
	$VBoxContainer/Label.text = str(crewmate.hirePrice)
	$VBoxContainer/TextureRect.texture = load("res://Assets/Portraits/"+crewmate.icon)
	$VBoxContainer/ScrollContainer/Label2.text = crewmate.identity

func _process(delta):
	if timer > 0:
		timer -= delta
	else:
		$VBoxContainer/ScrollContainer.scroll_horizontal += 1
		if (previousScroll == $VBoxContainer/ScrollContainer.scroll_horizontal):
			$VBoxContainer/ScrollContainer.scroll_horizontal = 0
		else:
			previousScroll = $VBoxContainer/ScrollContainer.scroll_horizontal
		timer = 0.05
		
	

func init(crewmateParam):
	crewmate = Crewmate.new(crewmateParam.identity,crewmateParam.icon,crewmateParam.background,crewmateParam.hirePrice)
	return self

func _on_slot_input(event):
	if event is InputEventMouseButton  && event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
		if available:
			if Game.playerCrew.crewList.size() < 5:
				if ((Game.credits - crewmate.hirePrice) >= 0):
					available = false
					$VBoxContainer/Label.text = "Indisponible."
					$VBoxContainer.modulate = Color(1.0,1.0,1.0,0.25)
					Game.credits -= crewmate.hirePrice
					Game.playerCrew.addCrewmate(crewmate)
					merchant_success.emit(crewmate.identity+" a te recrute avec succes.")
				else:
					merchant_error.emit("Pas assez de credits.")
			else:
				merchant_error.emit("Equipage complet.")
