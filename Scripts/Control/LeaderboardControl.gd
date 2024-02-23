extends VBoxContainer

@onready var scoreboardLine = preload("res://Scenes/UI/scoreboard_line.tscn")

var data
var request
# Called when the node enters the scene tree for the first time.
func _ready():
	request = HTTPRequest.new()
	request.request_completed.connect(_on_request_completed)
	fetchLeaderboard()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_request_completed(result, response_code, headers, body):
	if (response_code == 200):
		var answer = JSON.parse_string(body.get_string_from_utf8())
		data = answer.result
		for c in $ScrollContainer/Tableau.get_children():
			c.queue_free()
		for player in data:
			var inst = scoreboardLine.instantiate()
			inst.setData(player["userId"],JSON.stringify(player["gameData"]["highestScore"]))
			$ScrollContainer/Tableau.add_child(inst)
	else:
		var inst = scoreboardLine.instantiate()
		inst.setData("Unavailable data.","NaN")
		$ScrollContainer/Tableau.add_child(inst)

func fetchLeaderboard():
	request.request("http://localhost:5500/getBestscores")


func _on_visibility_changed():
	fetchLeaderboard();


func _on_to_main_menu_pressed():
	$".".hide()
	$"../Menu".show()


func _on_refresh_pressed():
	fetchLeaderboard()
