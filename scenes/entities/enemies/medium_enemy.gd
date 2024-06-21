extends Enemy
class_name MediumEnemy

@export var Bullet: PackedScene

func init_fighter(p_position: Vector2 = Vector2(0, 0), p_target: Node = Node.new()):
	super.init_enemy(p_position, p_target)


func _on_shooting_start_delay_timeout():
	shoot()


func shoot():
	if alive:
		fire_laser()


func fire_laser():
	$Laser.target_position = to_local(target.global_position).normalized() \
		* get_viewport_rect().size.x
	$Laser.set_firing(true)
	$Laser/LaserDuration.start()


func _on_laser_duration_timeout():
	$Laser.set_firing(false)


func die():
	$Laser.set_firing(false)
	super.die()
