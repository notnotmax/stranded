"""
Enemy laser. Fires a warning beam before shooting.
"""
extends ShapeCast2D
class_name Laser
signal ended

# shrapnel when asteroids are destroyed
@export var Bullet: PackedScene


# collides with these layers
var COLLISION_MASKS = [2, 9]
# default maximum thickness of the deadly laser
var thickness: float = 10


func _ready():
	set_physics_process(false)


func _physics_process(_delta):
	# align the collision shape with the visual laser
	self.shape.size.y = max(1, $Line2D.width)
	var collision_point: Vector2 = target_position
	force_shapecast_update()
	if is_colliding():
		var collider = get_collider(0)
		if collider:
			collider.take_damage()
		collision_point = target_position * \
			get_closest_collision_unsafe_fraction()
	$Line2D.points[1] = collision_point
	$Warning.points[1] = collision_point
	$GPUParticles2D2.position = collision_point


# show warning laser and start timer for deadly laser
func _fire(from: Vector2, to: Vector2, duration: float):
	# set initial position to sweep from
	target_position = from
	$Line2D.points[1] = from
	$Warning.points[1] = from
	
	# fire warning shot
	var warning_duration = 1
	set_physics_process(true)
	var tween = create_tween()
	tween.tween_property($Warning, "width", 1.5, 0.1)
	await Global.delay(warning_duration)
	
	# turn on deadly laser and sweep towards target
	$GPUParticles2D.emitting = true
	$GPUParticles2D2.emitting = true
	for layer in COLLISION_MASKS:
		set_collision_mask_value(layer, true)
	var charge_time = thickness / 10.0
	tween = create_tween()
	tween.tween_property($Warning, "width", 0, 0)
	tween.tween_property($Line2D, "width", thickness, charge_time)
	tween.tween_property(self, "target_position", to, duration)
	await Global.delay(charge_time + duration)
	
	# stop firing the laser
	_stop_firing()


# disable laser immediately, may cause visual issues if done
# too early (untested)
func _stop_firing():
	$GPUParticles2D.emitting = false
	$GPUParticles2D2.emitting = false
	var tween = create_tween()
	tween.tween_property($Line2D, "width", 0, 0.1)
	for layer in COLLISION_MASKS:
		set_collision_mask_value(layer, false)
	ended.emit()
	set_physics_process(false)


func set_color(color: Color):
	$Line2D.default_color = color
	$GPUParticles2D.process_material.color = color
	$GPUParticles2D2.process_material.color = color


func sweep(from: Vector2, to: Vector2, duration: float):
	await _fire(from.normalized() * 1920, to.normalized() * 1920, duration)
