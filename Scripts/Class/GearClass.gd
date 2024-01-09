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
	"""var clampedIndex = clamp(index,0,3)
	if clampedIndex >= len(itemList):
		print(item.itemName+" added.")
		itemList.append(item)
	else:
		print(itemList[clampedIndex].itemName+" swapped with "+item.itemName)
		itemList[clampedIndex] = item
	if len(itemList) < 3:
		itemList.append(item)
	else:
		var oldItem = itemList[index]
		itemList[index] = item
		return oldItem"""
