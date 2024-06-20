extends DestroyableObstacle
class_name Asteroid

var speed: float
var direction: Vector2

func init_asteroid(p_position: Vector2 = Vector2(0,0),
	p_speed: float = 0, p_direction: Vector2 = Vector2(0,0)):
	init_obstacle(p_position)
	speed = p_speed
	direction = p_direction
	

func _physics_process(_delta):
	position += direction * speed
