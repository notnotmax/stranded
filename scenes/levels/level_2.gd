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


# small pink enemies on curved paths, auto-exit
# duration: 13s
func spawn_wave_1():
	for i in range(10):
		var enemy = fighter.instantiate()
		enemy.init(Vector2(0,0), get_player())
		enemy.move_on_path($Wave1/Path2D, 5, 1, true)
		var enemy2 = fighter.instantiate()
		enemy2.init(Vector2(0,0), get_player())
		enemy2.move_on_path($Wave1/Path2D2, 5, 1, true)
		await delay(1)
	await delay(3)
	spawn_wave_2()


# more small pink enemies in a line with a few small orange enemies
# duration: 18s
func spawn_wave_2():
	wave_2_helper_1() # need this to be asynchronous
	await delay(5)
	for i in range(5):
		var orange = fighter2.instantiate()
		orange.init(Vector2(1300, randi_range(50, 720 - 50)),
				get_player(), 1)
		add_child(orange)
		orange.move_by(Vector2(-randi_range(100, 300), 0), 1, true)
		orange.exit_after(5, 2)
		await delay(2)
	await delay(3)
	spawn_wave_3()


# duration: 20s
func wave_2_helper_1():
	for i in range(10):
		var e1 = fighter.instantiate()
		e1.init(Vector2(0, 0), get_player(), 3)
		e1.move_on_path($Wave2/DownPath, 10, 1)
		await delay(0.5)
		var e2 = fighter.instantiate()
		e2.init(Vector2(0, 0), get_player(), 3)
		e2.move_on_path($Wave2/UpPath, 10, 1)
		await delay(0.5)


# duration: ~20s
func spawn_wave_3():
	wave_3_helper_1()
	for i in range(3): # 5s
		for j in range(2):
			var e1 = fighter.instantiate()
			e1.init(Vector2(0, 0), get_player())
			e1.move_on_path($Wave3/Path2D, 10, 1, true)
			await delay(0.25)
		await delay(1.5)
	for i in range(3): # 5s
		for j in range(2):
			var e1 = fighter.instantiate()
			e1.init(Vector2(0, 0), get_player())
			e1.move_on_path($Wave3/Path2D2, 10, 1, true)
			await delay(0.25)
		await delay(1.5)
	for i in range(3): # 6s
		for j in range(2):
			var e1 = fighter.instantiate()
			e1.init(Vector2(0, 0), get_player())
			e1.move_on_path($Wave3/Path2D, 10, 1, true)
			await delay(0.25)
		for j in range(2):
			var e1 = fighter.instantiate()
			e1.init(Vector2(0, 0), get_player())
			e1.move_on_path($Wave3/Path2D2, 10, 1, true)
			await delay(0.25)
		await delay(1)
	await delay(5)
	spawn_wave_4()


# duration: 15s
func wave_3_helper_1():
	for i in range(3):
		var orange = fighter2.instantiate()
		orange.init(Vector2(1300, 60 + 300 * i), get_player(), 3)
		add_child(orange)
		orange.move_by(Vector2(-200, 0), 3, true)
		orange.exit_after(15 - i, 2)
		await delay(1)


# final wave
func spawn_wave_4():
	# orange enemies in formation
	var orange = fighter2.instantiate()
	orange.init(Vector2(1300, 360), get_player(), 3)
	add_child(orange)
	orange.move_by(Vector2(-300, 0), 3, true)
	orange.connect("death", wave_4_on_orange_death)
	await delay(1)
	for i in range(2): # 2nd layer of enemies
		var orange_2 = fighter2.instantiate()
		orange_2.init(Vector2(1300, 460 - 200 * i), get_player(), 4)
		add_child(orange_2)
		orange_2.move_by(Vector2(-200, 0), 2, true)
		orange_2.connect("death", wave_4_on_orange_death)
	await delay(1)
	## nerfed due to difficulty feedback
	#for i in range(2): # 3rd layer of enemies
		#var orange_3 = fighter2.instantiate()
		#orange_3.init(Vector2(1300, 560 - 400 * i), get_player(), 5)
		#add_child(orange_3)
		#orange_3.move_by(Vector2(-100, 0), 1, true)
		#orange_3.connect("death", wave_4_on_orange_death)
	#await delay(1)
	# medium enemy serves as the final enemy
	var medium = medium_enemy.instantiate()
	medium.init(Vector2(0, 0), get_player(), 5)
	medium.move_on_path($Wave4/Path2D, 5, 1, true)
	medium.connect("death", on_medium_killed)


var medium_killed: bool = false
func on_medium_killed():
	medium_killed = true
	print(wave_4_killed)
	if wave_4_killed >= 10:
		complete_level()


var wave_4_killed: int = 0
# when an orange enemy dies, summon another one in random position
# until 10 are killed
func wave_4_on_orange_death():
	wave_4_killed += 1
	print(wave_4_killed)
	if wave_4_killed >= 10 and medium_killed:
		complete_level()
	elif wave_4_killed <= 7:
		await delay(1)
		var orange = fighter2.instantiate()
		orange.init(
			Vector2(1300, randi_range(100, 620)),
			get_player(),
			3)
		add_child(orange)
		var rng = randf_range(1, 3)
		orange.move_by(Vector2.LEFT * 100 * rng, rng, true)
		orange.connect("death", wave_4_on_orange_death)
	else:
		pass
