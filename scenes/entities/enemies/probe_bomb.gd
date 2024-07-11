extends Enemy
class_name ProbeBomb

@export var Bullet: PackedScene


func _on_shooting_start_delay_timeout():
	explode()


func explode():
	$AnimatedSprite2D.play("armed")
	for i in range(6):
		await delay(0.5)
		$AnimatedSprite2D.speed_scale += 0.5
	spawn_bullets()
	die(false)


func spawn_bullets():
	$Gun.spread_shot_direction(
		Vector2.LEFT.rotated(randf_range(0, 2 * PI)),
		5,
		1,
		360,
		20
	)
