extends Area2D

var speed: float = 300.0
var direction: Vector2 = Vector2.UP
var color: String = "red"
var can_kill: bool = false  # New flag


func _ready():
	set_collision_mask_value(3, true)  # Only detect enemies (layer 3)
	body_entered.connect(_on_body_entered)


func _physics_process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	if body.is_in_group("enemies") and can_kill:  # Only check when flagged
		var color_names = ["red", "green", "blue", "yellow"]
		if color_names[body.color] == color:
			body.queue_free()
	queue_free()

func _process(delta):
	if has_node("Sprite2D"):
		$Sprite2D.rotate(10 * delta)  # Spin effectgwgg
