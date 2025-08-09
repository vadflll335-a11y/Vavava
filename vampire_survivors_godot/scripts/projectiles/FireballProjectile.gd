extends Projectile

@export var explosion_radius := 80.0
@export var explosion_scene: PackedScene

func setup(dir: Vector2, dmg: float, spd: float, radius: float = 80.0):
	super.setup(dir, dmg, spd)
	explosion_radius = radius

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		# Create explosion
		explode()

func explode():
	# Find all enemies within explosion radius
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	var circle_shape = CircleShape2D.new()
	circle_shape.radius = explosion_radius
	query.shape = circle_shape
	query.transform = global_transform
	query.collision_mask = 2  # Enemy layer
	
	var results = space_state.intersect_shape(query)
	
	# Damage all enemies in explosion
	for result in results:
		var enemy = result.collider
		if enemy.has_method("take_damage"):
			enemy.take_damage(damage)
	
	# Visual explosion effect (placeholder)
	create_explosion_effect()
	
	_destroy()

func create_explosion_effect():
	# Create explosion sprite/animation
	var explosion = Sprite2D.new()
	get_parent().add_child(explosion)
	explosion.global_position = global_position
	
	# Simple explosion effect - scale up and fade out
	explosion.modulate = Color.ORANGE
	var tween = create_tween()
	tween.parallel().tween_property(explosion, "scale", Vector2(3, 3), 0.3)
	tween.parallel().tween_property(explosion, "modulate:a", 0.0, 0.3)
	tween.tween_callback(explosion.queue_free)