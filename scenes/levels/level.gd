"""
Empty level encapsulating common functionality such as the background,
player, pause menu, failure and completion screens.
"""

extends Node
class_name Level

var score: int = 0

func _ready():
	$Player.can_move = false
	$Player.position = Vector2(-100, get_viewport().get_visible_rect().size.y / 2)
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property($Player, "position", $Player.position + Vector2(200, 0), 3)
	await delay(3.0)
	$Player.can_move = true


func get_player():
	return $Player


func add_score(p_score):
	score += p_score

# usage: await delay(seconds)
func delay(seconds: float):
	await get_tree().create_timer(seconds).timeout


# Signals the level as completed and show the clear screen
func complete_level():
	$LevelComplete.complete_level(score)


func _on_player_on_damaged():
	$PlayerLifeDisplay.update_display($Player.lives)
