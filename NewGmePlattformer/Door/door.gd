extends Area2D

@export var level_number : int = 2  # Just put the number here
signal player_entered(level)

func _on_body_entered(body):
	if body.name == "Player":
		player_entered.emit("res://Levels/level_%s.tscn" % level_number)
