extends Character

class_name Enemy

func _init(identity = "defaultName", healthMax = 10, healthCurrent = 10, attackPower = 1, speed = 1, state = State.LIVING):
	super(identity,healthMax,healthCurrent, attackPower, speed, state)
