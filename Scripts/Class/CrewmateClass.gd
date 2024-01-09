extends Character

#Un crewmate est un membre de l'equipage des joueurs.
class_name Crewmate

var background:String
#Rework les skills comme sur le notion
var skillOne
var skillTwo
var gear:Gear = Gear.new()
var healthMax:int
var dodgeCurrent:float
var attackCurrent:int
var speedCurrent:int
var critCurrent:int
var hirePrice:int

func get_health_max():
	return healthMax

func set_health_current(value):
	healthCurrent = clamp(value,0,healthMax)
	
func set_health_max(value):
	healthMax = value

func _init(identity = "",icon="", background = "",skills:Array[int]=[100,101],price = 0, gear = [], healthBase = 10, healthCurrent = healthBase, attackBase = 3, speedBase = 5, critBase = 5.0, dodgeBase = 5.0):
	super(identity,icon,healthMax,healthCurrent,attackBase,speedBase,critBase,dodgeBase)
	self.background = background
	self.hirePrice = price
	self.healthMax = self.healthBase
	self.skillOne = Game.skillList[skills[0]]
	self.skillTwo = Game.skillList[skills[1]]
	for item in gear:
		self.gear.equipItem(item)
	applyModifiersToCrewmate()


func applyModifiersToCrewmate():
	var tempATK = self.attackBase
	var tempHP = self.healthBase
	var tempSPD = self.speedBase
	var tempCRT = self.critBase
	var tempDDG = self.dodgeBase
	for item in gear.getList():
		if gear.getList()[item] is Item:
			for stat in gear.getList()[item].getModifiers():
				match stat:
					"ATK":
						tempATK += gear.getList()[item].getModifiers()[stat]
					"HP":
						tempHP += gear.getList()[item].getModifiers()[stat]
					"SPD":
						tempSPD += gear.getList()[item].getModifiers()[stat]
					"CRT":
						tempCRT += gear.getList()[item].getModifiers()[stat]
					"DDG":
						tempDDG += gear.getList()[item].getModifiers()[stat]
			
	self.attackCurrent = tempATK
	self.healthMax = tempHP
	self.speedCurrent = tempSPD
	self.critCurrent = tempCRT
	self.dodgeCurrent = tempDDG
	
#Fonctionne uniquement si l'instance de Crewmate est dans l'arborescence des noeuds
func _process(delta):
	pass
	
