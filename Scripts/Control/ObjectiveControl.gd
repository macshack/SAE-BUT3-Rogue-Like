extends Node

signal newData(objectiveData:ObjectiveSettings)
signal victory(objectiveResult:Dictionary)
signal defeat(objectiveResult:Dictionary)

var objective_settings:ObjectiveSettings

# Called when the node enters the scene tree for the first time.
func _ready():
	if objective_settings:
		if objective_settings.constraint:
			if objective_settings.constraintValue > 0:
				if objective_settings.constraintType == "TIMER":
					var timer = Timer.new()
					timer.one_shot=true
					timer.autostart = true
					timer.wait_time = objective_settings.constraintValue
					timer.timeout.connect(_endGame)
					self.add_child(timer)
				elif objective_settings.constraintType == "ROUND":
					Game.roundConstraint = objective_settings.constraintValue+1
				else:
					objective_settings.constraint = false
	else:
		objective_settings = ObjectiveSettings.load_or_create()

func forceSave():
	if objective_settings.constraint:
		if objective_settings.constraintType == "ROUND":
			objective_settings.constraintRemaining = Game.roundConstraint
		elif objective_settings.constraintType == "TIMER":
			if self.get_child(0) is Timer:
				objective_settings.constraintRemaining = snapped(self.get_child(0).time_left,1)
	objective_settings.save()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	saveAndEmit()
	if Game.currentRound > objective_settings.constraintValue:
		_endGame()
		
func saveAndEmit():
	objective_settings.save()
	newData.emit(objective_settings)

func init(load:bool,data:Dictionary):
	if load:
		objective_settings = ObjectiveSettings.load_or_create()
	elif (data is Dictionary):
		objective_settings = ObjectiveSettings.load_or_create()
		objective_settings.title = data["title"]
		objective_settings.desc = data["description"]
		objective_settings.family = data["family"]
		objective_settings.type = data["type"]
		objective_settings.text = data["text"]
		objective_settings.goal = data["goal"]
		objective_settings.current = 0
		objective_settings.constraint = data["constraint"]
		if objective_settings.constraint:
			objective_settings.constraintType = data["constraintType"]
			objective_settings.constraintValue = data["constraintValue"]
			objective_settings.constraintRemaining = data["constraintValue"]
		else:
			objective_settings.constraint = false
			objective_settings.constraintType = "NONE"
			objective_settings.constraintValue = 1
			objective_settings.constraintRemaining = -1
		saveAndEmit()
	return self
	
func analyze(finalAnalysis:bool = false,situationResult:Dictionary = {}):
	match(objective_settings.type):
		"CREDITS":
			if situationResult.has("credits"):
				self.objective_settings.current += situationResult["credits"]
				saveAndEmit()
		"DAMAGE_DEALT":
			if situationResult.has("total_damage_dealt"):
				self.objective_settings.current += situationResult["total_damage_dealt"]
				saveAndEmit()
		"GEAR":
			#The amount of gear dropped through exploration/fights
			if situationResult.has("item_drops"):
				self.objective_settings.current += situationResult["item_drops"].size()
				saveAndEmit()
		"ENEMIES_KILLED":
			if situationResult.has("enemies_killed"):
				self.objective_settings.current += situationResult["enemies_killed"]
				saveAndEmit()
		"FIGHTS_WON":
			if situationResult.has("fight_result"):
				if situationResult["fight_result"]:
					self.objective_settings.current += 1
					saveAndEmit()
		"EXPLORATION_DONE":
			if situationResult.has("exploration_result"):
				if situationResult["exploration_result"]:
					self.objective_settings.current += 1
					saveAndEmit()
		"BOSS_KILLED":
			if situationResult.has("boss_fight"):
				if situationResult["boss_fight"]:
					self.objective_settings.current += 1
					saveAndEmit()
	
	match(objective_settings.family):
		"ACCUMULATION":
			if self.objective_settings.current >= self.objective_settings.goal:
				victory.emit(objectiveDataToDictionnary())
				
		"NEVER":
			if self.objective_settings.current > 0:
				defeat.emit(objectiveDataToDictionnary())
			else:
				if finalAnalysis:
					victory.emit(objectiveDataToDictionnary())
				
		"LESSER":
			if self.objective_settings.current > self.objective_settings.goal:
				defeat.emit(objectiveDataToDictionnary())
			else:
				if finalAnalysis:
					victory.emit(objectiveDataToDictionnary())
				
		"MORE":
			if finalAnalysis:
				if self.objective_settings.current >= self.objective_settings.goal:
					victory.emit(objectiveDataToDictionnary())
				else:
					defeat.emit(objectiveDataToDictionnary())

func objectiveDataToDictionnary():
	pass

func changeTimerState(value:bool):
	if self.get_child(0):
		self.get_child(0).set_paused(value)

func _analysis_required(data:Dictionary):
	analyze(false,data)

func _endGame():
	#print("Fin du timer/round")
	analyze(true)
