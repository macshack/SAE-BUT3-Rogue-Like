extends Character

#Un crewmate est un membre de l'equipage des joueurs.
class_name Crewmate

var background:String
var skills:Dictionary

func _init(identity = "defaultName", healthMax = 10, healthCurrent = 10, background = "-"):
	super(identity,healthMax,healthCurrent)
	self.background = background
	#On cree le dictionnaire de skill du crewmate. On appelle les variables globales de Skills.gd.
	for skill in Skills.skillDictionary:
		skills[skill] = Skill.new(skill,6)

func skillCheck(skill:String,roll:int):
	#Un skillCheck retourne true si le skillCheck est reussi.
	#Un skillCheck est reussi si le roll est inferieur ou egal a la valeur du skill.
	if roll <= skills[skill].get_current_value():
		return true
	else:
		return false
