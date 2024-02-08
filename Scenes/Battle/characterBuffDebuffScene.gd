extends TextureRect

@export var type:String
@onready var durationNode = %Duration
@onready var iconNode = %Duration
var tooltipText = ""
var tooltipValues = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func init():
	pass

func update(effectArray:Array=[],type:String=""):
	if effectArray[0]:
		match(type):
			"burn":
				durationNode.text = str(effectArray[1])
				tooltipValues = [effectArray[2],effectArray[1]]
			"stun":
				durationNode.text = str(effectArray[1])
				tooltipValues = [effectArray[1]]
			"weakpoint":
				durationNode.text = str(effectArray[1])
				tooltipValues = [effectArray[1]]
			"buff":
				durationNode.text = str(effectArray[1])
				tooltipValues = [effectArray[2],effectArray[1]]
			"debuff":
				durationNode.text = str(effectArray[1])
				tooltipValues = [effectArray[2],effectArray[1]]
		self.show()
	else:
		self.hide()
