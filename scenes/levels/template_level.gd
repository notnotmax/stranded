extends Node

func get_player():
	return $Player


# Signals the level as completed and show the clear screen
func complete_level():
	$LevelComplete.complete_level()
