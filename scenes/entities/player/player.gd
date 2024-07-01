extends Area2D
@export var Bullet : PackedScene
signal on_damaged # player gets damaged
signal player_died # player dies

var can_move = true
var alive: bool = true
var lives: int = 3
var inverted_movement: bool = false
var is_invulnerable: bool = false
var is_firing: bool = false
# cooldown timer before next shot
var shot_cooldown: int = 0
# fire rate in 1/60ths of a second
var fire_rate: int = 6


# Called when the node enters the scene tree for the first time.
func _ready():
	# Lock the cursor to the center of the screen and hide it
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	# placeholder starting position
	position.x = 100
	position.y = 360
	$AnimatedSprite2D.play("default")


func _physics_process(_delta):
	if alive:
		# decrease shooting cooldown
		if shot_cooldown > 0:
			shot_cooldown -= 1
		# shoot
		if shot_cooldown <= 0:
			if is_firing:
				var bullet = Bullet.instantiate().with_params(
					$Marker2D.global_position,
					20,
					Vector2(1, 0),
					10
				)
				get_tree().current_scene.add_child(bullet)
			shot_cooldown += fire_rate


func _input(event):
	if can_move and alive:
		# Player movement
		if event is InputEventMouseMotion:
			var movement: Vector2 = event.relative
			if inverted_movement:
				movement = -movement
			position += movement
			position.x = clamp(position.x, 16, get_viewport_rect().size.x - 24)
			position.y = clamp(position.y, 16, get_viewport_rect().size.y - 16)
			# change movement sprite
			if movement.y >= 3:
				$AnimatedSprite2D.play("moving_down_fast")
			elif movement.y >= 1:
				$AnimatedSprite2D.play("moving_down_slow")
			elif movement.y >= -1:
				$AnimatedSprite2D.play("default")
			elif movement.y >= -3:
				$AnimatedSprite2D.play("moving_up_slow")
			else:
				$AnimatedSprite2D.play("moving_up_fast")
		
		# toggle fire mode
		elif event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT:
				is_firing = event.pressed


# death collision is handled by the enemy instance
func _on_area_entered(_area):
	pass


func _on_animated_sprite_2d_animation_finished():
	if !alive:
		player_died.emit()
		queue_free()


func take_damage():
	if not is_invulnerable:
		lives -= 1
		on_damaged.emit()
		if lives == 0:
			die()
		else:
			is_invulnerable = true
			$Invulnerability.show()
			$Invulnerability.play("explosion")
			$Invulnerability/InvulnerabilityTimer.start(3)
			$Invulnerability/InvulnerabilityFlash.start(0.25)


func _on_invulnerability_flash_timeout():
	if modulate.a == 1:
		modulate.a = 0.5
	else:
		modulate.a = 1


func _on_invulnerability_timer_timeout():
	$Invulnerability/InvulnerabilityFlash.stop()
	modulate.a = 1
	is_invulnerable = false


# enemy instances call this upon collision with player to kill them
func die():
	if alive:
		alive = false
		$AnimatedSprite2D.play("death")


func get_powerup(powerup):
	match powerup:
		Powerup.Types.SHIELD:
			$Shield.enable()
		Powerup.Types.LIFE_UP:
			lives += 1
			on_damaged.emit()


func _on_invulnerability_animation_finished():
	$Invulnerability.hide()
