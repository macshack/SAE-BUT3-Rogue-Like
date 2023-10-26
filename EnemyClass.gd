extends Character

class_name Enemy

var attackPower:int

func _init(identity = "defaultName", healthMax = 10, healthCurrent = 10, attackPower = 2):
	super(identity,healthMax,healthCurrent)
	self.attackPower = attackPower
