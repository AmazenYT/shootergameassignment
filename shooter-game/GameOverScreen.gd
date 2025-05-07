extends Control

@onready var restart_button: Button = $RestartButton
@onready var quit_button: Button = $QuitButton

func _ready():
	restart_button.pressed.connect(_on_restart_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
func _on_restart_pressed():
	get_tree().change_scene_to_file("res://world.tscn")  # Update if the path differs

func _on_quit_pressed():
	get_tree().quit()
