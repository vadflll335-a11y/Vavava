extends CanvasLayer

@onready var health_bar = $HealthBar
@onready var experience_bar = $ExperienceBar
@onready var time_label = $TimeLabel
@onready var score_label = $ScoreLabel
@onready var level_label = $LevelLabel

@onready var level_up_panel = $LevelUpPanel
@onready var level_up_options = $LevelUpPanel/VBoxContainer
@onready var game_over_panel = $GameOverPanel

var game_manager: Node
var player: Node

func _ready():
	game_manager = get_node("/root/Main")
	player = get_node("/root/Main/Player")
	
	# Connect player signals
	if player:
		player.health_changed.connect(_on_player_health_changed)
	
	# Connect game manager signals
	if game_manager:
		game_manager.level_up.connect(_on_level_up)
		game_manager.game_over.connect(_on_game_over)
	
	# Hide panels initially
	level_up_panel.visible = false
	game_over_panel.visible = false

func update_health(current: int, maximum: int):
	if health_bar:
		health_bar.value = (float(current) / float(maximum)) * 100

func update_experience(current: int, needed: int):
	if experience_bar:
		experience_bar.value = (float(current) / float(needed)) * 100

func update_time(time: float):
	if time_label:
		var minutes = int(time / 60)
		var seconds = int(time) % 60
		time_label.text = "Время: %02d:%02d" % [minutes, seconds]

func update_score(score: int):
	if score_label:
		score_label.text = "Счет: " + str(score)

func update_level(level: int):
	if level_label:
		level_label.text = "Уровень: " + str(level)

func _on_player_health_changed(new_health: int, max_health: int):
	update_health(new_health, max_health)

func _on_level_up():
	show_level_up_menu()

func _on_game_over():
	show_game_over()

func show_level_up_menu():
	get_tree().paused = true
	level_up_panel.visible = true
	
	# Clear previous options
	for child in level_up_options.get_children():
		if child is Button:
			child.queue_free()
	
	# Get upgrade options from player
	var options = player.get_level_up_options()
	
	# Create buttons for each option
	for option in options.slice(0, 3):  # Show max 3 options
		var button = Button.new()
		button.text = option.name + "\n" + option.description
		button.pressed.connect(_on_level_up_option_selected.bind(option))
		level_up_options.add_child(button)

func _on_level_up_option_selected(option: Dictionary):
	player.apply_level_up_choice(option)
	level_up_panel.visible = false
	get_tree().paused = false
	
	# Update level display
	update_level(game_manager.current_level)

func show_game_over():
	game_over_panel.visible = true
	
	# Show final stats
	var final_score = game_manager.score
	var final_time = game_manager.game_time
	var final_level = game_manager.current_level
	
	var stats_text = "Игра окончена!\n"
	stats_text += "Счет: %d\n" % final_score
	stats_text += "Время: %02d:%02d\n" % [int(final_time / 60), int(final_time) % 60]
	stats_text += "Уровень: %d" % final_level
	
	var stats_label = game_over_panel.get_node("StatsLabel")
	if stats_label:
		stats_label.text = stats_text

func _on_restart_button_pressed():
	game_manager.restart_game()

func _on_quit_button_pressed():
	get_tree().quit()