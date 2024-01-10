extends Node

class_name Gear

#var itemList: Array[Item] = []
var itemList:Dictionary = {0:null,1:null,2:null}

func getList():
	return itemList

func removeItem(index:int):
	var clampedIndex = clamp(index,0,2)
	itemList[clampedIndex] = null

#Equipe un item
func equipItem(item,index = 0):
	#Si il y a moins de 3 items equipes, on ajoutes l'item sans prendre en compte sa position
	var clampedIndex = clamp(index,0,2)
	itemList[clampedIndex] = item

func getItemIds():
	var list = []
	for i in itemList:
		list.append(itemList[i].itemId)
	return list
