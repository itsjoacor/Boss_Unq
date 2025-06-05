extends CharacterBody2D

enum DIRECTION { UP, RIGHT, DOWN, LEFT }

@onready var sprite := $Sprite2D
@onready var attack_cooldown_timer := $AttackCooldownTimer

@export var shuriken_scene: PackedScene
var shuriken_distance_from_center = 100 

var idle_textures := {
	DIRECTION.UP: preload("res://Sprites/Bkg/idle_up_noBKG.png"),
	DIRECTION.RIGHT: preload("res://Sprites/Bkg/idle_right_noBKG.png"),
	DIRECTION.DOWN: preload("res://Sprites/Bkg/idle_down_noBKG.png"),
	DIRECTION.LEFT: preload("res://Sprites/Bkg/idle_left_noBKG.png"),
}
var starting_texture := preload("res://Sprites/idle_front_noBKG (2).png")  # Add your starting sprite path
var has_moved := false  # Track if player has moved

var current_direction: DIRECTION = DIRECTION.UP
var can_attack: bool = true
var attack_cooldown: float = 0.3
var health: int = 1
var is_alive: bool = true
var distance_from_center = 64

@onready var attack_area: Area2D = $AttackArea
@onready var ui = get_parent().get_node("UI")

func _ready():
	$AttackArea.set_collision_mask_value(4, false)  # Layer 4 = shurikens
	sprite.texture = starting_texture  # Set starting sprite
	update_rotation()
	attack_area.position = Vector2(0, 0)
	if not attack_area:
		push_error("AttackArea not found!")
	ui.update_health(health)

func _process(_delta):
	if not is_alive:
		return
	handle_input()

func handle_input():
	var direction_changed = false
	
	if Input.is_action_just_pressed("up"):
		current_direction = DIRECTION.UP
		direction_changed = true
	elif Input.is_action_just_pressed("right"):
		current_direction = DIRECTION.RIGHT
		direction_changed = true
	elif Input.is_action_just_pressed("down"):
		current_direction = DIRECTION.DOWN
		direction_changed = true
	elif Input.is_action_just_pressed("left"):
		current_direction = DIRECTION.LEFT
		direction_changed = true
	
	if direction_changed:
		has_moved = true  # Player has moved from starting position
		update_rotation()
		update_sprite()
	
	if Input.is_action_just_pressed("attack_red"):
		try_attack("red")

	elif Input.is_action_just_pressed("attack_green"):
		try_attack("green")

	elif Input.is_action_just_pressed("attack_blue"):
		try_attack("blue")

	elif Input.is_action_just_pressed("attack_yellow"):
		try_attack("yellow")

		
	
		


func update_rotation():
	var attack_distance = 100  # Adjust this value as needed
	
	match current_direction:
		DIRECTION.UP:
			attack_area.position = Vector2(0, -attack_distance)
		DIRECTION.RIGHT:
			attack_area.position = Vector2(attack_distance, 0)
		DIRECTION.DOWN:
			attack_area.position = Vector2(0, attack_distance)
		DIRECTION.LEFT:
			attack_area.position = Vector2(-attack_distance, 0)

func update_sprite():
	if !has_moved:
		return  # Keep starting sprite until first movement
	
	if sprite and current_direction in idle_textures:
		sprite.texture = idle_textures[current_direction]

func try_attack(color: String):
	if not can_attack or not is_alive:
		return
	
	can_attack = false
	spawn_shuriken(color)
	get_tree().create_timer(attack_cooldown).timeout.connect(
		func(): can_attack = true, 
		CONNECT_ONE_SHOT
	)


func spawn_shuriken(color: String):
	if not shuriken_scene:
		push_error("Shuriken scene not loaded!")
		return
	
	var shuriken = shuriken_scene.instantiate()
	get_parent().add_child(shuriken)
	
	# Position shuriken at player's position
	shuriken.global_position = global_position
	
	# Set direction based on current facing
	match current_direction:
		DIRECTION.UP:
			shuriken.direction = Vector2.UP
		DIRECTION.RIGHT:
			shuriken.direction = Vector2.RIGHT
		DIRECTION.DOWN:
			shuriken.direction = Vector2.DOWN
		DIRECTION.LEFT:
			shuriken.direction = Vector2.LEFT
	
	# Set shuriken color (if you want colored shurikens)
	shuriken.color = color
	
	   # Only allow killing if enemy is in attack area
	var overlapping = attack_area.get_overlapping_bodies()
	shuriken.can_kill = overlapping.any(func(body): 
		return body.is_in_group("enemies") and ["red","green","blue","yellow"][body.color] == color
	)


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
	get_tree().change_scene_to_file("res://Menu/GameOver/GameOver.tscn")

func _draw():
	if Engine.is_editor_hint() and attack_area and attack_area.get_child_count() > 0:
		var shape = attack_area.get_child(0).shape 
		if shape:
			draw_circle(Vector2.ZERO, shape.radius, Color(1, 0, 0, 0.3))
			
func decrease_health():
	health -= 1
	ui.update_health(health)
	if health == 0:
		die()
		
		
