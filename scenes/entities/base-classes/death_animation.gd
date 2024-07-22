extends AnimatedSprite2D

func init(p_position: Vector2, p_scale: float = 2):
	position = p_position
	scale.x = p_scale * 2
	scale.y = p_scale * 2


func _on_animation_finished():
	queue_free()
