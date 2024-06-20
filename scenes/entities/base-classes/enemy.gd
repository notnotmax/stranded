extends DestroyableObstacle
class_name Enemy

# seconds before beginning to fire
@export var initial_firing_delay: float
# seconds between shots
@export var fire_rate: float
# target node to fire at, usually the player
var target: Node

@onready var shooting_start_delay = $ShootingStartDelay
@onready var shooting_timer = $ShootingTimer
var path_follower: PathFollow2D


func init_enemy(p_position: Vector2 = Vector2(0, 0), p_target: Node = Node.new()):
	path_follower = PathFollow2D.new()
	path_follower.rotates = false
	super.init_obstacle(p_position)
	target = p_target


func get_vec_towards_player() -> Vector2:
	return (target.global_position - self.global_position).normalized()


func _ready():
	shooting_start_delay.wait_time = initial_firing_delay
	shooting_timer.wait_time = fire_rate
	shooting_start_delay.start()


func _on_shooting_start_delay_timeout():
	shooting_timer.start()
	shoot()


func _on_shooting_timer_timeout():
	shoot()


func _on_visible_on_screen_notifier_2d_screen_exited():
	path_follower.queue_free()
	queue_free()


func change_parent(new_parent: Node):
	if get_parent():
		get_parent().remove_child(self)
	new_parent.add_child(self)


func move_by(vector: Vector2, duration: float):
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, 'position', position + vector, duration)


func move_to(dest: Vector2, duration: float):
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, 'position', dest, duration)


func move_on_path(path: Path2D, duration: float, endpoint: int = 1):
	# remove the offset caused by local position
	position = Vector2(0, 0)
	var path_follower = PathFollow2D.new()
	path_follower.rotates = false
	path.add_child(path_follower)
	change_parent(path_follower)
	
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(path_follower, 'progress_ratio', endpoint, duration)


func shoot():
	pass
