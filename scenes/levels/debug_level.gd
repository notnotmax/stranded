extends Control
signal level_completed

# level takes (level_duration / 60) seconds to complete
var level_duration = 10 * 60
var elapsed_frames = 0

func _ready():
	$EnemySmall.set_firing(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	elapsed_frames += 1
	if elapsed_frames >= level_duration:
		level_completed.emit()
