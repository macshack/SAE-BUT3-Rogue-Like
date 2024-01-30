class_name ObjectiveSettings extends Resource

@export var title:String = "Default objective"
@export var desc:String = "The objective made in the initialization of the resource"
@export_enum("ACCUMULATION","NEVER","LESSER","MORE") var family:String = "ACCUMULATION"
@export_enum("CREDITS","DEAD_CREWMATE","DAMAGE_DEALT","GEAR","ENEMIES_KILLED","FIGHTS_WON","EXPLORATION_DONE","BOSS_KILLED") var type:String = "CREDITS"
@export var text:String = "Accumulate more than 10000 credits."
@export var goal:int = 10000
@export var current:int = 0
@export var constraint:bool = false
@export_enum("TIMER","ROUND","NONE") var constraintType:String = "NONE"
@export_range(1,7200,1) var constraintValue:int = 1
@export var constraintRemaining:int = -1
@export_enum("VICTORY","DEFEAT","PROGRESS") var state:String="PROGRESS"
@export var scoringRounds = 0
@export var scoringWins = 0

func save():
	ResourceSaver.save(self,"user://objective_settings.tres")
	
static func load_or_create() -> ObjectiveSettings:
	var res: ObjectiveSettings = ResourceLoader.load("user://objective_settings.tres") as ObjectiveSettings
	if !res:
		res = ObjectiveSettings.new()
	return res

static func reset():
	return ObjectiveSettings.new()
