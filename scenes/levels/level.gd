"""
Empty level encapsulating common functionality such as the background,
player, pause menu, failure and completion screens.
"""

extends Node
class_name Level

var score: int = 0


func get_player():
	return $Player


func add_score(p_score):
	score += p_score


# Signals the level as completed and show the clear screen
func complete_level():
	$LevelComplete.complete_level(score)


func _on_player_on_damaged():
	$PlayerLifeDisplay.update_display($Player.lives)
