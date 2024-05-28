extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$Spaceship.play()
	var play_button = $MenuButtons/VBoxContainer/PlayButton
	var settings_button = $MenuButtons/VBoxContainer/SettingsButton
	var quit_button = $MenuButtons/VBoxContainer/QuitButton
	play_button.connect("pressed", _on_play_button_pressed)
	settings_button.connect("pressed", _on_settings_button_pressed)
	quit_button.connect("pressed", _on_quit_button_pressed)

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/empty_demo.tscn")

func _on_settings_button_pressed():
	pass

func _on_quit_button_pressed():
	get_tree().quit()
