"""
Variant of fighter that does not shoot, but releases bullets upon death.
Intended to charge at the player.
"""
extends Enemy
class_name Deathbomber

@export var Bullet: PackedScene

func init(p_position: Vector2 = Vector2(0, 0), p_target: Node = Node.new(),
		p_start_delay: float = 1.0):
	super.init(p_position, p_target, p_start_delay)


func die():
	if alive:
		call_deferred("on_death")
		super.die()


func on_death():
	var angle = Vector2.RIGHT
	var incr = PI / 6
	for i in range(12):
		var bullet = Bullet.instantiate()
		bullet.init(
			self.global_position, 5, 0, angle
		)
		get_tree().current_scene.add_child(bullet)
		angle = angle.rotated(incr)
