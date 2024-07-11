extends Enemy
class_name BossEnemy

@export var HealthBar: PackedScene
@export var SpiralProbe: PackedScene

var invulnerable: bool = true
var health_bar # HealthBar instance
var attack_counter = 0
var NORMAL_ATTACKS = [normal_1, normal_2]
var SPECIAL_ATTACKS = [special_1, special_2]


func start_bossfight():
	health_bar = HealthBar.instantiate()
	health_bar.init(health)
	position = Vector2(1400, 360)
	move_to(Vector2(1000, 360), 3, true)
	get_tree().current_scene.add_child(health_bar)
	health_bar.appear(start_delay)


func take_damage(damage: int):
	if not invulnerable:
		super.take_damage(damage)
		health_bar.update(health)


func on_death():
	health_bar.disappear()


func die():
	call_deferred("on_death")
	super.die()


func _on_shooting_start_delay_timeout():
	invulnerable = false
	_on_cooldown_timeout()


func _on_cooldown_timeout():
	if attack_counter < 3:
		await NORMAL_ATTACKS[randi() % len(NORMAL_ATTACKS)].call()
		attack_counter += 1
		$Cooldown.start(3)
	else:
		await SPECIAL_ATTACKS[randi() % len(SPECIAL_ATTACKS)].call()
		attack_counter = 0
		$Cooldown.start(5)

# spreadshots from random positions
func normal_1():
	for i in range(3):
		await move_to(Vector2(position.x, randi_range(120, 600)), 1)
		$Gun.spread_shot_direction(Vector2.LEFT, 6, 0, 90, 10)
		$Gun.spread_shot_direction(Vector2.LEFT, 8, 0, 90, 10)
		$Gun.spread_shot_direction(Vector2.LEFT, 10, 0, 90, 10)
	await delay(0.5)
	strafe()

# spray in player's general direction while moving down
func normal_2():
	# move to edge that the boss is closer to and strafe across the screen
	if position.y < 360:
		await move_to(Vector2(position.x, 120), 1)
		move_to(Vector2(position.x, 600), 7)
	else:
		await move_to(Vector2(position.x, 600), 1)
		move_to(Vector2(position.x, 120), 7)
	
	for i in range(100):
		$Gun.one_shot_direction(
			get_vec_towards_player().rotated(
					deg_to_rad(randf_range(-30, 30))),
			5, 1)
		$Gun.one_shot_direction(
			get_vec_towards_player().rotated(
					deg_to_rad(randf_range(-30, 30))),
			5, 1)
		await delay(0.05)
	await delay(0.5)
	strafe()

# 2 lasers, spreadshots, arrows
func special_1():
	await move_to(Vector2(1000, 360), 1)
	twin_laser()
	multi_spread_shot(6)
	await delay(1)
	await arrow_shots(5)
	$Cooldown.start(5)

# spiral probes
func special_2():
	for i in range(3):
		var sp = SpiralProbe.instantiate()
		sp.init(
			global_position, target, 1, 5, 0.2, 5 + i, 10
		)
		get_tree().current_scene.add_child(sp)
		sp.move_to(Vector2(randi_range(800, 1200), randi_range(20, 700)), 3)
	await delay(5)

func multi_spread_shot(rounds):
	if not alive:
		return
	for i in range(rounds):
		$Gun.spread_shot_direction(Vector2.LEFT,
			5, 1, 50, 10)
		await delay(0.3)
		$Gun.spread_shot_direction(Vector2.LEFT.rotated(deg_to_rad(5)),
			5, 1, 50, 10)
		await delay(0.3)


func arrow_shots(rounds):
	if not alive:
		return
	for i in range(rounds):
		$Gun.arrow_shot(target, 2.5, 30)
		await delay(1)


func twin_laser():
	if not alive:
		return
	$Laser.sweep(
		Vector2.LEFT.rotated(deg_to_rad(45)),
		Vector2.LEFT.rotated(deg_to_rad(5)),
		5)
	$Laser2.sweep(
		Vector2.LEFT.rotated(deg_to_rad(-45)),
		Vector2.LEFT.rotated(deg_to_rad(-5)),
		5)
	await delay(6)
