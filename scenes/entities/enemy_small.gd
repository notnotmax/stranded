extends Area2D

var alive = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("default")


func _on_area_entered(_area):
	if alive:
		alive = false
		set_collision_layer_value(3, false)
		$AnimatedSprite2D.play("death")


func _on_animated_sprite_2d_animation_finished():
	if !alive:
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
