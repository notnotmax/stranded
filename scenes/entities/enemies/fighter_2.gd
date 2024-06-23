"""
Slightly more powerful version of the basic fighter. Shoots a spread of bullets
rather than a single bullet, and slightly more sturdy.
"""
extends Enemy
class_name Fighter2

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
		var angle = get_vec_towards_player().rotated(-PI / 4)
		var delta = deg_to_rad(10)
		for i in range(10):
			var bullet = Bullet.instantiate()
			bullet.init(
				self.global_position, 1, 2, angle.rotated(delta * i)
			)
			get_tree().current_scene.add_child(bullet)
