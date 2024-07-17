extends Obstacle
class_name DestroyableObstacle

var alive: bool = true
@export var health: int
@export var points: int

func init(p_position: Vector2 = Vector2(0, 0)) -> void:
	super.init(p_position)


func _on_area_entered(area):
	if alive:
		super._on_area_entered(area)


func _on_death_animation_animation_finished():
	if !alive:
		queue_free()


func add_score(score):
	get_tree().current_scene.add_score(score)


func take_damage(damage: int):
	health -= damage
	if health <= 0:
		die(true)


func die(get_score: bool = false):
	if alive:
		alive = false
		set_collision_layer_value(3, false)
		set_collision_layer_value(6, false)
		$AnimatedSprite2D.hide()
		$DeathAnimation.show()
		$DeathAnimation.play()
		if get_score:
			add_score(points)
