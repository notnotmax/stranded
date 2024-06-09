"""
Empty level encapsulating common functionality such as the background,
player, pause menu, failure and completion screens.
"""

extends Node
class_name Level


func get_player():
	return $Player


# Signals the level as completed and show the clear screen
func complete_level():
	$LevelComplete.complete_level()
