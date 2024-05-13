extends Control
signal level_completed

var level_duration = 150
var progress: float = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var progress_bar = $ProgressBar
	var progress_label = $ProgressBar/ProgressLabel
	progress += 1
	progress_bar.value = (progress * 100) / level_duration
	progress_label.text = str(progress_bar.value) + "%"
	if (progress == level_duration):
		level_completed.emit()
