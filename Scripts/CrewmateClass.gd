extends Character

class_name Crewmate

var background:String
var skills:Dictionary

func _init(identity = "defaultName", healthMax = 10, healthCurrent = 10, background = "-"):
	super(identity,healthMax,healthCurrent)
	self.background = background
	skills = importSkills()

func importSkills():
	var dictionary:Dictionary
	for skill in Skills.skillDictionary:
		dictionary[skill] = Skill.new(skill,Skills.skillDictionary[skill],6)
	return dictionary
