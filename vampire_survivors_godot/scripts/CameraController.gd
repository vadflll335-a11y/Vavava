extends Camera2D

@export var follow_speed := 5.0
@export var camera_offset := Vector2.ZERO

var target: Node2D
var screen_shake_intensity := 0.0
var screen_shake_duration := 0.0

func _ready():
	# Find player to follow
	target = get_node("/root/Main/Player")
	
	# Enable camera
	enabled = true
	
	# Set camera limits (optional)
	# limit_left = -2000
	# limit_right = 2000
	# limit_top = -2000
	# limit_bottom = 2000

func _process(delta):
	if not is_instance_valid(target):
		return
	
	# Follow target smoothly
	var target_position = target.global_position + camera_offset
	global_position = global_position.lerp(target_position, follow_speed * delta)
	
	# Handle screen shake
	if screen_shake_duration > 0:
		screen_shake_duration -= delta
		offset = Vector2(
			randf_range(-screen_shake_intensity, screen_shake_intensity),
			randf_range(-screen_shake_intensity, screen_shake_intensity)
		)
	else:
		offset = Vector2.ZERO

func add_screen_shake(intensity: float, duration: float):
	screen_shake_intensity = max(screen_shake_intensity, intensity)
	screen_shake_duration = max(screen_shake_duration, duration)

func set_follow_target(new_target: Node2D):
	target = new_target