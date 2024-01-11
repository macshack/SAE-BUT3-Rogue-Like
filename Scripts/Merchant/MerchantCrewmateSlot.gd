extends PanelContainer
class_name MerchantCrewmateSlot

var crewmate:Crewmate
var available = true

#Pour l'auto scroll
var previousScroll
var timer = 0.05
var secondTimer = 0.25

signal merchant_error(message:String)
signal merchant_success(message:String)

@onready var scrollNode = %ScrollContainer
@onready var nameNode = %crewmateName
@onready var iconNode = %crewmateIcon
@onready var priceNode = %crewmatePrice
@onready var vboxNode = %VBoxContainer

@onready var skillOneNode =%skillOne
@onready var skillTwoNode =%skillTwo

# Called when the node enters the scene tree for the first time.
func _ready():
	scrollNode.scroll_horizontal = 0
	priceNode.text = "Recruter - "+str(crewmate.hirePrice)+"C"
	iconNode.texture = load("res://Assets/Portraits/"+crewmate.icon)
	nameNode.text = crewmate.identity
	skillOneNode.text = crewmate.skillOne.skillName
	skillTwoNode.text = crewmate.skillTwo.skillName

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
	

func init(crewmateParam):
	var skillArray:Array[int] = [crewmateParam.skills[0],crewmateParam.skills[1]]
	crewmate = Crewmate.new(crewmateParam.identity,crewmateParam.icon,crewmateParam.background,skillArray,crewmateParam.hirePrice)
	return self

func _on_gui_input(event):
	if event is InputEventMouseButton  && event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
		if available:
			if Game.crew.size() < 5:
				if ((Game.credits - crewmate.hirePrice) >= 0):
					available = false
					priceNode.text = "Indisponible."
					vboxNode.modulate = Color(1.0,1.0,1.0,0.25)
					Game.credits -= crewmate.hirePrice
					Game.crew.append(crewmate)
					merchant_success.emit(crewmate.identity+" a ete recrute avec succes.")
				else:
					merchant_error.emit("Pas assez de credits.")
			else:
				merchant_error.emit("Equipage complet.")
