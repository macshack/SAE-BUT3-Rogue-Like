extends Node

var merchant_data:Dictionary = loadData("res://Data/MerchantJSON.json")
var item_data:Dictionary = loadData("res://Data/ItemJSON.json")
var crewmate_data:Dictionary = loadData("res://Data/CrewmateJSON.json")
var skill_data:Dictionary = loadData("res://Data/skillJSON.json")
var objective_data:Dictionary = loadData("res://Data/ObjectiveJSON.json")
# Called when the node enters the scene tree for the first time.

func loadData(file_path):
	var json_data = JSON.new()
	var result
	var file_data = FileAccess.open(file_path,FileAccess.READ)
	result = json_data.parse_string(file_data.get_as_text())
	file_data.close()
	return result
