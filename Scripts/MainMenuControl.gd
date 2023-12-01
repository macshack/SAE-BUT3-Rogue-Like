extends CenterContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	$Menu.show()
	$Leaderboard.hide()
	$Options.hide()

func show_hide(optionOne,optionTwo):
	optionOne.show()
	optionTwo.hide()

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/DestinationScene.tscn")


func _on_options_pressed():
	show_hide($Options,$Menu)


func _on_leaderboard_pressed():
	show_hide($Leaderboard,$Menu)

func _on_quit_pressed():
	get_tree().quit()
