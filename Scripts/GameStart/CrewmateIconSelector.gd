extends HBoxContainer

var texture
var portraitsFolder = "res://Assets/Portraits/"
var portraitArray = []
var currentIndex = 0
var currentTexture
var regex = RegEx.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	regex.compile("(\\.import)+")
	var regex2 = RegEx.new()
	regex2.compile("(Human)")
	texture = $IconRect
	var dir = DirAccess.open(portraitsFolder)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir() && regex.search_all(file_name).size() == 0:
				if regex2.search_all(file_name).size()>=1:
					portraitArray.append(file_name)
			file_name = dir.get_next()
	texture.texture = load(portraitsFolder+portraitArray[currentIndex])
	currentTexture = portraitArray[currentIndex]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func loadFromString(link):
	for i in portraitArray:
		if i == link:
			var index = portraitArray.find(i)
			currentIndex = index
			texture.texture = load(portraitsFolder+portraitArray[currentIndex])
			currentTexture = portraitArray[currentIndex]

func _on_previous_pressed():
	if currentIndex-1 >= 0:
		currentIndex -= 1
	else:
		currentIndex = portraitArray.size()-1
	texture.texture = load(portraitsFolder+portraitArray[currentIndex])
	currentTexture = portraitArray[currentIndex]


func _on_next_pressed():
	if currentIndex+1 < portraitArray.size():
		currentIndex += 1
	else:
		currentIndex = 0
	texture.texture = load(portraitsFolder+portraitArray[currentIndex])
	currentTexture = portraitArray[currentIndex]
	
