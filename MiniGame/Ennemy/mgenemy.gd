extends Area2D
class_name MgEnemy

var plBullet := preload("res://MiniGame/Bullet/EnemyBullets.tscn")

@onready var firingPosition := %FiringPosition

@export var verticalSpeed := 10.0
@export var health: int = 5

var playerInArea: MgPlayer = null

func _process(delta):
	if playerInArea != null:
		playerInArea.damage(1)

func _physics_process(delta):
	position.y += verticalSpeed * delta

func fire():
	for child in firingPosition.get_children():
			var bullet:= plBullet.instantiate()
			bullet.global_position = child.global_position
			get_tree().current_scene.add_child(bullet)

func damage(amount: int):
	health -= amount
	if health <= 0:
		Signals.emit_signal("on_score_increment", 1)
		
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_area_entered(area):
	if area is MgPlayer:
		playerInArea = area
