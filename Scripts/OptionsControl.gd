extends VBoxContainer

var screenType
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_to_main_menu_pressed():
	$".".hide()
	$"../Menu".show()


func volume(bus,value):
	AudioServer.set_bus_volume_db(bus,linear_to_db(value))

func _on_master_slider_value_changed(value):
	volume(0,value)


func _on_music_slider_value_changed(value):
	volume(1,value)


func _on_sound_effects_slider_value_changed(value):
	volume(2,value)
