extends Control
signal back

@export var lock_icon: CompressedTexture2D


func appear():
	show()
	update_scores()


func update_scores():
	for i in range(1, 4):
		update_level_label(i)


func update_level_label(level: int):
	var label = $MenuButtons/VBoxContainer.get_child(level)
	if level == 1 or Global.get_level_score(level - 1) > 0:
		label.text = "Level " + str(level) + "\nScore: " + \
				str(Global.get_level_score(level))
		label.icon = null
	else:
		label.text = "Level " + str(level)
		label.icon = lock_icon


func _on_level_1_pressed():
	await Fade.fade_out().finished
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")
	Fade.fade_in()


func _on_level_2_pressed():
	if Global.get_level_score(1) > 0:
		await Fade.fade_out().finished
		back.emit()
		Fade.fade_in()


func _on_level_3_pressed():
	if Global.get_level_score(2) > 0:
		await Fade.fade_out().finished
		back.emit()
		Fade.fade_in()


func _on_main_menu_pressed():
	back.emit()
