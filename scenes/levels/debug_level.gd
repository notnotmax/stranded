extends Control
signal level_completed

# level takes (level_duration / 60) seconds to complete
var level_duration = 5 * 60
var elapsed_frames = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	elapsed_frames += 1
	if elapsed_frames >= level_duration:
		level_completed.emit()
