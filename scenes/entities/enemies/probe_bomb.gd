extends Enemy
class_name ProbeBomb

@export var Bullet: PackedScene
var armed: bool = false


func _on_shooting_start_delay_timeout():
	arm()


func arm():
	armed = true
	$AnimatedSprite2D.play("armed")
	for i in range(6):
		await delay(0.5)
		$AnimatedSprite2D.speed_scale += 0.5
	die(false)


func explode():
	if armed:
		armed = false
		$Gun.spread_shot_direction(
			Vector2.LEFT.rotated(randf_range(0, 2 * PI)),
			5,
			1,
			360,
			20
		)


func die(get_score: bool = false):
	if armed:
		call_deferred("explode")
	super.die(get_score)
