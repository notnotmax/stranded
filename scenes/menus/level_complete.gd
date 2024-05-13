extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	var quit_button = $MarginContainer/MainMenuButton
	quit_button.connect("pressed", _on_quit_button_pressed)
	process_mode = Node.PROCESS_MODE_ALWAYS
	self.hide()


func _on_quit_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")


func _on_empty_demo_level_completed():
	get_tree().paused = true
	self.show()
