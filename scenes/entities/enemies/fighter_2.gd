"""
Slightly more powerful version of the basic fighter. Shoots a spread of bullets
rather than a single bullet, and slightly more sturdy.
"""
extends Enemy
class_name Fighter2


func init(p_position: Vector2 = Vector2(0, 0), p_target: Node = Node.new(),
		p_start_delay: float = 1.0):
	super.init(p_position, p_target, p_start_delay)


func _on_shooting_start_delay_timeout():
	shoot()
	$Cooldown.start()


func _on_cooldown_timeout():
	shoot()


func shoot():
	if alive:
		$Gun.spread_shot(target, 1, 2, 50, 10)


func on_death():
	var rng = randf()
	if rng < 0.3:
		drop_powerup(powerup_weapon)
	elif rng < 0.5:
		drop_powerup(powerup_speed)


func die(get_score: bool = false):
	if alive:
		call_deferred("on_death")
		super.die(get_score)
