extends Enemy
class_name Fighter2

@export var Bullet: PackedScene

func init_fighter(p_position: Vector2 = Vector2(0, 0), p_target: Node = Node.new()):
	super.init_enemy(p_position, p_target)

func shoot():
	if alive:
		var angle = get_vec_towards_player().rotated(-PI / 4)
		var delta = deg_to_rad(10)
		for i in range(10):
			var bullet = Bullet.instantiate()
			bullet.init_enemy_attack(
				self.global_position, 1, 2, angle.rotated(delta * i)
			)
			get_tree().current_scene.add_child(bullet)
