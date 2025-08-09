extends Node2D

@export var enemy_scenes: Array[PackedScene] = []
@export var spawn_distance := 1000.0
@export var initial_spawn_rate := 2.0

var spawn_timer: Timer
var current_spawn_rate: float
var player: Node
var game_manager: Node

func _ready():
	player = get_node("/root/Main/Player")
	game_manager = get_node("/root/Main")
	
	# Setup spawn timer
	spawn_timer = Timer.new()
	add_child(spawn_timer)
	spawn_timer.wait_time = 1.0 / initial_spawn_rate
	spawn_timer.timeout.connect(_spawn_enemy)
	spawn_timer.start()
	
	current_spawn_rate = initial_spawn_rate
	
	# Load enemy scenes if not set
	if enemy_scenes.is_empty():
		var basic_enemy = load("res://scenes/enemies/BasicEnemy.tscn")
		var fast_enemy = load("res://scenes/enemies/FastEnemy.tscn")
		if basic_enemy:
			enemy_scenes.append(basic_enemy)
		if fast_enemy:
			enemy_scenes.append(fast_enemy)

func _process(delta):
	# Increase spawn rate over time
	var time_factor = 1.0 + (game_manager.game_time / 30.0) * 0.5
	var new_spawn_rate = initial_spawn_rate * time_factor
	
	if new_spawn_rate != current_spawn_rate:
		current_spawn_rate = new_spawn_rate
		spawn_timer.wait_time = 1.0 / current_spawn_rate

func _spawn_enemy():
	if not is_instance_valid(player) or enemy_scenes.is_empty():
		return
	
	# Choose random enemy type
	var enemy_scene = enemy_scenes[randi() % enemy_scenes.size()]
	var enemy = enemy_scene.instantiate()
	
	# Spawn at random position around player
	var spawn_position = get_random_spawn_position()
	enemy.global_position = spawn_position
	
	get_parent().add_child(enemy)

func get_random_spawn_position() -> Vector2:
	var angle = randf() * 2 * PI
	var distance = spawn_distance + randf_range(-100, 100)
	
	var spawn_pos = player.global_position + Vector2(
		cos(angle) * distance,
		sin(angle) * distance
	)
	
	return spawn_pos

func increase_difficulty():
	current_spawn_rate *= 1.2
	spawn_timer.wait_time = 1.0 / current_spawn_rate

func get_enemy_count() -> int:
	var count = 0
	for child in get_parent().get_children():
		if child.is_in_group("enemies"):
			count += 1
	return count