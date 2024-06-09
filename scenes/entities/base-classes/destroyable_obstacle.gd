extends Obstacle
class_name DestroyableObstacle

var alive: bool = true
@export var health: int


func _on_area_entered(area):
	if alive:
		super._on_area_entered(area)


func _on_animated_sprite_2d_animation_finished():
	if !alive:
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
