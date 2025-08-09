extends Weapon

@export var projectile_scene: PackedScene
@export var explosion_radius := 100.0

func _ready():
	super._ready()
	
	# Fireball stats
	damage = 25.0
	fire_rate = 0.5
	range = 300.0
	projectile_speed = 200.0
	
	# Load projectile scene
	if not projectile_scene:
		projectile_scene = preload("res://scenes/projectiles/FireballProjectile.tscn")

func fire(target: Node):
	super.fire(target)
	
	if not projectile_scene:
		return
	
	# Create fireball
	var fireball = projectile_scene.instantiate()
	get_tree().current_scene.add_child(fireball)
	
	# Set fireball properties
	fireball.global_position = global_position
	var direction = (target.global_position - global_position).normalized()
	fireball.setup(direction, damage, projectile_speed, explosion_radius)

func level_up():
	super.level_up()
	
	match level:
		2:
			increase_damage(0.6)
			print("Fireball Level 2: +60% damage")
		3:
			explosion_radius *= 1.3
			print("Fireball Level 3: +30% explosion radius")
		4:
			increase_fire_rate(0.4)
			print("Fireball Level 4: +40% fire rate")
		5:
			print("Fireball Level 5: Evolution - Inferno")