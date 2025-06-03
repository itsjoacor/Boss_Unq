extends Control

func _ready() -> void:
	$CenterContainer/Panel/VBoxContainer/Resume.pressed.connect(_on_resume_pressed)
	$CenterContainer/Panel/VBoxContainer/Restart.pressed.connect(_on_restart_pressed)
	$CenterContainer/Panel/VBoxContainer/Quit.pressed.connect(_on_quit_pressed)

func _on_resume_pressed():
	get_tree().paused = false
	visible = false

func _on_restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_pressed():
	get_tree().quit()
