"""
Base enemy class that handles basic collisions and death.
Also provides simple movement functions.
"""
extends DestroyableObstacle
class_name Enemy
signal death

@export var powerup_shield: PackedScene
@export var powerup_health: PackedScene
@export var powerup_weapon: PackedScene
@export var powerup_speed: PackedScene


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
	randomize()
	shooting_start_delay.wait_time = start_delay
	shooting_start_delay.start()


# Called after a delay to give time for enemies to move into position.
func _on_shooting_start_delay_timeout():
	pass


# Despawns when out of screen.
func _on_visible_on_screen_notifier_2d_screen_exited():
	path_follower.queue_free()
	queue_free()


func death_signal():
	death.emit()


func die(get_score: bool = false):
	if alive:
		call_deferred("death_signal")
		super.die(get_score)


func drop_powerup(powerup):
	if powerup:
		var p = powerup.instantiate()
		p.init(global_position)
		get_tree().current_scene.add_child(p)


# Custom set_parent function to properly reparent regardless whether or not
# the child already has a parent
func set_parent(parent: Node, child: Node):
	if child.get_parent():
		child.get_parent().remove_child(child)
	parent.add_child(child)


# Slowly move up and down to make enemy ships look more natural
func strafe(center: Vector2 = global_position, delta: Vector2 = Vector2(0, 10),
		duration: float = 3.0):
	stop_strafing()
	var start = center - delta
	var end = center + delta
	
	strafe_tween = create_tween().set_trans(Tween.TRANS_SINE).set_loops()
	strafe_tween.tween_property(self, "global_position", start, duration)
	strafe_tween.tween_property(self, "global_position", end, duration)


# Stops this instance from strafing
func stop_strafing():
	if strafe_tween:
		strafe_tween.kill()


# Moves this instance according to the given direction vector.
func move_by(vector: Vector2, duration: float, p_strafe: bool = false):
	stop_strafing()
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, 'position', position + vector, duration)
	await delay(duration + 0.5)
	if p_strafe:
		strafe()


# Moves this instance to the given coordinates.
func move_to(dest: Vector2, duration: float, p_strafe: bool = false):
	stop_strafing()
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, 'position', dest, duration)
	await delay(duration)
	if p_strafe:
		strafe()


# Moves on the path exactly as visually described. Will teleport to the start
# of the path.
func move_on_path(path: Path2D, duration: float, endpoint: float = 1,
		p_strafe: bool = false):
	stop_strafing()
	# remove the offset caused by local position
	position = Vector2(0, 0)
	# reset for reuse
	path_follower.progress_ratio = 0
	set_parent(path, path_follower)
	set_parent(path_follower, self)
	
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(path_follower, 'progress_ratio', endpoint, duration)
	await delay(duration)
	if p_strafe:
		strafe()


# Moves this instance off-screen towards the right to despawn.
func exit(duration: float):
	stop_strafing()
	move_to(Vector2(1400, position.y), duration)


func exit_after(p_delay: float, movement_duration: float):
	await delay(p_delay)
	exit(movement_duration)
