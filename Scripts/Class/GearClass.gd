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
	if (item is Item):
		var clampedIndex = clamp(index,0,2)
		itemList[clampedIndex] = item
	elif (item is int):
		var newItem = Item.new(item,"","","",{},0,true)
		var clampedIndex = clamp(index,0,2)
		itemList[clampedIndex] = newItem

func getItemIds():
	var list = []
	for i in self.itemList:
		if self.itemList[i] is Item:
			list.append(self.itemList[i].getItemId())
	return list
