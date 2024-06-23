"""
Enemy laser. Fires a warning beam before shooting.
"""
extends RayCast2D
signal ended

var is_firing: bool = false
# the target towards which the laser aims
var target: Vector2
# duration for which it shoots before cooldown
var duration: int

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


# Turns the laser on/off
func set_firing(value):
	is_firing = value
	if is_firing:
		# show warning laser
		var tween = create_tween()
		tween.tween_property($Warning, "width", 1.5, 0.1)
		$Timer.start() # timer to actually shoot deadly laser
	else:
		# disable laser
		$GPUParticles2D.emitting = false
		var tween = create_tween()
		tween.tween_property($Line2D, "width", 0, 0.1)
		set_collision_mask_value(2, false)
		ended.emit()
	set_physics_process(is_firing)


# fires the deadly laser
func _on_timer_timeout():
	$GPUParticles2D.emitting = true
	set_collision_mask_value(2, true)
	var tween = create_tween()
	tween.tween_property($Warning, "width", 0, 0)
	tween.tween_property($Line2D, "width", 10.0, 0.1)
	tween.tween_property(self, "target_position", target, duration)
	$Duration.start()


# stops firing after a certain duration
func _on_duration_timeout():
	set_firing(false)


func sweep(p_from: Vector2, p_to: Vector2, p_duration: float):
	var from = p_from.normalized() * 1920
	var to = p_to.normalized() * 1920
	self.target = to
	self.duration = p_duration
	$Duration.wait_time = p_duration
	# set initial position to sweep from
	target_position = from
	$Line2D.points[1] = from
	$Warning.points[1] = from
	# shoot
	set_firing(true)
