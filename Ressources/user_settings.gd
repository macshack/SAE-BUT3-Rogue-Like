class_name UserSettings extends Resource

@export_range(0,1,.05) var masterAudioLevel: float = 1.0
@export_range(0,1,.05) var musicAudioLevel: float = 1.0
@export_range(0,1,.05) var sfxAudioLevel: float = 1.0
@export var screenResolution:String = "0"

func save():
	ResourceSaver.save(self,"user://user_settings.tres")
	
static func load_or_create() -> UserSettings:
	var res: UserSettings = ResourceLoader.load("user://user_settings.tres") as UserSettings
	if !res:
		res = UserSettings.new()
	return res
