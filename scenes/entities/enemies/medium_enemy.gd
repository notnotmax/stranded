extends Enemy
class_name MediumEnemy

@export var Bullet: PackedScene
var firing_bullets: bool = false
var firing_laser: bool = true

func init(p_position: Vector2 = Vector2(0, 0), p_target: Node = Node.new(),
		p_start_delay: float = 1.0):
	super.init(p_position, p_target, p_start_delay)


func _on_shooting_start_delay_timeout():
	fire_laser()


func fire_bullets():
	if alive and firing_bullets:
		var angle = get_vec_towards_player().rotated(-PI / 4)
		var delta = deg_to_rad(10)
		for i in range(10):
			var bullet = Bullet.instantiate()
			bullet.init(
				self.global_position, 1, 2, angle.rotated(delta * i)
			)
			get_tree().current_scene.add_child(bullet)


func fire_laser():
	if alive and firing_laser:
		var direction = [1, -1][randi() % 2]
		$Laser.sweep(
			get_vec_towards_player(),
			get_vec_towards_player().rotated(direction * PI / 12),
			5)


func _on_laser_ended():
	$Laser/LaserCooldown.start()


func _on_laser_cooldown_timeout():
	fire_laser()


func die():
	$Laser.set_firing(false)
	super.die()


func _on_detector_area_entered(area):
	firing_bullets = true
	firing_laser = false


func _on_detector_area_exited(area):
	firing_bullets = false
	firing_laser = true
