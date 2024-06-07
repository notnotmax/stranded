extends Node

@export var asteroid1: PackedScene
@export var asteroid2: PackedScene
@export var asteroid3: PackedScene
@export var asteroid4: PackedScene
@export var enemy_small: PackedScene

@onready var core = $TemplateLevel


func _ready():
	$StartTimer.start()


func _on_start_timer_timeout():
	$Asteroids/AsteroidTimer.start()
	$LevelTimer.start()
	spawn_wave_1()


func _on_level_timer_timeout():
	core.complete_level()

## Asteroids

@onready var asteroid_spawnpoint = $Asteroids/Path2D/PathFollow2D

func _on_asteroid_timer_timeout():
	if randf() < 0.5:
		spawn_asteroid_1()
	
	if randf() < 0.25:
		spawn_asteroid_2()
	
	if randf() < 0.1:
		spawn_asteroid_3()
	
	if randf() < 0.05:
		spawn_asteroid_4()

func spawn_asteroid_1():
	asteroid_spawnpoint.progress_ratio = randf()
	var asteroid = asteroid1.instantiate().with_params(
		asteroid_spawnpoint.position,
		randf_range(1, 3),
		Vector2(-1, 0)
		)
	add_child(asteroid)


func spawn_asteroid_2():
	asteroid_spawnpoint.progress_ratio = randf()
	var asteroid = asteroid2.instantiate().with_params(
		asteroid_spawnpoint.position,
		randf_range(1, 2),
		Vector2(-1, 0)
		)
	add_child(asteroid)


func spawn_asteroid_3():
	asteroid_spawnpoint.progress_ratio = randf()
	var asteroid = asteroid3.instantiate().with_params(
		asteroid_spawnpoint.position,
		randf_range(0.5, 1),
		Vector2(-1, 0)
		)
	add_child(asteroid)


func spawn_asteroid_4():
	asteroid_spawnpoint.progress_ratio = randf()
	var asteroid = asteroid4.instantiate().with_params(
		asteroid_spawnpoint.position,
		randf_range(0.2, 1),
		Vector2(-1, 0)
		)
	add_child(asteroid)

## Wave 1

var wave_1_count: int = 0

func spawn_wave_1():
	wave_1_count = 10
	$Wave1/Timer.wait_time = 0.5
	$Wave1/Timer.start()


func _on_wave_1_timer_timeout():
	if wave_1_count > 0:
		var enemy = enemy_small.instantiate().with_params(
		$Wave1/Path2D, 5, core.get_player(), 1, 1
		)
		enemy.move()
		var enemy2 = enemy_small.instantiate().with_params(
		$Wave1/Path2D2, 5, core.get_player(), 1, 1
		)
		enemy2.move()
		wave_1_count -= 1
	else:
		$Wave1/Timer.stop()
