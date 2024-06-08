extends Area2D

@export var Bullet: PackedScene

var alive: bool = true
var health: int = 10
# parent PathFollow2D node used to tween movement
var path_follow: PathFollow2D = PathFollow2D.new()
# time to finish its path
var duration: float
# target to shoot at
var target: Node


func with_params(p_path: Path2D, p_duration: float, p_target: Node,
		p_firing_delay: float, p_fire_rate: float):
	# disable rotation when path rotates e.g. strafing
	path_follow.rotates = false
	p_path.add_child(path_follow)
	path_follow.add_child(self)
	duration = p_duration
	target = p_target
	$ShootingStartDelay.wait_time = p_firing_delay
	$ShootingTimer.wait_time = p_fire_rate
	return self


func _ready():
	$AnimatedSprite2D.play("default")
	$ShootingStartDelay.start()


func _on_area_entered(area):
	if alive:
		if area.get_collision_layer_value(2):
			area.die()


func _on_animated_sprite_2d_animation_finished():
	if !alive:
		path_follow.queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	path_follow.queue_free()


func _on_shooting_start_delay_timeout():
	shoot() # should start shooting immediately
	$ShootingTimer.start()


func _on_shooting_timer_timeout():
	shoot()


func take_damage(dmg):
	if alive:
		health -= dmg
		if health <= 0:
			die()


func die():
	if alive:
		alive = false
		set_collision_layer_value(3, false)
		$AnimatedSprite2D.play("death")


func move():
	var tween: Tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(path_follow, 'progress_ratio', 1, duration)


func shoot():
	if alive:
		var bullet = Bullet.instantiate().with_params(
			self.global_position,
			7,
			(target.global_position - self.global_position).normalized(),
		)
		get_tree().current_scene.add_child(bullet)
