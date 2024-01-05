extends Node

enum objFamilies {ACCUMULATION=0,NEVER=1,LESSER=2,MORE=3}
enum objTypes {CREDITS=0,DEAD_CREWMATE=1,DAMAGE_DEALT=2,GEAR=3,ENEMIES_KILLED=5,FIGHTS_WON=6,EXPLORATION_DONE=7,BOSS_KILLED=8}

signal victory(objectiveResult:Dictionary)
signal defeat(objectiveResult:Dictionary)

#Contains the raw data of the objective, must be processed by the init function
var objData
#Big cool title
var objTitle:String
#Detailed and flavorful description of the objective
var objDescription:String
#Objective text for the UI
var objText:String
#Family of the objective either : accumulation, never-happens, lesser-than, more-than, etc
var objFamily:objFamilies
#The type of the objective : credits, damage dealt, amount of gear obtained, etc
var objType:objTypes
#Amount to reach to win the game
var objGoal
#Current amount
var objValue
#If the objective has a constraint or not
var objConstraint:bool = false
#Time constraint measured in seconds
var objTimeConstraint:int = -1
#Round constraint measured in a number of rounds
var objRoundConstraint:int = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	if objConstraint:
		if objTimeConstraint > 0:
			var timer = Timer.new()
			timer.one_shot=true
			timer.autostart = true
			timer.wait_time = objTimeConstraint
			timer.timeout.connect(_endGame)
			self.add_child(timer)
		elif objRoundConstraint > 0:
			Game.roundConstraint = objRoundConstraint+1
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Game.roundConstraint < 0:
		_endGame()

func init(data):
	objTitle = data["title"]
	objDescription = data["description"]
	objFamily = objFamilies[data["family"]]
	objType = objTypes[data["type"]]
	objText = data["text"]
	objGoal = data["goal"]
	objConstraint = data["constraint"]
	if objConstraint:
		if data["constraintType"] == "time":
			objTimeConstraint = data["constraintValue"]
		elif data["constraintType"] == "round":
			objRoundConstraint = data["constraintValue"]
		else:
			objConstraint = false
	return self
	
func analyze(finalAnalysis:bool = false,situationResult:Dictionary = {}):
	match(objType):
		objTypes.CREDITS:
			self.objValue = Game.credits
		objTypes.DAMAGE_DEALT:
			if situationResult.has("total_damage_dealt"):
				self.objValue += situationResult["total_damage_dealt"]
		objTypes.GEAR:
			#The amount of gear dropped through exploration/fights
			if situationResult.has("item_drops"):
				self.objValue += situationResult["item_drops"].size()
		objTypes.ENEMIES_KILLED:
			if situationResult.has("enemies_killed"):
				self.objValue += situationResult["enemies_killed"]
		objTypes.FIGHTS_WON:
			if situationResult.has("fight_result"):
				if situationResult["fight_result"]:
					self.objValue += 1
		objTypes.EXPLORATION_DONE:
			if situationResult.has("exploration_result"):
				if situationResult["exploration_result"]:
					self.objValue += 1
		objTypes.BOSS_KILLED:
			if situationResult.has("boss_fight"):
				if situationResult["boss_fight"]:
					self.objValue += 1
	match(objFamily):
		objFamilies.ACCUMULATION:
			if self.objValue >= self.objGoal:
				victory.emit(objectiveDataToDictionnary())
				
		objFamilies.NEVER:
			if self.objValue > 0:
				defeat.emit(objectiveDataToDictionnary())
			else:
				if finalAnalysis:
					victory.emit(objectiveDataToDictionnary())
				
		objFamilies.LESSER:
			if self.objValue > self.objGoal:
				defeat.emit(objectiveDataToDictionnary())
			else:
				if finalAnalysis:
					victory.emit(objectiveDataToDictionnary())
				
		objFamilies.MORE:
			if finalAnalysis:
				if self.objValue >= self.objGoal:
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
	print("Fin du timer/round")
	analyze(true)
