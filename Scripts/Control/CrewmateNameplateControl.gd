extends AspectRatioContainer

signal click_on_nameplate(crewmate:Crewmate)

var crewmate:Crewmate
var nameNode
var iconNode
var healthNode
var skillOneNode
var skillTwoNode
# Called when the node enters the scene tree for the first time.
func _ready():
	nameNode = $MarginContainer/VBoxContainer/Name
	iconNode = $MarginContainer/VBoxContainer/HBoxContainer/Simple/Icon
	healthNode = $MarginContainer/VBoxContainer/HBoxContainer/Simple/ProgressBar
	skillOneNode = $MarginContainer/VBoxContainer/HBoxContainer/Extended/Skill1
	skillTwoNode = $MarginContainer/VBoxContainer/HBoxContainer/Extended/Skill2
	nameNode.text = crewmate.identity
	iconNode.texture = load("res://Assets/Portraits/"+crewmate.icon)

func init(crewmate):
	self.crewmate = crewmate
	return self
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	healthNode.value = crewmate.healthCurrent
	healthNode.max_value = crewmate.healthMax

func _on_gui_input(event):
	if event is InputEventMouseButton  && event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
		click_on_nameplate.emit(crewmate)
		self.queue_free()
