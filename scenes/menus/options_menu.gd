extends Control
signal back


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_unlock_levels_pressed():
	Global.unlock_all_levels()


func _on_reset_progress_pressed():
	Global.reset_scores()


func _on_main_menu_pressed():
	back.emit()
