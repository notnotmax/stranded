extends Control
signal back


func appear():
	show()
	update_scores()


func update_scores():
	$MenuButtons/VBoxContainer/Level1/Label.text = str(Global.level_1_score)


func _on_level_1_pressed():
	await Fade.fade_out().finished
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")
	Fade.fade_in()


func _on_main_menu_pressed():
	back.emit()


func _on_save_score_pressed():
	Global.level_1_score = 135
	Global.save_data()
