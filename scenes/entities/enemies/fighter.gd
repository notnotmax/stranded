"""
Most basic enemy type. Fragile and shoots one bullet at a time towards the player.
"""
extends Enemy
class_name Fighter

@export var Bullet: PackedScene

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
		$Gun.one_shot(target, 4, 2)


@onready var powerups = [powerup_weapon]
func on_death():
	if randf() < 0.1:
		drop_powerup(powerups.pick_random())


func die(get_score: bool = false):
	call_deferred("on_death")
	super.die(get_score)
