extends CharacterBody2D

enum COLOR { RED, GREEN, BLUE, YELLOW }
enum DIRECTION { UP, RIGHT, DOWN, LEFT }

@export var color: COLOR = COLOR.RED
@export var move_direction: DIRECTION = DIRECTION.UP
@export var speed: float = 50.0

var damage: int = 1
var colors = {
	COLOR.RED: Color.RED,
	COLOR.GREEN: Color.GREEN,
	COLOR.BLUE: Color.BLUE,
	COLOR.YELLOW: Color.YELLOW
}

@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	add_to_group("enemies")
	sprite.modulate = colors[color]
	setup_movement_direction()

func setup_movement_direction():
	match move_direction:
		DIRECTION.UP:
			position.x = get_viewport_rect().size.x / 2
			position.y = get_viewport_rect().size.y + 50
		DIRECTION.RIGHT:
			position.x = -50
			position.y = get_viewport_rect().size.y / 2
		DIRECTION.DOWN:
			position.x = get_viewport_rect().size.x / 2
			position.y = -50
		DIRECTION.LEFT:
			position.x = get_viewport_rect().size.x + 50
			position.y = get_viewport_rect().size.y / 2

func _physics_process(delta):
	var velocity = Vector2.ZERO
	match move_direction:
		DIRECTION.UP:
			velocity.y = -1
		DIRECTION.DOWN:
			velocity.y = 1
		DIRECTION.LEFT:
			velocity.x = -1
		DIRECTION.RIGHT:
			velocity.x = 1

	velocity = velocity.normalized() * speed
	var collision = move_and_collide(velocity * delta)

	if collision:
		var collider = collision.get_collider()
		if collider.name == "Player":
			collider.decrease_health()
			queue_free()

func get_color_type() -> int:
	return color
	
func _on_body_entered(body):
	if body.is_in_group("shurikens"):
		modulate.a = 0.5
		await get_tree().create_timer(0.1).timeout
		queue_free()
		
func _on_visibility_notifier_screen_exited():
	queue_free()


	
