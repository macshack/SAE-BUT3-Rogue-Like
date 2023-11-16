extends Situation

class_name SituationFight

var listEnemies = []

func _init(situationNames = "",description = "", listEnemies = []):
	super(situationNames, description)
	self.listEnemies = listEnemies

func get_listEnemies():
	return listEnemies

func set_listEnemies(value):
	self.listEnemies = value

