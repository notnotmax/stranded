extends Marker2D
class_name PlayerGun

@export var Bullet: PackedScene

var firing: bool = false
var cooldown: int = 0
var fire_rate: int = 6


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Using a 
func _physics_process(_delta):
	if cooldown > 0:
		cooldown -= 1
	# shoot
	if cooldown <= 0:
		if firing:
			fire()
		cooldown += fire_rate


func enable():
	firing = true


func disable():
	firing = false


func fire():
	var bullet = Bullet.instantiate().with_params(
			global_position,
			20,
			Vector2(1, 0),
			10
		)
	get_tree().current_scene.add_child(bullet)
