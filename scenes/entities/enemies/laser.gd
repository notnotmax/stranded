"""
Enemy laser. Fires a warning beam before shooting.
"""
extends ShapeCast2D
class_name Laser
signal ended

# shrapnel when asteroids are destroyed
@export var Bullet: PackedScene


# the target towards which the laser aims
var target: Vector2
# duration for which the laser fires (excluding warning shot)
var duration: float = 1
# maximum thickness of the deadly laser
var thickness: float = 10
# duration for the laser to widen until its max thickness
var widening_duration: float = 0.1
# true to destroy asteroids in its way
var destructive: bool = false


func _ready():
	set_physics_process(false)


func _physics_process(_delta):
	self.shape.size.y = max(1, $Line2D.width)
	var cast_point: Vector2 = target_position
	force_shapecast_update()
	if is_colliding():
		var collider = get_collider(0)
		if collider:
			var layer = collider.get_collision_layer()
			if destructive and layer == 32: # layer 6, asteroids
				var size = collider.health / 10
				for i in range(3 + size):
					var bullet = Bullet.instantiate()
					bullet.init(
						collider.global_position,
						randf_range(3, 5),
						0,
						Vector2.LEFT.rotated(randf_range(0, 2 * PI)),
					)
					get_tree().current_scene.add_child(bullet)
			# putting this at the back so can check asteroid health first
			collider.take_damage(999) # should instakill
		cast_point = target_position * \
			get_closest_collision_unsafe_fraction()
	$Line2D.points[1] = cast_point
	$Warning.points[1] = cast_point
	$GPUParticles2D2.position = cast_point


# show warning laser and start timer for deadly laser
func _fire():
	var tween = create_tween()
	tween.tween_property($Warning, "width", 1.5, 0.1)
	$WarningTimer.start() # timer to actually shoot deadly laser
	set_physics_process(true)

# disable laser, may cause visual issues if disabled too early
# due to tweens (untested)
func _stop_firing():
	$GPUParticles2D.emitting = false
	$GPUParticles2D2.emitting = false
	var tween = create_tween()
	tween.tween_property($Line2D, "width", 0, 0.1)
	set_collision_mask_value(2, false)
	set_collision_mask_value(6, false)
	set_collision_mask_value(9, false)
	ended.emit()
	set_physics_process(false)


func set_color(color: Color):
	$Line2D.default_color = color
	$GPUParticles2D.process_material.color = color
	$GPUParticles2D2.process_material.color = color


# when the warning timer runs out, fire the deadly laser
func _on_timer_timeout():
	$GPUParticles2D.emitting = true
	$GPUParticles2D2.emitting = true
	set_collision_mask_value(2, true)
	if destructive:
		set_collision_mask_value(6, true)
	set_collision_mask_value(9, true)
	var tween = create_tween()
	tween.tween_property($Warning, "width", 0, 0)
	tween.tween_property($Line2D, "width", thickness, widening_duration)
	tween.tween_property(self, "target_position", target, duration)
	$Duration.start()


# stops firing after a certain duration
func _on_duration_timeout():
	_stop_firing()


func sweep(p_from: Vector2, p_to: Vector2, p_duration: float):
	var from = p_from.normalized() * 1920
	var to = p_to.normalized() * 1920
	self.target = to
	self.duration = p_duration
	$Duration.wait_time = p_duration
	self.thickness = 10
	self.widening_duration = 0.1
	self.destructive = false
	
	# set initial position to sweep from
	target_position = from
	$Line2D.points[1] = from
	$Warning.points[1] = from
	# shoot
	_fire()


# sweep, but fires a thicker laser that destroys asteroids
func sweep_destructive(p_from: Vector2, p_to: Vector2, p_duration: float):
	var from = p_from.normalized() * 1920
	var to = p_to.normalized() * 1920
	self.target = to
	self.duration = p_duration
	$Duration.wait_time = p_duration
	self.thickness = 20
	self.widening_duration = 1.5
	self.destructive = true
	
	# set initial position to sweep from
	target_position = from
	$Line2D.points[1] = from
	$Warning.points[1] = from
	# shoot
	_fire()
