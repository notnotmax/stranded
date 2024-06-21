extends Enemy
class_name Fighter

@export var Bullet: PackedScene

func init_fighter(p_position: Vector2 = Vector2(0, 0), p_target: Node = Node.new()):
	super.init_enemy(p_position, p_target)

func _on_shooting_start_delay_timeout():
	shoot()
	$Cooldown.start()

func shoot():
	if alive:
		var bullet = Bullet.instantiate()
		bullet.init_enemy_attack(
			self.global_position, 4, 2, get_vec_towards_player()
		)
		get_tree().current_scene.add_child(bullet)


func _on_cooldown_timeout():
	shoot()
