extends Area2D
class_name Powerup
enum Types {NONE, SHIELD, LIFE_UP}

var speed: float = 3
@export var type: Types


func init(p_position: Vector2 = Vector2(0, 0)) -> void:
	position = p_position


func _physics_process(_delta):
	position += Vector2.LEFT * speed


func _on_area_entered(area):
	if area.get_collision_layer_value(2):
		area.get_powerup(type)
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
