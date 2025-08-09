extends Weapon

@export var projectile_scene: PackedScene

func _ready():
	super._ready()
	
	# Load projectile scene
	if not projectile_scene:
		projectile_scene = preload("res://scenes/projectiles/Bullet.tscn")

func fire(target: Node):
	super.fire(target)
	
	if not projectile_scene:
		return
	
	# Create bullet
	var bullet = projectile_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	
	# Set bullet properties
	bullet.global_position = global_position
	var direction = (target.global_position - global_position).normalized()
	bullet.setup(direction, damage, projectile_speed)

func level_up():
	super.level_up()
	
	match level:
		2:
			increase_damage(0.5)
			print("BasicGun Level 2: +50% damage")
		3:
			increase_fire_rate(0.3)
			print("BasicGun Level 3: +30% fire rate")
		4:
			increase_range(0.4)
			print("BasicGun Level 4: +40% range")
		5:
			# Evolution - shoots 3 bullets in a spread
			print("BasicGun Level 5: Evolution - Triple Shot")