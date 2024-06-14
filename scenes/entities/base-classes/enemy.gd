extends DestroyableObstacle
class_name Enemy

# seconds before beginning to fire
@export var initial_firing_delay: float
# seconds between shots
@export var fire_rate: float
# target node to fire at, usually the player
var target: Node

@onready var ShootingStartDelay = $ShootingStartDelay
@onready var ShootingTimer = $ShootingTimer


func init_enemy(p_position: Vector2 = Vector2(0, 0), p_target: Node = Node.new()):
	super.init_obstacle(p_position)
	target = p_target


func get_vec_towards_player() -> Vector2:
	return (target.global_position - self.global_position).normalized()


func _ready():
	ShootingStartDelay.wait_time = initial_firing_delay
	ShootingTimer.wait_time = fire_rate


func _on_shooting_start_delay_timeout():
	ShootingTimer.start()
	shoot()


func _on_shooting_timer_timeout():
	shoot()


func _on_visible_on_screen_notifier_2d_screen_exited():
	if get_parent() is PathFollow2D:
		get_parent().queue_free()
	else:
		queue_free()


func move(path: Path2D, duration: float, endpoint: int = 1):
	var path_follower = PathFollow2D.new()
	path_follower.rotates = false
	path.add_child(path_follower)
	path_follower.add_child(self)
	
	# tween to move enemy along the path
	var tween: Tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(path_follower, 'progress_ratio', endpoint, duration)


func shoot():
	pass
