extends Node2D

@export var level_num = 1

func _ready():
	$HUD.level(level_num)
	set_gems_label()
	for gem in $Gems.get_children():
		gem.gem_collected.connect(_on_gem_collected)

func _on_gem_collected():
	set_gems_label()

func set_gems_label():
	$HUD.gems(Global.gems_collected)

func _on_door_player_entered(level_path):
	print("Attempting to load: ", level_path)
	get_tree().call_deferred("change_scene_to_file", level_path)

func _input(event):
	if event.is_action_pressed("reset_level"):
		get_tree().reload_current_scene.call_deferred()
		Global.gems_collected = 0
		set_gems_label()
