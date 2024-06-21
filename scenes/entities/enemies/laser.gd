extends RayCast2D

var is_firing: bool = false

func _ready():
	is_firing = false
	set_collision_mask_value(2, false)


func _physics_process(_delta):
	var cast_point: Vector2 = target_position
	force_raycast_update()
	if is_colliding():
		cast_point = to_local(get_collision_point())
	$Line2D.points[1] = cast_point
	$Warning.points[1] = cast_point
	
	var collider = get_collider()
	if collider:
		collider.take_damage()


func appear():
	var tween = create_tween()
	tween.tween_property($Warning, "width", 3.0, 0.1)
	$Timer.start()


func _on_timer_timeout():
	set_collision_mask_value(2, true)
	var tween = create_tween()
	tween.tween_property($Warning, "width", 0, 0)
	tween.tween_property($Line2D, "width", 10.0, 0.5)


func disappear():
	var tween = create_tween()
	tween.tween_property($Line2D, "width", 0, 0.1)
	set_collision_mask_value(2, false)


func set_firing(value):
	is_firing = value
	if is_firing:
		appear()
	else:
		disappear()
	set_physics_process(is_firing)


func set_target(target: Vector2):
	target_position = target
	$Line2D.points[1] = target
	$Warning.points[1] = target
