extends CharacterBody2D

signal died(enemy)

@export var speed := 50.0
@export var max_health := 20
@export var damage := 10
@export var experience_value := 1

var current_health: int
var player: Node
var game_manager: Node

@onready var sprite = $Sprite2D
@onready var collision_shape = $CollisionShape2D
@onready var damage_area = $DamageArea
@onready var health_bar = $HealthBar

func _ready():
	current_health = max_health
	player = get_node("/root/Main/Player")
	game_manager = get_node("/root/Main")
	
	game_manager.register_enemy(self)
	
	# Setup damage area
	if damage_area:
		damage_area.add_to_group("enemy_damage")
		damage_area.damage = damage
	
	# Connect signals
	connect("died", _on_died)
	
	update_health_bar()

func _physics_process(delta):
	if not is_instance_valid(player):
		return
		
	# Move towards player
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed
	
	move_and_slide()
	
	# Flip sprite based on movement direction
	if direction.x != 0:
		sprite.flip_h = direction.x < 0

func take_damage(amount: int):
	current_health -= amount
	current_health = max(0, current_health)
	
	# Visual feedback
	modulate = Color.RED
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.1)
	
	update_health_bar()
	
	if current_health <= 0:
		die()

func die():
	# Spawn experience orb
	spawn_experience()
	
	# Add score
	game_manager.add_score(10)
	
	emit_signal("died", self)
	queue_free()

func spawn_experience():
	var experience_scene = preload("res://scenes/ExperienceOrb.tscn")
	var experience_orb = experience_scene.instantiate()
	get_parent().add_child(experience_orb)
	experience_orb.global_position = global_position
	experience_orb.experience_value = experience_value

func update_health_bar():
	if health_bar:
		var health_percentage = float(current_health) / float(max_health)
		health_bar.scale.x = health_percentage

func _on_died(enemy):
	game_manager.unregister_enemy(enemy)

func _exit_tree():
	if game_manager and has_method("unregister_enemy"):
		game_manager.unregister_enemy(self)