class_name GameSettings extends Resource

@export var currentRound:int = 1
@export var credits:int = 200
@export var roundConstraint:int = -1
@export var playerCrew = []
@export var ennemyCrew = []
@export var invenotory = []

func save():
	ResourceSaver.save(self,"user://game_settings.tres")

static func load_or_create() -> GameSettings:
	var res: GameSettings = load("user://game_settings.tres") as GameSettings
	if !res:
		res = GameSettings.new()
	return res
