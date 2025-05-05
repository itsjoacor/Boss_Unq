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
	var movement = Vector2.ZERO
	
	match move_direction:
		DIRECTION.UP:
			movement.y = -speed * delta
		DIRECTION.RIGHT:
			movement.x = speed * delta
		DIRECTION.DOWN:
			movement.y = speed * delta
		DIRECTION.LEFT:
			movement.x = -speed * delta
	
	move_and_collide(movement)

func _on_visibility_notifier_screen_exited():
	queue_free()

func _on_body_entered(body):
	if body.name == "Player":
		body.take_damage()
		queue_free()
