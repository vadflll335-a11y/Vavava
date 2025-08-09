extends Node2D

class_name Weapon

signal weapon_fired

@export var damage := 10.0
@export var fire_rate := 1.0
@export var range := 400.0
@export var projectile_speed := 500.0

var fire_timer: Timer
var player: CharacterBody2D
var game_manager: Node
var level := 1

@onready var weapon_sprite = $WeaponSprite

func _ready():
	# Setup fire timer
	fire_timer = Timer.new()
	add_child(fire_timer)
	fire_timer.wait_time = 1.0 / fire_rate
	fire_timer.timeout.connect(_try_fire)
	fire_timer.start()

func setup(player_node: CharacterBody2D):
	player = player_node
	game_manager = get_node("/root/Main")

func _try_fire():
	var target = game_manager.get_nearest_enemy(global_position)
	if target and global_position.distance_to(target.global_position) <= range:
		fire(target)

func fire(target: Node):
	emit_signal("weapon_fired")
	# Override in child classes

func increase_damage(percentage: float):
	damage *= (1.0 + percentage)

func increase_fire_rate(percentage: float):
	fire_rate *= (1.0 + percentage)
	fire_timer.wait_time = 1.0 / fire_rate

func increase_range(percentage: float):
	range *= (1.0 + percentage)

func level_up():
	level += 1
	# Override in child classes for specific upgrades