"""
Spherical enemy that spawns a spiral of bullets while active.
When exhausted (after a duration), falls towards the player like an asteroid.
"""
extends Enemy
class_name ProbeSpiral

@export var Bullet: PackedScene
@export var PowerupShield: PackedScene

var firing: bool = true
# the degrees by which the angle is incremented per shot
var angle_delta_deg: float
# delay in seconds between shots (affects 'spin speed')
var fire_rate: float
# number of arms in the spiral
var arms: int
# shoot bullets for this amount of time before stopping
var duration: float
# default params for spawned bullets, can be modified
var bullet_speed: float = 3
var bullet_accel: float = 1


func init(p_position: Vector2 = Vector2(0, 0), p_target: Node = Node.new(),
		p_start_delay: float = 1.0, p_angle_delta_deg: float = 0,
		p_fire_rate: float = 0.25, p_arms: int = 1, p_duration: float = 5.0):
	super.init(p_position, p_target, p_start_delay)
	angle_delta_deg = p_angle_delta_deg
	fire_rate = p_fire_rate
	arms = p_arms
	duration = p_duration


func _ready():
	super._ready()
	set_physics_process(false)


func set_bullet_params(p_speed: float, p_accel: float):
	bullet_speed = p_speed
	bullet_accel = p_accel


var speed = 0
# when active, makes the probe fall to the left
func _physics_process(delta):
	position += Vector2.LEFT * speed
	speed += 1.5 * delta


func _on_shooting_start_delay_timeout():
	firing = true
	fire()


func _on_duration_timeout():
	firing = false
	$AnimatedSprite2D.play("inactive")
	await delay(1)
	set_physics_process(true)


func fire():
	$Duration.start(duration)
	var main_direction = Vector2.LEFT
	while firing:
		main_direction = main_direction.rotated(deg_to_rad(angle_delta_deg))
		for i in range(arms):
			var direction = main_direction.rotated(i * 2 * PI / arms)
			var bullet = Bullet.instantiate()
			bullet.init(
				self.global_position,
				bullet_speed,
				bullet_accel,
				direction
			)
			get_tree().current_scene.add_child(bullet)
		await delay(fire_rate)


func on_death():
	if randf() < 0.25:
		var shield = PowerupShield.instantiate()
		shield.init(global_position)
		get_tree().current_scene.add_child(shield)


func die():
	if alive:
		call_deferred("on_death")
		super.die()
