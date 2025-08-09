extends Area2D

@export var experience_value := 1
@export var move_speed := 200.0
@export var pickup_range := 100.0

var player: Node
var is_moving_to_player := false

@onready var sprite = $Sprite2D
@onready var collision_shape = $CollisionShape2D

func _ready():
	player = get_node("/root/Main/Player")
	
	# Add to pickup group
	add_to_group("pickups")
	
	# Connect signals
	body_entered.connect(_on_body_entered)
	
	# Auto-move to player after short delay
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.5
	timer.one_shot = true
	timer.timeout.connect(_start_moving_to_player)
	timer.start()

func _physics_process(delta):
	if not is_instance_valid(player):
		return
	
	var distance_to_player = global_position.distance_to(player.global_position)
	
	# Start moving if player is close or auto-move is triggered
	if distance_to_player <= pickup_range or is_moving_to_player:
		move_towards_player(delta)

func move_towards_player(delta):
	var direction = (player.global_position - global_position).normalized()
	global_position += direction * move_speed * delta

func _start_moving_to_player():
	is_moving_to_player = true

func _on_body_entered(body):
	if body == player:
		# Give experience to game manager
		var game_manager = get_node("/root/Main")
		if game_manager:
			game_manager.add_experience(experience_value)
		
		# Visual pickup effect
		create_pickup_effect()
		
		queue_free()

func create_pickup_effect():
	# Simple pickup effect
	var effect = sprite.duplicate()
	get_parent().add_child(effect)
	effect.global_position = global_position
	
	var tween = create_tween()
	tween.parallel().tween_property(effect, "scale", Vector2(2, 2), 0.2)
	tween.parallel().tween_property(effect, "modulate:a", 0.0, 0.2)
	tween.tween_callback(effect.queue_free)