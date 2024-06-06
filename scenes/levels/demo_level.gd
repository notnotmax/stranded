extends Control
signal level_completed

@export var asteroid1: PackedScene
@export var asteroid2: PackedScene
@export var asteroid3: PackedScene
@export var asteroid4: PackedScene
@export var enemy_small: PackedScene

@onready var player = $Player
@onready var enemy_path_1 = $EnemyPath1


func _ready():
	$StartTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	$LevelName.modulate = lerp($LevelName.modulate, Color(1,1,1,0), 0.05)


func _on_start_timer_timeout():
	$AsteroidTimer.start()
	$LevelTimer.start()
	spawn_enemy_small()
	

func _on_asteroid_timer_timeout():
	spawn_asteroid_1()
	
	if randf() < 0.75:
		spawn_asteroid_2()
	
	if randf() < 0.5:
		spawn_asteroid_3()
	
	if randf() < 0.25:
		spawn_asteroid_4()


func _on_level_timer_timeout():
	level_completed.emit()


func spawn_asteroid_1():
	var location = $Path2D/PathFollow2D
	location.progress_ratio = randf()
	var asteroid = asteroid1.instantiate().with_params(
		location.position,
		randf_range(1, 3),
		Vector2(-1, 0)
		)
	add_child(asteroid)


func spawn_asteroid_2():
	var location = $Path2D/PathFollow2D
	location.progress_ratio = randf()
	var asteroid = asteroid2.instantiate().with_params(
		location.position,
		randf_range(1, 2),
		Vector2(-1, 0)
		)
	add_child(asteroid)


func spawn_asteroid_3():
	var location = $Path2D/PathFollow2D
	location.progress_ratio = randf()
	var asteroid = asteroid3.instantiate().with_params(
		location.position,
		randf_range(0.5, 1),
		Vector2(-1, 0)
		)
	add_child(asteroid)


func spawn_asteroid_4():
	var location = $Path2D/PathFollow2D
	location.progress_ratio = randf()
	var asteroid = asteroid4.instantiate().with_params(
		location.position,
		randf_range(0.2, 1),
		Vector2(-1, 0)
		)
	add_child(asteroid)


func spawn_enemy_small():
	var enemy = enemy_small.instantiate().with_params(
		enemy_path_1,
		5,
		1,
		0.25
	)
	enemy.move()
