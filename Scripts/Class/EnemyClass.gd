extends Character

class_name Enemy

var attackPower:int
var healthMax: int

func _init(identity = "", icon = "", healthMax = 10, healthCurrent = 10, attackPower = 2):
	super(identity, icon, healthCurrent)
	self.attackPower = attackPower
	self.healthMax = healthMax

func toDictionary()->Dictionary:
	var dict = {
		"identity":self.identity,
		"icon":self.icon,
		"healthCurrent":self.healthCurrent,
		"attackPower":self.attackPower,
		"healthMax":self.healthMax,
	}
	return dict
