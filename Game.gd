extends Node2D

@export var initial_spawn_rate: float = 6.0
@export var spawn_decrease_amount: float = 0.25
@export var min_spawn_rate: float = 1.0

@onready var pause_menu := $PauseMenu
@onready var spawn_timer: Timer = $SpawnTimer
@onready var player: CharacterBody2D = $Player
@onready var healthL: CanvasLayer = $UI
var wave: int = 1
var current_spawn_rate: float
var colors = ["red", "green", "blue", "yellow"]
var directions = ["up", "right", "down", "left"]

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS 
	current_spawn_rate = initial_spawn_rate
	spawn_timer.wait_time = current_spawn_rate
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.start()



	# El menú solo debería recibir inputs cuando el juego esté pausado
	pause_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	pause_menu.visible = false

func _on_spawn_timer_timeout():
	spawn_enemy()

	wave += 1
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

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		print("🛑 PRESSED P — paused =", get_tree().paused)
		if get_tree().paused:
			_resume_game()
		else:
			_pause_game()

func _pause_game() -> void:
	get_tree().paused = true
	healthL.visible = false
	pause_menu.visible = true

func _resume_game() -> void:
	get_tree().paused = false
	healthL.visible = true
	pause_menu.visible = false
