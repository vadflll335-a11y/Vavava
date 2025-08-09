extends Weapon

@export var chain_count := 3
@export var chain_range := 200.0

var lightning_effect_scene: PackedScene

func _ready():
	super._ready()
	
	# Lightning stats
	damage = 30.0
	fire_rate = 0.8
	range = 350.0

func fire(target: Node):
	super.fire(target)
	
	# Create lightning chain
	var current_target = target
	var hit_enemies = []
	
	for i in chain_count:
		if not current_target or not is_instance_valid(current_target):
			break
		
		# Deal damage to current target
		if current_target.has_method("take_damage"):
			current_target.take_damage(damage)
		
		hit_enemies.append(current_target)
		
		# Create lightning visual effect
		create_lightning_effect(global_position if i == 0 else hit_enemies[i-1].global_position, current_target.global_position)
		
		# Find next target
		current_target = find_next_chain_target(current_target, hit_enemies)

func find_next_chain_target(from_enemy: Node, exclude_enemies: Array) -> Node:
	var nearest_enemy = null
	var nearest_distance = chain_range
	
	for enemy in game_manager.enemies:
		if not is_instance_valid(enemy) or enemy in exclude_enemies:
			continue
		
		var distance = from_enemy.global_position.distance_to(enemy.global_position)
		if distance <= chain_range and distance < nearest_distance:
			nearest_distance = distance
			nearest_enemy = enemy
	
	return nearest_enemy

func create_lightning_effect(from_pos: Vector2, to_pos: Vector2):
	var lightning_line = Line2D.new()
	get_tree().current_scene.add_child(lightning_line)
	
	lightning_line.add_point(from_pos)
	lightning_line.add_point(to_pos)
	lightning_line.width = 3.0
	lightning_line.default_color = Color.CYAN
	
	# Animate and destroy lightning effect
	var tween = create_tween()
	tween.tween_property(lightning_line, "modulate:a", 0.0, 0.3)
	tween.tween_callback(lightning_line.queue_free)

func level_up():
	super.level_up()
	
	match level:
		2:
			chain_count += 1
			print("Lightning Level 2: +1 chain")
		3:
			increase_damage(0.5)
			print("Lightning Level 3: +50% damage")
		4:
			chain_range *= 1.3
			print("Lightning Level 4: +30% chain range")
		5:
			print("Lightning Level 5: Evolution - Storm")