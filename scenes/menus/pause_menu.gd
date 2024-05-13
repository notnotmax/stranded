extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	var resume_button = $MarginContainer/VBoxContainer/ResumeButton
	var restart_button = $MarginContainer/VBoxContainer/RestartButton
	var quit_button = $MarginContainer/VBoxContainer/QuitButton
	resume_button.connect("pressed", _on_restart_button_pressed)
	restart_button.connect("pressed", _on_restart_button_pressed)
	quit_button.connect("pressed", _on_quit_button_pressed)
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = false
	self.hide()


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if not self.is_visible_in_tree():
			self.show()
			get_tree().paused = true
		else:
			self.hide()
			get_tree().paused = false


func _on_resume_button_pressed():
	self.hide()
	get_tree().paused = false


func _on_restart_button_pressed():
	self.hide()
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_quit_button_pressed():
	self.hide()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
