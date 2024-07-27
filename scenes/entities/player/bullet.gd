extends Area2D
class_name PlayerBullet

@export var damage: int

var speed: float
var direction: Vector2

func init(p_position: Vector2 = Vector2(0, 0), p_speed: float = 0,
		p_direction: Vector2 = Vector2.RIGHT):
	position = p_position
	speed = p_speed
	direction = p_direction.normalized()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	position += direction * speed


# damage enemy or environmental obstacles on impact
func _on_area_entered(area):
	area.take_damage(damage)
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
