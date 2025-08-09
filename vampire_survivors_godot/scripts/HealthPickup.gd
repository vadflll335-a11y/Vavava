extends Area2D

@export var heal_amount := 20
var player: Node

@onready var sprite = $Sprite2D
@onready var collision_shape = $CollisionShape2D

func _ready():
	player = get_node("/root/Main/Player")
	
	# Add to pickup group
	add_to_group("pickups")
	
	# Connect signals
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body == player:
		# Heal player
		if player.has_method("heal"):
			player.heal(heal_amount)
		
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