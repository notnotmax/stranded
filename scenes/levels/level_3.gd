extends Level


func _ready():
	await super._ready()
	spawn_asteroids()
	spawn_wave_1()

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
	spawn_boss()


func spawn_boss():
	var boss = boss_enemy.instantiate()
	boss.init(Vector2(0, 0), get_player(), 5)
	add_child(boss)
	boss.start_bossfight()
	boss.connect("death", complete_level)
