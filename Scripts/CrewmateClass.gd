extends Character

class_name Crewmate

var background:String

func _init(identity = "defaultName", healthMax = 10, healthCurrent = 10, background = "-"):
	super(identity,healthMax,healthCurrent)
	self.background = background
