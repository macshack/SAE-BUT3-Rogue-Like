extends Control

signal crewmateCreated(crewmate:Crewmate)

var crewmateNameplateScene = load("res://Scenes/UI/CrewmateNameplate.tscn")

var skillMenu1
var skillMenu2
var crewmateNameEdit
var iconNode
var backgroundNode
var crewNode
var crew:Array[Crewmate] = []
var regex = RegEx.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	regex.compile("^[A-z\\s]+$")
	iconNode = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Creator/IconSelector/HBoxContainer
	crewmateNameEdit = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Creator/CrewmateName/LineEdit
	skillMenu1 = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Creator/CrewmateSkill1/OptionButton
	skillMenu2 = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Creator/CrewmateSkill2/OptionButton
	backgroundNode = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Creator/DescriptionBox/TextEdit
	crewNode = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Crew
	for s in Game.skillList:
		skillMenu1.get_popup().add_item(Game.skillList[s].skillName,Game.skillList[s].skillId)
		skillMenu2.get_popup().add_item(Game.skillList[s].skillName,Game.skillList[s].skillId)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func fillForm(crewmate:Crewmate):
	crewmateNameEdit.text = crewmate.identity
	skillMenu1.select(-1)
	skillMenu2.select(-1)
	skillMenu1.select(skillMenu1.get_popup().get_item_index(crewmate.skillOne.skillId))
	skillMenu2.select(skillMenu1.get_popup().get_item_index(crewmate.skillTwo.skillId))
	backgroundNode.text = crewmate.background
	iconNode.loadFromString(crewmate.icon)
	

func _on_start_pressed():
	pass # Replace with function body.


func _on_previous_menu_pressed():
	pass # Replace with function body.


func _on_validate_pressed():
	if crew.size() < 5:
		var skillOne = skillMenu1.get_selected_id()
		var skillTwo = skillMenu2.get_selected_id()
		var name = crewmateNameEdit.text
		var icon = iconNode.currentTexture
		var background = backgroundNode.text
		if skillOne != skillTwo && regex.search_all(name).size() > 0:
			var crewmate = Crewmate.new(name,icon,background,[skillOne,skillTwo])
			crewmateCreated.emit(crewmate)


func _on_crewmate_name_text_changed(new_text):
	if !regex.search_all(new_text).size() > 0:
		crewmateNameEdit.add_theme_color_override("font_color",Color(1,0,0))
	else:
		crewmateNameEdit.add_theme_color_override("font_color",Color(1,1,1))


func _on_skill1_selected(index):
	skillMenu2.get_popup().clear()
	for s in Game.skillList:
		if Game.skillList[s].skillId != skillMenu1.get_popup().get_item_id(index):
			skillMenu2.get_popup().add_item(Game.skillList[s].skillName,Game.skillList[s].skillId)


func _on_skill2_selected(index):
	skillMenu1.get_popup().clear()
	for s in Game.skillList:
		if Game.skillList[s].skillId != skillMenu2.get_popup().get_item_id(index):
			skillMenu1.get_popup().add_item(Game.skillList[s].skillName,Game.skillList[s].skillId)


func _on_crewmate_created(crewmate):
	crew.append(crewmate)
	for c in crewNode.get_children():
		c.queue_free()
	for cr in crew:
		var nameplate = crewmateNameplateScene.instantiate().init(cr)
		nameplate.click_on_nameplate.connect(_on_crewmate_click)
		crewNode.add_child(nameplate)
	
func _on_crewmate_click(crewmate:Crewmate):
	if crew.find(crewmate) != -1:
		crew.erase(crewmate)
		fillForm(crewmate)
	
