extends CharacterBody2D

signal health_changed(new_health, max_health)
signal died

@export var speed := 300.0
@export var max_health := 100
var current_health: int

@onready var sprite = $Sprite2D
@onready var collision_shape = $CollisionShape2D
@onready var hurt_box = $HurtBox

var weapons: Array[Node] = []
var game_manager: Node

func _ready():
	current_health = max_health
	game_manager = get_node("/root/Main")
	
	# Connect signals
	if hurt_box:
		hurt_box.connect("area_entered", _on_hurt_box_area_entered)
	
	# Add default weapon
	add_weapon("BasicGun")
	
	emit_signal("health_changed", current_health, max_health)

func _physics_process(delta):
	handle_movement(delta)

func handle_movement(delta):
	var input_vector = Vector2.ZERO
	
	if Input.is_action_pressed("move_up"):
		input_vector.y -= 1
	if Input.is_action_pressed("move_down"):
		input_vector.y += 1
	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("move_right"):
		input_vector.x += 1
	
	input_vector = input_vector.normalized()
	velocity = input_vector * speed
	
	move_and_slide()
	
	# Flip sprite based on movement direction
	if input_vector.x != 0:
		sprite.flip_h = input_vector.x < 0

func add_weapon(weapon_name: String):
	var weapon_scene = load("res://scenes/weapons/" + weapon_name + ".tscn")
	if weapon_scene:
		var weapon_instance = weapon_scene.instantiate()
		add_child(weapon_instance)
		weapons.append(weapon_instance)
		weapon_instance.setup(self)

func take_damage(amount: int):
	current_health -= amount
	current_health = max(0, current_health)
	emit_signal("health_changed", current_health, max_health)
	
	# Visual feedback
	modulate = Color.RED
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.2)
	
	if current_health <= 0:
		die()

func heal(amount: int):
	current_health = min(max_health, current_health + amount)
	emit_signal("health_changed", current_health, max_health)

func die():
	emit_signal("died")
	game_manager.game_over()

func _on_hurt_box_area_entered(area):
	if area.is_in_group("enemy_damage"):
		var damage = area.get("damage")
		if damage:
			take_damage(damage)

func get_level_up_options() -> Array:
	var options = []
	
	# Weapon upgrades
	options.append({
		"name": "Увеличить урон",
		"description": "+10% урона ко всему оружию",
		"type": "damage_increase"
	})
	
	options.append({
		"name": "Увеличить скорость",
		"description": "+20% скорости передвижения",
		"type": "speed_increase"
	})
	
	options.append({
		"name": "Восстановить здоровье",
		"description": "Восстанавливает 30 HP",
		"type": "heal"
	})
	
	# Add new weapon if player has less than 6 weapons
	if weapons.size() < 6:
		options.append({
			"name": "Новое оружие",
			"description": "Добавляет новое оружие",
			"type": "new_weapon"
		})
	
	return options

func apply_level_up_choice(choice: Dictionary):
	match choice.type:
		"damage_increase":
			for weapon in weapons:
				if weapon.has_method("increase_damage"):
					weapon.increase_damage(0.1)
		"speed_increase":
			speed *= 1.2
		"heal":
			heal(30)
		"new_weapon":
			# Add random weapon
			var weapon_types = ["BasicGun", "Fireball", "Lightning"]
			var random_weapon = weapon_types[randi() % weapon_types.size()]
			add_weapon(random_weapon)