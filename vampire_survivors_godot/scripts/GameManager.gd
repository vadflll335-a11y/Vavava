extends Node

signal game_over
signal level_up

var score := 0
var game_time := 0.0
var is_game_over := false
var current_level := 1
var experience := 0
var experience_to_next_level := 10

@onready var player = $Player
@onready var enemy_spawner = $EnemySpawner
@onready var ui = $UI

var enemies: Array[Node] = []
var projectiles: Array[Node] = []

func _ready():
	# Connect signals
	connect("level_up", _on_level_up)
	
func _process(delta):
	if not is_game_over:
		game_time += delta
		ui.update_time(game_time)

func add_experience(amount: int):
	experience += amount
	ui.update_experience(experience, experience_to_next_level)
	
	if experience >= experience_to_next_level:
		level_up()

func level_up():
	current_level += 1
	experience -= experience_to_next_level
	experience_to_next_level = int(experience_to_next_level * 1.2)
	
	emit_signal("level_up")
	ui.show_level_up_menu()

func _on_level_up():
	print("Level up! New level: ", current_level)

func game_over():
	is_game_over = true
	get_tree().paused = true
	ui.show_game_over()
	emit_signal("game_over")

func restart_game():
	get_tree().paused = false
	get_tree().reload_current_scene()

func add_score(points: int):
	score += points
	ui.update_score(score)

func register_enemy(enemy: Node):
	enemies.append(enemy)

func unregister_enemy(enemy: Node):
	enemies.erase(enemy)

func register_projectile(projectile: Node):
	projectiles.append(projectile)

func unregister_projectile(projectile: Node):
	projectiles.erase(projectile)

func get_nearest_enemy(position: Vector2) -> Node:
	var nearest_enemy = null
	var nearest_distance = INF
	
	for enemy in enemies:
		if not is_instance_valid(enemy):
			continue
			
		var distance = position.distance_to(enemy.global_position)
		if distance < nearest_distance:
			nearest_distance = distance
			nearest_enemy = enemy
	
	return nearest_enemy