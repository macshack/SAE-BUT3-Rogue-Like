extends Node

class_name Gear

var itemList: Array[Item] = []

func getList():
	return itemList

#Renvoie l'item a 'index dans l'inventaire
func unequipItem(index):
	#Ajouter la partie qui renvoie l'item dans l'inventaire
	
	#On cree un objet vide pour eviter que le tableau se reindex
	itemList[index] = Item.new()

#Equipe un item
func equipItem(item,index = 0):
	#Si il y a moins de 3 items equipes, on ajoutes l'item sans prendre en compte sa position
	if len(itemList) < 3:
		itemList.append(item)
	else:
		#Si tous les slots sont occupes, on desequipe l'item a l'index, puis 
		unequipItem(index)
		itemList[index] = item
