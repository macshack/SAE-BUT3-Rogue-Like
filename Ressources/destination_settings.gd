class_name DestinationSettings extends Resource

#TODO

func save():
	ResourceSaver.save(self,"user://destination_settings.tres")

static func load_or_create() -> DestinationSettings:
	var res: DestinationSettings = load("user://destination_settings.tres") as DestinationSettings
	if !res:
		res = DestinationSettings.new()
	return res
