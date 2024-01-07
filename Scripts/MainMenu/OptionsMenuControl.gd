extends VBoxContainer

signal exit()

const windowResolution = {
	"0":{
		"width":1920,
		"height":1080
	},
	"1":{
		"width":3840,
		"height":2160
	},
	"2":{
		"width":2560,
		"height":1440
	},
	"3":{
		"width":1600,
		"height":900
	},
	"4":{
		"width":1280,
		"height":720
	},
	"5":{
		"width":1152,
		"height":648
	},
	"6":{
		"width":1024,
		"height":576
	},
}
#Audio
@onready var masterVolumeNode =%MasterVolumeSlider
@onready var masterVolumeEditNode =%MasterVolumeLineEdit
@onready var musicVolumeNode =%MusicVolumeSlider
@onready var musicVolumeEditNode = %MusicVolumeLineEdit
@onready var sfxVolumeNode= %SFXVolumeSlider
@onready var sfxVolumeEditNode=%SFXVolumeLineEdit
#Video
@onready var resolutionOptionNode=%ResolutionOption

var user_settings :UserSettings

# Called when the node enters the scene tree for the first time.
func _ready():
	user_settings = UserSettings.load_or_create()
	#Audio setup
	if masterVolumeNode:
		masterVolumeNode.value = user_settings.masterAudioLevel
		masterVolumeEditNode.value = masterVolumeNode.value
	if sfxVolumeNode:
		sfxVolumeNode.value = user_settings.sfxAudioLevel
		sfxVolumeEditNode.value = sfxVolumeNode.value
	if musicVolumeNode:
		musicVolumeNode.value = user_settings.musicAudioLevel
		musicVolumeEditNode.value = musicVolumeNode.value
	#Video setup
	if resolutionOptionNode:
		var res = windowResolution[user_settings.screenResolution]
		get_tree().root.content_scale_size = Vector2i(res.width,res.height)
		resolutionOptionNode.select(int(user_settings.screenResolution))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func volume(bus,value):
	AudioServer.set_bus_volume_db(bus,linear_to_db(value))


func _on_master_volume_slider_value_changed(value):
	volume(0,value)
	masterVolumeEditNode.value = value
	if user_settings:
		user_settings.masterAudioLevel = value
		user_settings.save()


func _on_master_volume_line_edit_value_changed(value):
	masterVolumeNode.value = value


func _on_music_volume_slider_value_changed(value):
	volume(1,value)
	musicVolumeEditNode.value = value
	if user_settings:
		user_settings.musicAudioLevel = value
		user_settings.save()


func _on_music_volume_line_edit_value_changed(value):
	musicVolumeNode.value = value


func _on_sfx_volume_slider_value_changed(value):
	volume(2,value)
	sfxVolumeEditNode.value = value
	if user_settings:
		user_settings.sfxAudioLevel = value
		user_settings.save()

func _on_sfx_volume_line_edit_value_changed(value):
	sfxVolumeNode.value = value

func _on_back_pressed():
	exit.emit()


func _on_resolution_option_item_selected(index):
	var res = windowResolution[str(resolutionOptionNode.get_item_id(index))]
	get_tree().root.content_scale_size = Vector2i(res.width,res.height)
	if user_settings:
		user_settings.screenResolution = str(resolutionOptionNode.get_item_id(index))
		user_settings.save()
