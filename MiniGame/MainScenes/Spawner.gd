extends Node2D

const MIN_SPAWN_TIME = 1.5

var plEnemies := [
	preload("res://MiniGame/Ennemy/Shooter_enemy.tscn"),
	preload("res://MiniGame/Ennemy/bouncer_enemy.tscn")
]
var plMonsterMelee := preload("res://MiniGame/MonsterMelee/monster_melee.tscn")

@onready var spawnTimer := %SpawnTimer

var nextSpawnTime := 5.0

func _ready():
	randomize()
	spawnTimer.start(nextSpawnTime)

func _on_spawn_timer_timeout():
	var viewRect := get_viewport_rect()
	var xPos := randf_range(viewRect.position.x, viewRect.end.x)
	if randf() < 0.4:
		var monsterMelee: MonsterMelee = plMonsterMelee.instantiate()
		monsterMelee.position = Vector2(xPos, position.y)
		get_tree().current_scene.add_child(monsterMelee)
	else:
		var enemyPreload = plEnemies[randi() % plEnemies.size()]
		var enemy: MgEnemy = enemyPreload.instantiate()
		enemy.position = Vector2(xPos, position.y)
		get_tree().current_scene.add_child(enemy)
	
	nextSpawnTime -= 0.1
	if nextSpawnTime < MIN_SPAWN_TIME:
		nextSpawnTime = MIN_SPAWN_TIME
	spawnTimer.start(nextSpawnTime)
