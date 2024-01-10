extends Character

class_name Enemy

var attackPower:int
var burn: Array[int] = []
var stun: Array[int] = []
var weakpoint: Array = []
var healthMax: int

func _init(identity = "", icon = "", healthCurrent = 10, healthMax = 10, attackPower = 2):
	super(identity, icon, healthCurrent)
	self.attackPower = attackPower
	self.healthMax = healthMax
	self.burn = [false, 0]
	self.stun = [false, 0, 0]
	self.weakpoint = [false, 0]


