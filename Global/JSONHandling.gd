extends Node

var merchant_data:Dictionary = loadData("res://Data/MerchantJSON.json")
var item_data:Dictionary = loadData("res://Data/ItemJSON.json")
var crewmate_data:Dictionary = loadData("res://Data/CrewmateJSON.json")
var enemy_data:Dictionary = loadData("res://Data/EnemyJSON.json")
var skill_data:Dictionary = loadData("res://Data/skillJSON.json")
var objective_data:Dictionary = loadData("res://Data/ObjectiveJSON.json")

var destMerchant_data:Dictionary = loadData("res://Data/DestinationMerchantJSON.json")
var destTier1_data:Dictionary = loadData("res://Data/DestinationTier1JSON.json")
var destTier2_data:Dictionary = loadData("res://Data/DestinationTier2JSON.json")
var destTier3_data:Dictionary = loadData("res://Data/DestinationTier3JSON.json")
var destTier4_data:Dictionary = loadData("res://Data/DestinationTier4JSON.json")
var boss_template:Dictionary = loadData("res://Data/bossJSON.json")
# Called when the node enters the scene tree for the first time.
func loadData(file_path):
	var json_data = JSON.new()
	var result
	var file_data = FileAccess.open(file_path,FileAccess.READ)
	result = json_data.parse_string(file_data.get_as_text())
	file_data.close()
	return result
