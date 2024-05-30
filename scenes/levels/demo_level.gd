extends Control
signal level_completed

@export var asteroid1: PackedScene
@export var asteroid2: PackedScene
@export var asteroid3: PackedScene
@export var asteroid4: PackedScene

# level takes (level_duration / 60) seconds to complete
var level_duration = 30 * 60
var elapsed_frames = 0

func _ready():
	$AsteroidTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	elapsed_frames += 1
	if elapsed_frames >= level_duration:
		level_completed.emit()


func _on_asteroid_timer_timeout():
	spawn_asteroid_1()
	
	if randf() < 0.75:
		spawn_asteroid_2()
	
	if randf() < 0.5:
		spawn_asteroid_3()


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
