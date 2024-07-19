extends Area2D
class_name Bullet

var speed: float = 0
var direction: Vector2 = Vector2.ZERO
var damage: int = 10


func with_params(p_position: Vector2, p_speed: float,
	p_direction: Vector2, p_damage: int):
	position = p_position
	speed = p_speed
	direction = p_direction.normalized()
	damage = p_damage
	return self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	position += direction * speed


# damage enemy or environmental obstacles on impact
func _on_area_entered(area):
	area.take_damage(damage)
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
