extends Node2D

@export var Bullet: PackedScene


func delay(seconds: float):
	await get_tree().create_timer(seconds, false).timeout


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


# Version of spread_shot with direction argument instead of target.
func spread_shot_direction(direction: Vector2, speed: float,
		acceleration: float, spread_degree: float, spacing_degree: float):
	var angle = direction
	var curr_delta = 0
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


# forward spread shot in the shape of an arrow
func arrow_shot(target: Node, spread_degree: float, bullet_count: int):
	var angle = get_vec_to_target(target)
	while bullet_count > 0:
		var delta = randf_range(-spread_degree, spread_degree)
		var bullet = Bullet.instantiate()
		bullet.init(
			global_position,
			10 - 5 * abs(delta)/ 30,
			0,
			angle.rotated(deg_to_rad(delta))
		)
		get_tree().current_scene.add_child(bullet)
		bullet_count -= 1
