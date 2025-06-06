extends Control

func _ready():
	pass




func _on_go_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu/MainMenu/MainMenu.tscn")
