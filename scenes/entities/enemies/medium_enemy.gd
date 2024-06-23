extends Enemy
class_name MediumEnemy

@export var Bullet: PackedScene

func init(p_position: Vector2 = Vector2(0, 0), p_target: Node = Node.new(),
		p_start_delay: float = 1.0):
	super.init(p_position, p_target, p_start_delay)


func _on_shooting_start_delay_timeout():
	fire_laser()


func fire_laser():
	if alive:
		$Laser.sweep(
			get_vec_towards_player(),
			get_vec_towards_player().rotated(-PI / 6),
			5)


func _on_laser_ended():
	$Laser/LaserCooldown.start()


func _on_laser_cooldown_timeout():
	fire_laser()


func die():
	$Laser.set_firing(false)
	super.die()
