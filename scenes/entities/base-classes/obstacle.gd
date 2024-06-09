extends Area2D
class_name Obstacle

# _init() does not work as a constructor, so this is a workaround
func init_obstacle(p_position: Vector2 = Vector2(0, 0)) -> void:
	position = p_position


# destroy the player on impact
func _on_area_entered(area):
	if area.get_collision_layer_value(2):
		area.die()


func _on_visible_on_screen_notifier_2d_screen_exited():
	if get_parent() is PathFollow2D:
		get_parent().queue_free()
	else:
		queue_free()
