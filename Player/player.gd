extends CharacterBody2D

enum DIRECTION { UP, RIGHT, DOWN, LEFT }
const ROTATION_ANGLES = [0, 90, 180, 270]

var current_direction: DIRECTION = DIRECTION.UP
var can_attack: bool = true
var attack_cooldown: float = 0.3
var health: int = 3
var is_alive: bool = true

@onready var attack_area: Area2D = $AttackArea
@onready var ui = get_parent().get_node("Ui")

func _ready():
	update_rotation()
	if not attack_area:
		push_error("AttackArea not found!")
	ui.update_health(health)

func _process(_delta):
	if not is_alive:
		return
	handle_input()

func handle_input():
	if Input.is_action_just_pressed("up"):
		current_direction = DIRECTION.UP
		update_rotation()
	elif Input.is_action_just_pressed("right"):
		current_direction = DIRECTION.RIGHT
		update_rotation()
	elif Input.is_action_just_pressed("down"):
		current_direction = DIRECTION.DOWN
		update_rotation()
	elif Input.is_action_just_pressed("left"):
		current_direction = DIRECTION.LEFT
		update_rotation()
	
	if Input.is_action_just_pressed("attack_red"):
		try_attack("red")
	elif Input.is_action_just_pressed("attack_green"):
		try_attack("green")
	elif Input.is_action_just_pressed("attack_blue"):
		try_attack("blue")
	elif Input.is_action_just_pressed("attack_yellow"):
		try_attack("yellow")

func update_rotation():
	rotation_degrees = ROTATION_ANGLES[current_direction]

func try_attack(color: String):
	if not can_attack or not attack_area or not is_alive:
		return
	
	can_attack = false
	get_tree().create_timer(attack_cooldown).timeout.connect(
		func(): can_attack = true, 
		CONNECT_ONE_SHOT
	)
	
	var overlapping_bodies = attack_area.get_overlapping_bodies()
	for body in overlapping_bodies:
		if body.is_in_group("enemies"):
			var color_names = ["red", "green", "blue", "yellow"]
			if body.color < color_names.size() and color_names[body.color] == color:
				body.queue_free()
				return true
	
	return false

func take_damage():
	if not is_alive:
		return
		
	health -= 1
	ui.update_health(health)
	
	if health <= 0:
		die()

func die():
	is_alive = false
	queue_free()
	get_node("/root/Main").game_over()

func _draw():
	if Engine.is_editor_hint() and attack_area and attack_area.get_child_count() > 0:
		var shape = attack_area.get_child(0).shape
		if shape:
			draw_circle(Vector2.ZERO, shape.radius, Color(1, 0, 0, 0.3))
