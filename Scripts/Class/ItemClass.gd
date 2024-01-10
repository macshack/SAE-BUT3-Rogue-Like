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

func _init(id:int,itemName = "",flavor = "",icon = "",stats = {},price=0):
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
