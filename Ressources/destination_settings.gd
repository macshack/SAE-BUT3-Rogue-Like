class_name DestinationSettings extends Resource

@export var backgroundFile:String = "YellowRadar/yellowRadar (2).png"
@export_range(1,4,1) var difficulty:int = 1
@export var name:String = "Station marchande"
@export var flavor:String = "Une station marchande banale de l'UIH, vous en avez vu des centaines, si ce n'est des miliers au cours de votre vie. Avec un peu de chance vous denicherez une arme standard ou peut-etre que vous rencontrerez une personne peu interressante mais prete a se joindre a votre equipage."
@export_enum("FIGHT","MERCHANT","BOSS") var type:String = "MERCHANT"
@export var situationDone:bool = false

func save():
	ResourceSaver.save(self,"user://destination_settings.tres")

static func load_or_create() -> DestinationSettings:
	var res: DestinationSettings = load("user://destination_settings.tres") as DestinationSettings
	if !res:
		res = DestinationSettings.new()
	return res

func reset():
	name = "Quelques part, dans le vide"
	flavor = "..."
	backgroundFile = "BlueRadar/blueRadar (5).png"
	difficulty = 1
	type = "MERCHANT"
