extends Marker2D
class_name PlayerGun

@export var Bullet: PackedScene # blue
@export var Bullet2: PackedScene # green
@export var Bullet3: PackedScene # orange

var firing: bool = false
var cooldown: int = 0
var fire_rate: int = 6
var level: int = 0
# upgrade the gun to get to higher levels of firing
var FIRING_LEVELS: = [fire_1, fire_2, fire_3]


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


func fire_1():
	var bullet = Bullet.instantiate()
	bullet.init(
			global_position,
			20,
			Vector2.RIGHT
		)
	get_tree().current_scene.add_child(bullet)


func fire_2():
	var bullet = Bullet2.instantiate()
	bullet.init(
			global_position,
			20,
			Vector2.RIGHT
		)
	get_tree().current_scene.add_child(bullet)


func fire_3():
	var bullet = Bullet3.instantiate()
	bullet.init(
			global_position,
			20,
			Vector2.RIGHT
		)
	get_tree().current_scene.add_child(bullet)



