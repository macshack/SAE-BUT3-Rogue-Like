extends Node

@onready var charactersList = []

func addCharacterIdToList(id):
	if not id in charactersList:
		charactersList.append(id)
		print(charactersList)
