extends Enemy
class_name Deathbomber

@export var Bullet: PackedScene

func init_deathbomber(p_position: Vector2 = Vector2(0, 0),
	p_target: Node = Node.new()):
	super.init_enemy(p_position, p_target)


func die():
	if alive:
		call_deferred("on_death")
		super.die()


func on_death():
	var angle = Vector2.RIGHT
	var incr = PI / 6
	for i in range(12):
		var bullet = Bullet.instantiate()
		bullet.init_enemy_attack(
			self.global_position, 5, 0, angle
		)
		get_tree().current_scene.add_child(bullet)
		angle = angle.rotated(incr)
