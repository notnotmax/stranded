extends Area2D
class_name Powerup
enum Types {NONE, SHIELD}

var speed: float = 3
@export var type: Types

# _init() does not work as a constructor, so this is a workaround
func init_powerup(p_position: Vector2 = Vector2(0, 0)) -> void:
	position = p_position


func _physics_process(delta):
	position += Vector2.LEFT * speed


func _on_area_entered(area):
	if area.get_collision_layer_value(2):
		area.get_powerup(type)
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
