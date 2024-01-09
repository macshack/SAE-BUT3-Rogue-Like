class_name ObjectiveSettings extends Resource

@export var title:String = "Default objective"
@export var desc:String = "The default objective made in the initialization of the resource.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent a sapien dignissim, efficitur dolor vel, ornare augue. Cras tempus iaculis tortor at sollicitudin. Vestibulum eu nibh quam. In ornare a magna at varius. Phasellus dapibus diam a egestas bibendum. Vivamus nec ipsum lorem. Sed sed risus sit amet orci efficitur convallis. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Cras sagittis diam et turpis placerat, eu feugiat eros porttitor. Vivamus tristique felis velit, ac blandit libero cursus vitae. Maecenas imperdiet nunc ac mauris ornare consectetur. Donec quis libero sit amet turpis consectetur rutrum. Pellentesque auctor semper leo, in lobortis purus molestie non. Fusce in sapien eget est interdum tempus non at odio. Integer pellentesque risus arcu."
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

func save():
	ResourceSaver.save(self,"user://objective_settings.tres")
	
static func load_or_create() -> ObjectiveSettings:
	var res: ObjectiveSettings = load("user://objective_settings.tres") as ObjectiveSettings
	if !res:
		res = ObjectiveSettings.new()
	return res
