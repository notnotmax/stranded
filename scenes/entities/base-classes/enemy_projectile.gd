"""
Base class for projectile-type enemy attacks.
"""
extends Obstacle
class_name EnemyProjectile

var speed: float
var acceleration: float
var direction: Vector2

func init(p_position: Vector2 = Vector2(0,0),
	p_speed: float = 0, p_acc: float = 0, p_direction: Vector2 = Vector2(-1,0)):
	super.init(p_position)
	speed = p_speed
	acceleration = p_acc
	direction = p_direction.normalized()


func _physics_process(delta):
	position += direction * speed
	speed += acceleration * delta


func _on_area_entered(area):
	if area.get_collision_layer_value(2):
		area.take_damage()
		queue_free()
