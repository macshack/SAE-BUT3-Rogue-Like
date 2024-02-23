extends Area2D
class_name MonsterMelee

var pMonsterMeleeEffect := preload("res://MiniGame/MonsterMelee/monster_melee_effect.tscn")

@export var minSpeed: float = 50
@export var maxSpeed: float = 80

@export var life: int = 10

var speed: float = 0
var playerInArea: MgPlayer = null

func _ready():
	speed = randf_range(minSpeed, maxSpeed)

func _process(delta):
	if playerInArea != null:
		playerInArea.damage(1)

func _physics_process(delta):
	position.y += speed * delta

func damage(ammount: int):
	life -= ammount
	if life <= 0:
		var effect := pMonsterMeleeEffect.instantiate()
		effect.position = position
		get_parent().add_child(effect)
		
		Signals.emit_signal("on_score_increment", 2)
		
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_area_entered(area):
	if area is MgPlayer:
		playerInArea = area
		
func _on_area_exited(area):
	if area is MgPlayer:
		playerInArea = null

