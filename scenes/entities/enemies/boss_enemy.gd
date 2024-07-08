extends Enemy
class_name BossEnemy

var attack_counter = 0
var NORMAL_ATTACKS = [twin_laser]
var SPECIAL_ATTACKS = [special_1]


func _on_shooting_start_delay_timeout():
	$Cooldown.start(1)


func _on_cooldown_timeout():
	if attack_counter < 1:
		await NORMAL_ATTACKS[randi() % len(NORMAL_ATTACKS)].call()
		attack_counter += 1
	else:
		await SPECIAL_ATTACKS[0].call()
		attack_counter = 0
	$Cooldown.start(5)

func normal_1():
	twin_laser()


func special_1():
	twin_laser()
	multi_spread_shot(6)
	await delay(1)
	await arrow_shots(3)
	$Cooldown.start(5)


# Duration: 0.6 * rounds
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
		await delay(1.5)


func twin_laser():
	if not alive:
		return
	var direction = [1, -1][randi() % 2]
	$Laser.sweep(
		Vector2.LEFT.rotated(deg_to_rad(45)),
		Vector2.LEFT.rotated(deg_to_rad(5)),
		5)
	$Laser2.sweep(
		Vector2.LEFT.rotated(deg_to_rad(-45)),
		Vector2.LEFT.rotated(deg_to_rad(-5)),
		5)
	await delay(5)
