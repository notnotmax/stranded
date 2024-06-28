"""
Base enemy class that handles basic collisions and death.
Also provides simple movement functions.
"""
extends DestroyableObstacle
class_name Enemy


# target node to fire at, usually the player
var target: Node
# reusable PathFollow2D to follow Path2D nodes
var path_follower: PathFollow2D
# one-time use because the timer node is not ready during init()
var start_delay: float = 1.0
@onready var shooting_start_delay = $ShootingStartDelay
# tween used for minor strafing
@onready var strafe_tween: Tween


# Pseudo-constructor
func init(p_position: Vector2 = Vector2(0, 0), p_target: Node = Node.new(),
		p_start_delay: float = 1.0):
	path_follower = PathFollow2D.new()
	path_follower.rotates = false
	super.init(p_position)
	target = p_target
	start_delay = p_start_delay


# Returns the vector pointing towards the player from this instance's global
# position.
func get_vec_towards_player() -> Vector2:
	return (target.global_position - self.global_position)


func _ready():
	shooting_start_delay.wait_time = start_delay
	shooting_start_delay.start()


# Called after a delay to give time for enemies to move into position.
func _on_shooting_start_delay_timeout():
	pass


# Despawns when out of screen.
func _on_visible_on_screen_notifier_2d_screen_exited():
	path_follower.queue_free()
	queue_free()


# Custom set_parent function to properly reparent regardless whether or not
# the child already has a parent
func set_parent(parent: Node, child: Node):
	if child.get_parent():
		child.get_parent().remove_child(child)
	parent.add_child(child)


# Makes the instance move back and forth between two points.
# By default, slowly move up and down to make enemy ships look more natural
# and further the illusion of moving through space
func strafe(start: Vector2 = position - Vector2(0, 10),
		end: Vector2 = position + Vector2(0, 10), duration: float = 3):
	move_to(start, duration / 2.0)
	await delay(duration / 2.0)
	strafe_tween = create_tween().set_trans(Tween.TRANS_SINE).set_loops()
	strafe_tween.tween_property(self, "position", end, duration).from(start)
	strafe_tween.tween_property(self, "position", start, duration).from(end)


# Stops this instance from strafing
func stop_strafing():
	if strafe_tween:
		strafe_tween.kill()


# Moves this instance according to the given direction vector.
func move_by(vector: Vector2, duration: float):
	stop_strafing()
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, 'position', position + vector, duration)


# Moves this instance to the given coordinates.
func move_to(dest: Vector2, duration: float):
	stop_strafing()
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, 'position', dest, duration)


# Moves on the path exactly as visually described. Will teleport to the start
# of the path.
func move_on_path(path: Path2D, duration: float, endpoint: int = 1):
	stop_strafing()
	# remove the offset caused by local position
	position = Vector2(0, 0)
	# reset for reuse
	path_follower.progress_ratio = 0
	set_parent(path, path_follower)
	set_parent(path_follower, self)
	
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(path_follower, 'progress_ratio', endpoint, duration)


# Moves this instance off-screen towards the right to despawn.
func exit(duration: float):
	move_to(Vector2(1400, position.y), duration)
