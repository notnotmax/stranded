extends DestroyableObstacle
class_name Enemy

# seconds before beginning to fire
@export var initial_firing_delay: float
# seconds between shots
@export var fire_rate: float
# target node to fire at, usually the player
var target: Node

@onready var shooting_start_delay = $ShootingStartDelay
var path_follower: PathFollow2D


func init_enemy(p_position: Vector2 = Vector2(0, 0), p_target: Node = Node.new()):
	path_follower = PathFollow2D.new()
	path_follower.rotates = false
	super.init_obstacle(p_position)
	target = p_target


func get_vec_towards_player() -> Vector2:
	return (target.global_position - self.global_position)


func _ready():
	shooting_start_delay.wait_time = initial_firing_delay
	shooting_start_delay.start()


func _on_shooting_start_delay_timeout():
	pass


func _on_visible_on_screen_notifier_2d_screen_exited():
	path_follower.queue_free()
	queue_free()


func set_parent(parent: Node, child: Node):
	if child.get_parent():
		child.get_parent().remove_child(child)
	parent.add_child(child)


func move_by(vector: Vector2, duration: float):
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, 'position', position + vector, duration)


func move_to(dest: Vector2, duration: float):
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, 'position', dest, duration)


# Moves on the path exactly as visually described. Will teleport to the start
# of the path.
func move_on_path(path: Path2D, duration: float, endpoint: int = 1):
	# remove the offset caused by local position
	position = Vector2(0, 0)
	# reset for reuse
	path_follower.progress_ratio = 0
	set_parent(path, path_follower)
	set_parent(path_follower, self)
	
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(path_follower, 'progress_ratio', endpoint, duration)


func shoot():
	pass
