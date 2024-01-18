extends Control

signal crewmateCreated(crewmate:Crewmate)
signal back()
signal finalNext(crew:Array[Crewmate])

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
	iconNode = %HBoxContainer
	crewmateNameEdit = %LineEdit
	skillMenu1 = %Cewskill1IOption
	skillMenu2 = %Cewskill2IOption
	backgroundNode = %TextEdit
	crewNode = %Crew
	for s in Game.skillList:
		skillMenu1.get_popup().add_item(Game.skillList[s].skillName,Game.skillList[s].skillId)
		skillMenu2.get_popup().add_item(Game.skillList[s].skillName,Game.skillList[s].skillId)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if skillMenu1:
		if skillMenu1.get_selected_id() == -1:
			%Validate.disabled = true
	if skillMenu2:
		if skillMenu2.get_selected_id() == -1:
			%Validate.disabled = true
	if skillMenu1.get_selected_id() != -1 && skillMenu2.get_selected_id() != -1:
		%Validate.disabled = false
	if crew.size() > 0:
		$PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/Start.disabled = false

func fillForm(crewmate:Crewmate):
	crewmateNameEdit.text = crewmate.identity
	skillMenu1.select(-1)
	skillMenu2.select(-1)
	skillMenu1.select(skillMenu1.get_popup().get_item_index(crewmate.skillOne.skillId))
	skillMenu2.select(skillMenu2.get_popup().get_item_index(crewmate.skillTwo.skillId))
	backgroundNode.text = crewmate.background
	iconNode.loadFromString(crewmate.icon)
	

func _on_start_pressed():
	finalNext.emit(crew)


func _on_previous_menu_pressed():
	back.emit()


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
	
