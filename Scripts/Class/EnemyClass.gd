extends Character

class_name Enemy

var attackPower:int
var baseAttackPower:int
var healthMax: int
var burn: Array = []
var stun: Array = []
var weakpoint: Array = []
var buff:Array=[]
var debuff:Array=[]

func _init(identity = "", icon = "", healthCurrent = 10, healthMax = 10, attackPower = 2):
	super(identity, icon, healthCurrent)
	self.baseAttackPower = attackPower
	self.attackPower = attackPower
	self.healthMax = healthMax
	self.burn = [false, 0, 0]
	self.stun = [false, 0]
	self.weakpoint = [false, 0]
	self.buff = [false,0]
	self.debuff = [false,0]
  
func _process(delta):
	var totalAttackPower = self.baseAttackPower
	self.attackPower = totalAttackPower

func toDictionary()->Dictionary:
	var dict = {
		"identity":self.identity,
		"icon":self.icon,
		"healthCurrent":self.healthCurrent,
		"attackPower":self.attackPower,
		"healthMax":self.healthMax,
	}
	return dict
