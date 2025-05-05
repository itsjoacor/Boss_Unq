extends Node2D

@export var spawn_rate: float = 2.0
@export var difficulty_increase_rate: float = 0.95

var wave: int = 1
var colors = ["red", "green", "blue", "yellow"]
var directions = ["up", "right", "down", "left"]

@onready var spawn_timer: Timer
@onready var player: CharacterBody2D

func _ready():

	spawn_timer = $SpawnTimer
	player = $Player

	spawn_timer.wait_time = spawn_rate
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.start()

func _on_spawn_timer_timeout():
	spawn_enemy()
	
	wave += 1
	spawn_timer.wait_time *= difficulty_increase_rate

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
