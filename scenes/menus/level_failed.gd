extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	var retry_button = $MarginContainer/Retry
	var quit_button = $MarginContainer/MainMenuButton
	retry_button.connect("pressed", _on_retry_button_pressed)
	quit_button.connect("pressed", _on_quit_button_pressed)
	process_mode = Node.PROCESS_MODE_ALWAYS
	self.hide()


func appear():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true
	self.show()


func _on_retry_button_pressed():
	self.hide()
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_quit_button_pressed():
	self.hide()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
