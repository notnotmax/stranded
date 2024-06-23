extends Node2D

@export var Bullet: PackedScene

func get_vec_to_target(target: Node):
	return global_position.direction_to(target.global_position)
	

func one_shot(target: Node, speed: float, acceleration: float):
	var bullet = Bullet.instantiate()
	bullet.init(
		global_position,
		speed,
		acceleration, 
		get_vec_to_target(target)
	)
	get_tree().current_scene.add_child(bullet)


# Fires a spread of bullets in a cone with a deviation from the center
# of spread_degree.
func spread_shot(target: Node, speed: float, acceleration: float,
		spread_degree: float, spacing_degree: float):
	var angle = get_vec_to_target(target)
	var curr_delta = 0
	var delta = deg_to_rad(spacing_degree)
	while curr_delta <= spread_degree:
		var bullet = Bullet.instantiate()
		bullet.init(
			global_position,
			speed,
			acceleration,
			angle.rotated(deg_to_rad(curr_delta))
		)
		get_tree().current_scene.add_child(bullet)
		var bullet2 = Bullet.instantiate()
		bullet2.init(
			global_position,
			speed,
			acceleration,
			angle.rotated(-deg_to_rad(curr_delta))
		)
		get_tree().current_scene.add_child(bullet2)
		curr_delta += spacing_degree
