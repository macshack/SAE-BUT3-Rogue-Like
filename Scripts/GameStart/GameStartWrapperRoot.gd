extends Node

signal mainMenu()
signal startGame(objData,crewData)

var objNode
var crewNode
var objData
var crewData
# Called when the node enters the scene tree for the first time.
func _ready():
	objNode = $Objective
	crewNode = $Crew
	objNode.show()
	crewNode.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_objective_objchosen(obj):
	objData = obj
	objNode.hide()
	crewNode.show()


func _on_objective_backtomenu():
	mainMenu.emit()
	self.queue_free()


func _on_crew_final_next(crew):
	crewData = crew
	startGame.emit(objData,crewData)


func _on_crew_back():
	objNode.show()
	crewNode.hide()
