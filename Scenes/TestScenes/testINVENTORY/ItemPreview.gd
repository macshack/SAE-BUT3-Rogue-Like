extends PanelContainer

var item:Item

@onready var itemName = %ItemName
@onready var itemFlavor = %ItemFlavor
@onready var itemIcon = %ItemIcon
@onready var itemPrice = %ItemPrice
@onready var itemStats = %ItemStats

func _set_item(value:Item):
	for stats in itemStats.get_children():
		stats.queue_free()
	item = value
	itemName.text = item.itemName
	itemFlavor.text = item.itemFlavorText
	itemIcon.texture = ResourceLoader.load("res://Assets/Items/"+item.itemIconLink)
	itemPrice.text = str(item.itemPrice)+"C"
	for stat in item.itemModifiers:
		if item.itemModifiers[stat] != 0:
			match(stat):
				"ATK":
					var statValue = item.itemModifiers[stat]
					var label = Label.new()
					var labSettings = LabelSettings.new()
					labSettings.font_size = 24
					if statValue > 0:
						label.text = "+"+str(statValue)+" Attaque"
						labSettings.font_color = Color(0,255,0)
					else:
						label.text = str(statValue)+" Attaque"
						labSettings.font_color = Color(255,0,0)
					label.label_settings = labSettings
					itemStats.add_child(label)
				"HP":
					var statValue = item.itemModifiers[stat]
					var label = Label.new()
					var labSettings = LabelSettings.new()
					labSettings.font_size = 24
					if statValue > 0:
						label.text = "+"+str(statValue)+" Points de vie"
						labSettings.font_color = Color(0,255,0)
					else:
						label.text = str(statValue)+" Points de vie"
						labSettings.font_color = Color(255,0,0)
					label.label_settings = labSettings
					itemStats.add_child(label)
				"SPD":
					var statValue = item.itemModifiers[stat]
					var label = Label.new()
					var labSettings = LabelSettings.new()
					labSettings.font_size = 24
					if statValue > 0:
						label.text = "+"+str(statValue)+" Vitesse"
						labSettings.font_color = Color(0,255,0)
					else:
						label.text = str(statValue)+" Vitesse"
						labSettings.font_color = Color(255,0,0)
					label.label_settings = labSettings
					itemStats.add_child(label)
				"DDG":
					var statValue = item.itemModifiers[stat]
					var label = Label.new()
					var labSettings = LabelSettings.new()
					labSettings.font_size = 24
					if statValue > 0:
						label.text = "+"+str(statValue)+"% Chance d'esquiver"
						labSettings.font_color = Color(0,255,0)
					else:
						label.text = str(statValue)+"% Chance d'esquiver"
						labSettings.font_color = Color(255,0,0)
					label.label_settings = labSettings
					itemStats.add_child(label)
				"CRT":
					var statValue = item.itemModifiers[stat]
					var label = Label.new()
					var labSettings = LabelSettings.new()
					labSettings.font_size = 24
					if statValue > 0:
						label.text = "+"+str(statValue)+"% Chance de coup critique"
						labSettings.font_color = Color(0,255,0)
					else:
						label.text = str(statValue)+"% Chance de coup critique"
						labSettings.font_color = Color(255,0,0)
					label.label_settings = labSettings
					itemStats.add_child(label)
	self.show()
