extends Area2D
class_name DestroyableObstacle

var alive: bool = true
@export var health: int


# _init() does not work as a constructor, so this is a workaround
func init_obstacle(p_position: Vector2 = Vector2(0, 0)) -> void:
	position = p_position


# destroy the player on impact
func _on_area_entered(area):
	if alive:
		if area.get_collision_layer_value(2):
			area.die()


func _on_animated_sprite_2d_animation_finished():
	if !alive:
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	if get_parent() is PathFollow2D:
		get_parent().queue_free()
	else:
		queue_free()


func take_damage(damage):
	health -= damage
	if health <= 0:
		die()


func die():
	if alive:
		alive = false
		set_collision_layer_value(3, false)
		set_collision_layer_value(6, false)
		$AnimatedSprite2D.play("death")
