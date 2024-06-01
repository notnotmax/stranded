extends Control
signal level_completed

@export var asteroid1: PackedScene
@export var asteroid2: PackedScene
@export var asteroid3: PackedScene
@export var asteroid4: PackedScene


func _ready():
	$StartTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	$LevelName.modulate = lerp($LevelName.modulate, Color(1,1,1,0), 0.05)


func _on_start_timer_timeout():
	$AsteroidTimer.start()
	$LevelTimer.start()
	

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
	var asteroid = asteroid1.instantiate()
	
	var location = $Path2D/PathFollow2D
	location.progress_ratio = randf()
	
	asteroid.position = location.position
	var velocity = Vector2(randf_range(1,3), 0)
	asteroid.velocity = velocity
	
	add_child(asteroid)


func spawn_asteroid_2():
	var asteroid = asteroid2.instantiate()
	
	var location = $Path2D/PathFollow2D
	location.progress_ratio = randf()
	
	asteroid.position = location.position
	var velocity = Vector2(randf_range(1,2), 0)
	asteroid.velocity = velocity
	
	add_child(asteroid)


func spawn_asteroid_3():
	var asteroid = asteroid3.instantiate()
	
	var location = $Path2D/PathFollow2D
	location.progress_ratio = randf()
	
	asteroid.position = location.position
	var velocity = Vector2(randf_range(0.5,1), 0)
	asteroid.velocity = velocity
	
	add_child(asteroid)


func spawn_asteroid_4():
	var asteroid = asteroid4.instantiate()
	
	var location = $Path2D/PathFollow2D
	location.progress_ratio = randf()
	
	asteroid.position = location.position
	var velocity = Vector2(randf_range(0.2,1), 0)
	asteroid.velocity = velocity
	
	add_child(asteroid)
