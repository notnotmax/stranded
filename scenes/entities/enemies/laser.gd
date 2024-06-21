extends RayCast2D

var is_firing: bool = false:
	set(value):
		is_firing = value
		if is_firing:
			appear()
		else:
			disappear()
		set_physics_process(is_firing)


func _ready():
	is_firing = false


func _physics_process(_delta):
	var cast_point: Vector2 = target_position
	force_raycast_update()
	if is_colliding():
		cast_point = to_local(get_collision_point())
	$Line2D.points[1] = cast_point
	$Warning.points[1] = cast_point
	
	var collider = get_collider()
	if collider and enabled:
		collider.take_damage()


func appear():
	var tween = create_tween()
	tween.tween_property($Warning, "width", 3.0, 0.1)
	$Timer.start()


func _on_timer_timeout():
	var tween = create_tween()
	enabled = true
	tween.tween_property($Warning, "width", 0, 0)
	tween.tween_property($Line2D, "width", 10.0, 0.3)


func disappear():
	var tween = create_tween()
	tween.tween_property($Line2D, "width", 0, 0.1)
	enabled = false


func set_firing(value):
	is_firing = value
