extends Node2D

@export var initial_spawn_rate: float = 6.0
@export var spawn_decrease_amount: float = 0.25
@export var min_spawn_rate: float = 1.0  # Tiempo mínimo entre enemigos

var wave: int = 1
var current_spawn_rate: float
var colors = ["red", "green", "blue", "yellow"]
var directions = ["up", "right", "down", "left"]

@onready var spawn_timer: Timer
@onready var player: CharacterBody2D

func _ready():
	spawn_timer = $SpawnTimer
	player = $Player

	current_spawn_rate = initial_spawn_rate
	spawn_timer.wait_time = current_spawn_rate
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.start()

func _on_spawn_timer_timeout():
	spawn_enemy()
	
	wave += 1

	# Disminuir gradualmente el tiempo de espera aka (aumentar dificultad)
	current_spawn_rate = max(min_spawn_rate, current_spawn_rate - spawn_decrease_amount)
	spawn_timer.wait_time = current_spawn_rate

func spawn_enemy():
	var enemy_scene = load("res://Enemy/Enemy.tscn")
	var enemy = enemy_scene.instantiate()

	enemy.color = randi() % 4
	enemy.move_direction = randi() % 4
	
	add_child(enemy)

func _process(_delta):
	if not is_instance_valid(player):
		if is_instance_valid(spawn_timer):
			spawn_timer.stop()
