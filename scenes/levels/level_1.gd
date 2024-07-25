extends Level

@export var asteroid1: PackedScene
@export var asteroid2: PackedScene
@export var asteroid3: PackedScene
@export var asteroid4: PackedScene
@export var fighter: PackedScene
@export var fighter2: PackedScene
@export var deathbomber: PackedScene
@export var medium_enemy: PackedScene
@export var boss_enemy: PackedScene

@export var level_number: int


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


# duration: ~25s
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
	await delay(9)
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


func spawn_wave_4():
	# medium enemy serves as the final enemy
	var medium = medium_enemy.instantiate()
	medium.init(Vector2(0, 0), get_player(), 5)
	medium.move_on_path($Wave4/Path2D, 5, 1, true)
	medium.connect("death", complete_level)
	# flanked by 5 orange enemies
	var orange = fighter2.instantiate()
	orange.init(Vector2(1300, 360), get_player(), 1)
	add_child(orange)
	orange.move_by(Vector2(-300, 0), 1, true)
	for i in range(2):
		var orange_top = fighter2.instantiate()
		orange_top.init(Vector2(1300, 300 - 60 * i), get_player(), 1)
		add_child(orange_top)
		orange_top.move_by(Vector2(-200 + 100 * i, 0), 1, true)
	for i in range(2):
		var orange_bot = fighter2.instantiate()
		orange_bot.init(Vector2(1300, 420 + 60 * i), get_player(), 1)
		add_child(orange_bot)
		orange_bot.move_by(Vector2(-200 + 100 * i, 0), 1, true)


func spawn_wave_boss():
	var boss = boss_enemy.instantiate()
	boss.init(Vector2(0, 0), get_player(), 5)
	add_child(boss)
	boss.start_bossfight()
	#boss.connect("death", win)
