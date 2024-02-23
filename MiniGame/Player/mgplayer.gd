extends Area2D
class_name MgPlayer

var plBullet := preload("res://MiniGame/Bullet/bullets.tscn")

@onready var animatedSprite := %AnimatedSprite2D
@onready var firingPosition:= %FiringPositions
@onready var fireDelayTimer := %FireDelayTimer
@onready var invicibilityTimer := %InvicibilityTimer
@onready var shieldSprite := %Shield

@export var speed: float = 500
@export var fireDelay: float = 0.1
@export var life: int = 3
@export var damageInvicibilityTime := 2.0
var vel:= Vector2(0, 0)

func _ready():
	shieldSprite.visible = false
	Signals.emit_signal("on_player_life_changed", life)

func _process(delta):
	if vel.x < 0:
		animatedSprite.play("Run")
	elif vel.x > 0:
		animatedSprite.play("Run")
	elif vel.y < 0:
		animatedSprite.play("Run")
	elif vel.y > 0:
		animatedSprite.play("Run")
	else:
		animatedSprite.play("Default")
		
	if Input.is_action_pressed("shoot") and fireDelayTimer.is_stopped():
		fireDelayTimer.start(fireDelay)
		for child in firingPosition.get_children():
			var bullet:= plBullet.instantiate()
			bullet.global_position = child.global_position
			get_tree().current_scene.add_child(bullet)

func _physics_process(delta):
	var dirVec:= Vector2(0, 0)
	if Input.is_action_pressed("move_left"):
		dirVec.x = -1
	elif Input.is_action_pressed("move_right"):
		dirVec.x = 1
	if Input.is_action_pressed("move_up"):
		dirVec.y = -1
	elif Input.is_action_pressed("move_down"):
		dirVec.y = 1
	
	vel = dirVec.normalized() * speed
	
	position += vel * delta
	
	var viewRect := get_viewport_rect()
	position.x = clamp(position.x, 0, viewRect.size.x)
	position.y = clamp(position.y, 0, viewRect.size.y)

func damage(ammount: int):
	if !invicibilityTimer.is_stopped():
		return
		
	invicibilityTimer.start(damageInvicibilityTime)
	shieldSprite.visible = true
	
	life -= ammount
	Signals.emit_signal("on_player_life_changed", life)
	
	if life <= 0:
		queue_free()
		Signals.emit_signal("on_game_over", _on_game_over())

func _on_game_over():
	print("GAME OVER")
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_invicibility_timer_timeout():
	shieldSprite.visible = false
