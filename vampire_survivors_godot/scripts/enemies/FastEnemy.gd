extends "res://scripts/Enemy.gd"

func _ready():
	# Fast enemy stats
	speed = 80.0
	max_health = 15
	damage = 8
	experience_value = 2
	
	super._ready()
	
	# Different color
	if sprite:
		sprite.modulate = Color.MAGENTA