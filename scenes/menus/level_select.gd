extends Control
signal back


func _on_level_1_pressed():
	await Fade.fade_out().finished
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")
	Fade.fade_in()


func _on_main_menu_pressed():
	back.emit()
