extends DestroyableObstacle
class_name Asteroid

var speed: float = 0
var direction: Vector2 = Vector2(0, 0)

func init(p_position: Vector2 = Vector2(0, 0), p_speed: float = 0,
	p_direction: Vector2 = Vector2(0, 0)):
	super.init(p_position)
	speed = p_speed
	direction = p_direction
	

func _physics_process(_delta):
	position += direction * speed
