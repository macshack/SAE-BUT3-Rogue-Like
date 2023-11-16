extends Node

@onready var destinationsList = []

func addDestinationIdToList(Destination):
	destinationsList.append(Destination)
	print("Destination appended succesfully!")
