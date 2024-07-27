extends Level


func _ready():
	await super._ready()
	spawn_asteroids()
	await delay(5)
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


# small amount of pink enemies
# duration: 21s
func spawn_wave_1():
	# one enemy appears, then leaves - 5s
	var enemy = fighter.instantiate()
	enemy.init(Vector2(1300, 360), get_player(), 3)
	add_child(enemy)
	enemy.move_by(Vector2.LEFT * 200, 3, true)
	enemy.exit_after(5, 2)
	await delay(5)
	# calls more enemies in at random locations - 7s
	for i in range(3):
		spawn_pink_enemy_random_location()
		await delay(1)
	await delay(4)
	# calls enemies in a diagonal formation - 9s
	for i in range(3):
		var e = fighter.instantiate()
		e.init(Vector2(0, 0), get_player(), 3 - i)
		e.move_on_path($Wave1/Path2D, 3 - i, 1 - 0.3 * i)
		e.exit_after(5, 5 - i)
		var e2 = fighter.instantiate()
		e2.init(Vector2(0, 0), get_player(), 3 - i)
		e2.move_on_path($Wave1/Path2D2, 3 - i, 1 - 0.3 * i)
		e2.exit_after(5, 5 - i)
		await delay(2)
	await delay(3)
	spawn_wave_2()


func spawn_pink_enemy_random_location():
	var e = fighter.instantiate()
	e.init(Vector2(1300, randi_range(100, 620)), get_player(), 3)
	add_child(e)
	e.move_by(Vector2.LEFT * 200, 3, true)
	e.exit_after(5, 2)


# one orange with an arc of pink and red
# duration: 10s
func spawn_wave_2():
	var orange = fighter2.instantiate()
	orange.init(Vector2(0, 0), get_player(), 5)
	orange.move_on_path($Wave2/CenterPath, 5, 1)
	orange.exit_after(10, 3)
	wave_2_helper_1()
	wave_2_helper_2()
	await delay(10)
	spawn_wave_3()

# spawn pink enemies in an arc
# duration: 2.5s
func wave_2_helper_1():
	for i in range(5):
		var e = fighter.instantiate()
		e.init(Vector2(0, 0), get_player(), 3)
		e.move_on_path($Wave2/DownPath, 5, 0.8 - 0.15 * i)
		e.exit_after(10 - 0.5 * i, 3)
		await delay(0.5)


# spawn red enemies in an arc
# duration: 2s
func wave_2_helper_2():
	for i in range(4):
		var e2 = deathbomber.instantiate()
		e2.init(Vector2(0, 0), get_player())
		e2.move_on_path($Wave2/UpPath, 5, 0.725 - 0.15 * i)
		var move_left = func():
			e2.move_by(Vector2.LEFT * 1300, 5)
		e2.call_delayed(move_left, 10 - 0.5 * i)
		await delay(0.5)


var wave_3_ended: bool = false
# 3 oranges, random pinks and reds
# duration: 20s
func spawn_wave_3():
	# random red enemies
	wave_3_helper_1()
	# 2 + 1 orange enemies
	wave_3_helper_2()
	await delay(5)
	# 10 pink enemies - 10s
	for i in range(10):
		spawn_pink_enemy_random_location()
		await delay(1)
	await delay(5)
	wave_3_ended = true


# random red enemies
# duration - 20s
func wave_3_helper_1():
	for i in range(10):
		var red = deathbomber.instantiate()
		red.init(Vector2(1300, randi_range(100, 620)), get_player())
		add_child(red)
		red.move_by(Vector2.LEFT * 2000, 10)
		await delay(1)


# 3 orange enemies
# duration - until the middle orange is killed
func wave_3_helper_2():
	var orange = fighter2.instantiate()
	orange.init(Vector2(1300, 360 - 100), get_player(), 3)
	add_child(orange)
	orange.move_by(Vector2.LEFT * 200, 3, true)
	orange.exit_after(20, 3)
	var orange2 = fighter2.instantiate()
	orange2.init(Vector2(1300, 360 + 100), get_player(), 3)
	add_child(orange2)
	orange2.move_by(Vector2.LEFT * 200, 3, true)
	orange2.exit_after(20, 3)
	await delay(10)
	var orange3 = fighter2.instantiate()
	orange3.init(Vector2(1300, 360), get_player(), 3)
	add_child(orange3)
	orange3.move_by(Vector2.LEFT * 300, 5, true)
	orange3.connect("death", win)


# when middle orange is killed, wait for wave 3 to end before
# completing level
func win():
	if not wave_3_ended:
		await delay(10)
	complete_level()
