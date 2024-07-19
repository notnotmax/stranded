extends Marker2D
class_name PlayerGun

@export var Bullet: PackedScene # blue
@export var Bullet2: PackedScene # green
@export var Bullet3: PackedScene # orange

var firing: bool = false
var cooldown: int = 0
var fire_rate: int = 15 # in 60ths of a second
var level: int = 0
# upgrade the gun to get to higher levels of firing
var FIRING_LEVELS: = [fire_1, fire_2, fire_3, fire_4, fire_5]


# Utility function. Usage: await delay(seconds)
func delay(seconds: float):
	await get_tree().create_timer(seconds, false).timeout


# Using a 
func _physics_process(_delta):
	if cooldown > 0:
		cooldown -= 1
	# shoot
	if cooldown <= 0:
		if firing:
			FIRING_LEVELS[level].call()
		cooldown += fire_rate


func enable():
	firing = true


func disable():
	firing = false


func upgrade():
	level += 1
	level = min(level, FIRING_LEVELS.size() - 1)


# downgrade by roughly half of the current level when the player gets hit
func downgrade():
	level = floor((level + 1) / 2.0)


func double_speed(duration: float):
	var temp = fire_rate
	fire_rate = floor(temp / 2.0)
	await delay(duration)
	fire_rate = temp


# one lv1 bullet - 10dmg
func fire_1():
	var bullet = Bullet.instantiate()
	bullet.init(
			global_position,
			20,
			Vector2.RIGHT
		)
	get_tree().current_scene.add_child(bullet)


# two lv1 bullets - 20dmg
func fire_2():
	var bullet = Bullet.instantiate()
	bullet.init(
			global_position + Vector2(0, -10),
			20,
			Vector2.RIGHT
		)
	get_tree().current_scene.add_child(bullet)
	var bullet2 = Bullet.instantiate()
	bullet2.init(
			global_position + Vector2(0, 10),
			20,
			Vector2.RIGHT
		)
	get_tree().current_scene.add_child(bullet2)


# 1 lv2 bullet and 2 lv1 bullets at a slight angle - 40dmg
func fire_3():
	var bullet = Bullet2.instantiate()
	bullet.init(
			global_position,
			20,
			Vector2.RIGHT
		)
	get_tree().current_scene.add_child(bullet)
	var bullet2 = Bullet.instantiate()
	bullet2.init(
			global_position,
			20,
			Vector2.RIGHT.rotated(deg_to_rad(-5))
		)
	get_tree().current_scene.add_child(bullet2)
	var bullet3 = Bullet.instantiate()
	bullet3.init(
			global_position,
			20,
			Vector2.RIGHT.rotated(deg_to_rad(5))
		)
	get_tree().current_scene.add_child(bullet3)


# 2 lv2, 2 lv1 bullets - 60dmg
func fire_4():
	var bullet = Bullet2.instantiate()
	bullet.init(
			global_position + Vector2(0, -10),
			20,
			Vector2.RIGHT
		)
	get_tree().current_scene.add_child(bullet)
	var bullet2 = Bullet2.instantiate()
	bullet2.init(
			global_position + Vector2(0, 10),
			20,
			Vector2.RIGHT
		)
	get_tree().current_scene.add_child(bullet2)
	var bullet3 = Bullet.instantiate()
	bullet3.init(
			global_position + Vector2(0, 10),
			20,
			Vector2.RIGHT.rotated(deg_to_rad(5))
		)
	get_tree().current_scene.add_child(bullet3)
	var bullet4 = Bullet.instantiate()
	bullet4.init(
			global_position + Vector2(0, -10),
			20,
			Vector2.RIGHT.rotated(deg_to_rad(-5))
		)
	get_tree().current_scene.add_child(bullet4)


# 1 lv3, 2 lv2, 2 lv1 bullets (spread) - 90dmg
func fire_5():
	var bullet = Bullet3.instantiate()
	bullet.init(
			global_position,
			20,
			Vector2.RIGHT
		)
	get_tree().current_scene.add_child(bullet)
	var bullet2 = Bullet2.instantiate()
	bullet2.init(
			global_position,
			20,
			Vector2.RIGHT.rotated(deg_to_rad(-5))
		)
	get_tree().current_scene.add_child(bullet2)
	var bullet3 = Bullet2.instantiate()
	bullet3.init(
			global_position,
			20,
			Vector2.RIGHT.rotated(deg_to_rad(5))
		)
	get_tree().current_scene.add_child(bullet3)
	var bullet4 = Bullet.instantiate()
	bullet4.init(
			global_position,
			20,
			Vector2.RIGHT.rotated(deg_to_rad(-10))
		)
	get_tree().current_scene.add_child(bullet4)
	var bullet5 = Bullet.instantiate()
	bullet5.init(
			global_position,
			20,
			Vector2.RIGHT.rotated(deg_to_rad(10))
		)
	get_tree().current_scene.add_child(bullet5)
