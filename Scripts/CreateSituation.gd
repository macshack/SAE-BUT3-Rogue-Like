extends Node

func createSituation():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var rand_nb = rng.randi_range(1, 3)
	var situation
	match rand_nb:
		1:
			var ex = load("res://Scripts/SituationExplorationClass.gd")
			situation = ex.new("Exploration", "Explore!")
		2:
			var fi = load("res://Scripts/SituationFightClass.gd")
			situation = fi.new("Fight", "FIIIIIGHHHHHHHTTT!", [])
		3:
			var me = load("res://Scripts/SituationMerchantClass.gd")
			situation = me.new("Merchant", "Sell and buy items!")
		_:
			situation = "Error!"
	return situation
