extends Node2D

class_name Item

var itemId:int
var itemName:String
var itemFlavorText:String
var itemIconLink:String
var itemModifiers = {
	"ATK":0,
	"HP":0,
	"SPD":0,
	"DDG":0,
	"CRT":0,
}
var itemPrice:int

func _init(id:int,itemName = "",flavor = "",icon = "",stats = {},price=0,load=false):
	if load:
		self.itemId = id
		self.itemName = JsonHandling.item_data[str(id)].itemName
		self.itemFlavorText = JsonHandling.item_data[str(id)].itemFlavorText
		self.itemIconLink = JsonHandling.item_data[str(id)].itemIconLink
		self.itemPrice = JsonHandling.item_data[str(id)].itemPrice
		for key in JsonHandling.item_data[str(id)].itemModifiers:
			self.itemModifiers[key] = JsonHandling.item_data[str(id)].itemModifiers[key]
	else:
		self.itemId = id
		self.itemName = itemName
		self.itemFlavorText = flavor
		self.itemIconLink = icon
		self.itemPrice = price
		for key in stats:
			self.itemModifiers[key] = stats[key]

func getName():
	return itemName

func getFlavorText():
	return itemFlavorText
	
func getModifiers():
	return itemModifiers

func getIconLink():
	return itemIconLink

func getPrice():
	return itemPrice
	
func getItemId():
	return itemId

func toDictionary()->Dictionary:
	var dict = {
		"itemId":self.itemId,
	}
	return dict
