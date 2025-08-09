extends Area2D

class_name Projectile

@export var speed := 300.0
@export var damage := 10.0
@export var lifetime := 5.0

var direction: Vector2
var traveled_distance := 0.0
var max_distance := 1000.0

@onready var sprite = $Sprite2D
@onready var collision_shape = $CollisionShape2D

func _ready():
	# Add to projectiles group
	add_to_group("projectiles")
	
	# Connect area entered signal
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)
	
	# Auto-destroy after lifetime
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = lifetime
	timer.one_shot = true
	timer.timeout.connect(_destroy)
	timer.start()
	
	# Register with game manager
	var game_manager = get_node("/root/Main")
	if game_manager:
		game_manager.register_projectile(self)

func setup(dir: Vector2, dmg: float, spd: float):
	direction = dir.normalized()
	damage = dmg
	speed = spd
	
	# Rotate sprite to face direction
	rotation = direction.angle()

func _physics_process(delta):
	var movement = direction * speed * delta
	position += movement
	traveled_distance += movement.length()
	
	# Destroy if traveled too far
	if traveled_distance >= max_distance:
		_destroy()

func _on_area_entered(area):
	# Handle collision with other areas (e.g., enemies)
	pass

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		# Deal damage to enemy
		if body.has_method("take_damage"):
			body.take_damage(damage)
		_destroy()

func _destroy():
	# Unregister from game manager
	var game_manager = get_node("/root/Main")
	if game_manager:
		game_manager.unregister_projectile(self)
	
	queue_free()

func _exit_tree():
	# Failsafe unregister
	var game_manager = get_node("/root/Main")
	if game_manager and has_method("unregister_projectile"):
		game_manager.unregister_projectile(self)