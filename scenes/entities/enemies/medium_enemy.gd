extends Enemy
class_name MediumEnemy

@export var Bullet: PackedScene
var firing_bullets: bool = false
var bullets_cooldown: float = 2.0
var firing_laser: bool = true
var laser_cooldown: float = 5.0


func init(p_position: Vector2 = Vector2(0, 0), p_target: Node = Node.new(),
		p_start_delay: float = 1.0):
	super.init(p_position, p_target, p_start_delay)


func _on_shooting_start_delay_timeout():
	fire()


func fire():
	if firing_bullets:
		fire_bullets()
	elif firing_laser:
		fire_laser()


func start_cooldown(seconds: float):
	$Cooldown.wait_time = seconds
	$Cooldown.start()


func _on_cooldown_timeout():
	fire()


func fire_bullets():
	if alive and firing_bullets:
		$Gun.spread_shot(target, 1, 2, 90, 10)
		await delay(0.2)
		$Gun.spread_shot(target, 1, 2, 90, 10)
		await delay(0.2)
		$Gun.spread_shot(target, 1, 2, 90, 10)
		start_cooldown(bullets_cooldown)


func fire_laser():
	if alive and firing_laser:
		var direction = [1, -1][randi() % 2]
		$Laser.sweep(
			get_vec_towards_player(),
			get_vec_towards_player().rotated(direction * PI / 12),
			5)


func _on_laser_ended():
	$Gun.spread_shot(target, 1, 2, 90, 10)
	start_cooldown(laser_cooldown)


func die():
	$Laser.set_firing(false)
	super.die()

# Enemy switches to bullets when player is in close range
func _on_detector_area_entered(_area):
	firing_bullets = true
	firing_laser = false


func _on_detector_area_exited(_area):
	firing_bullets = false
	firing_laser = true
