extends Control

signal objchosen(obj:Dictionary)
signal backtomenu()

@onready var optionNode = %OptionButton 
@onready var nextNode = %Next

@onready var descNode = %ObjDesc
@onready var labelNode = %ObjLabel
@onready var detailNode = %ObjectiveDetail

# Called when the node enters the scene tree for the first time.
func _ready():
	for o in JsonHandling.objective_data:
		optionNode.get_popup().add_item(JsonHandling.objective_data[o].title,int(o))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if optionNode.get_selected_id() != -1:
		nextNode.disabled = false
	else:
		nextNode.disabled = true

func _on_next_pressed():
	objchosen.emit(JsonHandling.objective_data[str(optionNode.get_selected_id())])


func _on_back_pressed():
	backtomenu.emit()


func _on_option_button_item_selected(index):
	detailNode.show()
	labelNode.text = JsonHandling.objective_data[str(index)].text
	descNode.text = JsonHandling.objective_data[str(index)].description
