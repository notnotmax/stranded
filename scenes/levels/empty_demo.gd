extends Control
signal level_completed

var level_duration = 3 * 60
var elapsed_frames = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	elapsed_frames += 1
	if elapsed_frames >= level_duration:
		level_completed.emit()
