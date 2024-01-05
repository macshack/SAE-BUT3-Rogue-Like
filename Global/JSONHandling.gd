extends Node

var merchant_data:Dictionary
var item_data:Dictionary
var crewmate_data:Dictionary
var skill_data:Dictionary
# Called when the node enters the scene tree for the first time.
func _ready():
	merchant_data = loadData("res://Data/MerchantJSON.json")
	item_data = loadData("res://Data/ItemJSON.json")
	crewmate_data = loadData("res://Data/CrewmateJSON.json")
	skill_data = loadData("res://Data/skillJSON.json")
	Game.skillList = Game.loadSkillList()

func loadData(file_path):
	var json_data = JSON.new()
	var result
	var file_data = FileAccess.open(file_path,FileAccess.READ)
	result = json_data.parse_string(file_data.get_as_text())
	file_data.close()
	return result
