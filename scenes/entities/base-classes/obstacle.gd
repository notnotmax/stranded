extends Area2D
class_name Obstacle

# _init() does not work properly as a constructor (things may be null instance)
# so this is a workaround
func init(p_position: Vector2 = Vector2(0, 0)) -> void:
	position = p_position


# Utility function. Usage: await delay(seconds)
func delay(seconds: float):
	await get_tree().create_timer(seconds).timeout


# destroy the player on impact
func _on_area_entered(area):
	if area.get_collision_layer_value(2):
		area.take_damage()


func _on_visible_on_screen_notifier_2d_screen_exited():
	if get_parent() is PathFollow2D:
		get_parent().queue_free()
	else:
		queue_free()
