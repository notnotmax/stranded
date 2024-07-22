extends Enemy
class_name BossEnemy

@export var medium_enemy: PackedScene
@export var HealthBar: PackedScene
@export var SpiralProbe: PackedScene
@export var bomb_probe: PackedScene

const CENTER: Vector2 = Vector2(1100, 360)
var invulnerable: bool = true
var health_bar # HealthBar instance
var attack_counter = 0
var NORMAL_ATTACKS = [normal_1, normal_2, normal_3, normal_4, normal_5]
var SPECIAL_ATTACKS = [special_1, special_2, special_3]
var time_bonus: int = 0


func start_bossfight():
	health_bar = HealthBar.instantiate()
	health_bar.init(health)
	position = Vector2(1400, 360)
	move_to(CENTER, start_delay)
	get_tree().current_scene.add_child(health_bar)
	health_bar.appear(start_delay)
	await delay(start_delay)
	time_bonus = 30000
	start_time_bonus()


var is_timing: bool = false
func start_time_bonus():
	if not is_timing:
		is_timing = true
		while alive and time_bonus > 0:
			await delay(1)
			time_bonus -= 100


func take_damage(damage: int):
	if not invulnerable:
		super.take_damage(damage)
		health_bar.update(health)


func on_death():
	health_bar.disappear()
	add_score(time_bonus)


func die(get_score: bool = false):
	call_deferred("on_death")
	super.die(get_score)


func _on_shooting_start_delay_timeout():
	invulnerable = false
	_on_cooldown_timeout()


var normals = []
var specials = []
func _on_cooldown_timeout():
	if attack_counter < 3:
		if attack_counter == 0:
			normals = NORMAL_ATTACKS.duplicate()
			normals.shuffle()
		var attack = normals.pop_front()
		await attack.call()
		attack_counter += 1
		$Cooldown.start(1)
	else:
		if len(specials) == 0:
			specials = SPECIAL_ATTACKS.duplicate()
			specials.shuffle()
		var attack = specials.pop_front()
		await attack.call()
		attack_counter = 0
		$Cooldown.start(5)

# spreadshots from random positions
func normal_1():
	for i in range(3):
		await move_to(Vector2(position.x, randi_range(120, 600)), 1)
		$Gun.spread_shot_direction(Vector2.LEFT, 6, 0, 90, 10)
		$Gun.spread_shot_direction(Vector2.LEFT, 7, 0, 90, 10)
		$Gun.spread_shot_direction(Vector2.LEFT, 8, 0, 90, 10)
	await delay(0.5)
	strafe()

# spray in player's general direction while moving up/down
func normal_2():
	# move to edge that the boss is closer to and strafe across the screen
	if position.y < 360:
		await move_to(Vector2(position.x, 120), 2)
		move_to(Vector2(position.x, 600), 7)
	else:
		await move_to(Vector2(position.x, 600), 2)
		move_to(Vector2(position.x, 120), 7)
	
	for i in range(50):
		$Gun.one_shot_direction(
			get_vec_towards_player().rotated(
					deg_to_rad(randf_range(-30, 30))),
			5, 1)
		$Gun.one_shot_direction(
			get_vec_towards_player().rotated(
					deg_to_rad(randf_range(-30, 30))),
			5, 1)
		await delay(0.1)
	await delay(0.5)
	strafe()

# 3 comet shots aimed at the player with spaced timing between aiming
func normal_3():
	var shots = 3
	for i in range(shots):
		$Gun.comet_shot(
			get_vec_towards_player(), 10, 0, shots - i)
		await delay(1)

# 3 arrow shots
func normal_4():
	await arrow_shots(3)

# asteroid-destroying laser
func normal_5():
	$DestructiveLaser.sweep(
			Vector2.LEFT, Vector2.LEFT, 5
		)
	await delay(2)
	if global_position.y < 360:
		await move_by(Vector2.DOWN * 200, 5)
	else:
		await move_by(Vector2.UP * 200, 5)


# lasers, spreadshots, arrows
func special_1():
	await move_to(CENTER, 3)
	twin_laser()
	multi_spread_shot(6)
	await delay(1)
	await arrow_shots(5)
	$Gun.comet_shot(
		Vector2.LEFT, 30, 0, 1
	)
	await delay(1)
	drop_powerup(powerup_weapon)


# 3 spiral probes on the right area of the screen
# semi-random spawning in 3 designated areas to avoid the rare case
# of all 3 clumping up (boring)
func special_2():
	strafe(CENTER, Vector2(0, 200), 10)
	var sp = SpiralProbe.instantiate()
	sp.init(global_position, target, 3, 6, 0.3, 10, 15)
	get_tree().current_scene.add_child(sp)
	var sp2 = SpiralProbe.instantiate()
	sp2.init(global_position, target, 3, 5, 0.2, 5, 15)
	get_tree().current_scene.add_child(sp2)
	var sp3 = SpiralProbe.instantiate()
	sp3.init(global_position, target, 3, 5, 0.2, -5, 15)
	get_tree().current_scene.add_child(sp3)
	sp.move_to(Vector2(randi_range(600, 900), randi_range(300, 420)), 10)
	sp2.move_to(Vector2(randi_range(900, 1200), randi_range(100, 300)), 10)
	sp3.move_to(Vector2(randi_range(900, 1200), randi_range(420, 620)), 10)
	await delay(15)

# summons a ring of bomb probes that drift to random positions
func special_3():
	var num = 12
	for i in range(num):
		var bp = bomb_probe.instantiate()
		bp.init(global_position, target, 8)
		get_tree().current_scene.add_child(bp)
		bp.move_to(
			global_position + Vector2.LEFT.rotated(i * 2 * PI / num) * 100,
			1, true
		)
		var lambda = func():
			bp.move_to(Vector2(randi_range(300, 1000), randi_range(100, 620)),
			5, true)
		bp.call_delayed(lambda, 1 + num * 0.1)
		await delay(0.1)
	await delay(10)


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
