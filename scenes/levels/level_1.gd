extends Level

@export var asteroid1: PackedScene
@export var asteroid2: PackedScene
@export var asteroid3: PackedScene
@export var asteroid4: PackedScene
@export var fighter: PackedScene
@export var fighter2: PackedScene
@export var deathbomber: PackedScene
@export var medium_enemy: PackedScene


func _ready():
	await super._ready()
	$LevelTimer.start()
	spawn_asteroids()
	spawn_wave_1()


func _on_level_timer_timeout():
	pass
	#complete_level()

## Asteroids

@onready var asteroid_spawnpoint = $Asteroids/Path2D/PathFollow2D

func spawn_asteroids():
	$Asteroids/AsteroidTimer.start()


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
	var asteroid = asteroid1.instantiate()
	asteroid.init(
		asteroid_spawnpoint.position,
		randf_range(1,3),
		Vector2(-1, 0)
		)
	add_child(asteroid)


func spawn_asteroid_2():
	asteroid_spawnpoint.progress_ratio = randf()
	var asteroid = asteroid2.instantiate()
	asteroid.init(
		asteroid_spawnpoint.position,
		randf_range(1, 2),
		Vector2(-1, 0)
		)
	add_child(asteroid)


func spawn_asteroid_3():
	asteroid_spawnpoint.progress_ratio = randf()
	var asteroid = asteroid3.instantiate()
	asteroid.init(
		asteroid_spawnpoint.position,
		randf_range(0.5, 1),
		Vector2(-1, 0)
		)
	add_child(asteroid)


func spawn_asteroid_4():
	asteroid_spawnpoint.progress_ratio = randf()
	var asteroid = asteroid4.instantiate()
	asteroid.init(
		asteroid_spawnpoint.position,
		randf_range(0.2, 1),
		Vector2(-1, 0)
		)
	add_child(asteroid)


func spawn_wave_1():
	for i in range(10):
		var enemy = fighter.instantiate()
		enemy.init(Vector2(0,0), get_player())
		enemy.move_on_path($Wave1/Path2D, 5, 1)
		var enemy2 = fighter.instantiate()
		enemy2.init(Vector2(0,0), get_player())
		enemy2.move_on_path($Wave1/Path2D2, 5, 1)
		await delay(0.5)
	spawn_wave_2()


func spawn_wave_2():
	for i in range(10):
		var wave_enemy = fighter.instantiate()
		wave_enemy.init(Vector2(0,0), get_player())
		wave_enemy.move_on_path($Wave2/Path2D3, 10, 1)
		await delay(0.5)
	var enemy = fighter2.instantiate()
	enemy.init(Vector2(0,0), get_player(), 2)
	enemy.move_on_path($Wave2/Path2D, 2, 1)
	var enemy2 = fighter2.instantiate()
	enemy2.init(Vector2(0,0), get_player(), 2)
	enemy2.move_on_path($Wave2/Path2D2, 2, 1)
	var medium = medium_enemy.instantiate()
	medium.init(Vector2(0,0), get_player(), 3)
	medium.move_on_path($Wave2/Path2D4, 3, 1)
	medium.connect("death", temp)


func temp():
	await delay(2)
	complete_level()
