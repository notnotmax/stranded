extends Area2D
signal life_change # change in player's life count
signal player_died # player dies

var can_move = true
var alive: bool = true
var lives: int = 3
var inverted_movement: bool = false
var is_invulnerable: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	# Lock the cursor to the center of the screen and hide it
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	# placeholder starting position
	position.x = 100
	position.y = 360
	$AnimatedSprite2D.play("default")
	$PlayerGun.reset()


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
				if event.pressed:
					$PlayerGun.enable()
				else:
					$PlayerGun.disable()


# death collision is handled by the enemy instance
func _on_area_entered(_area):
	pass


func _on_animated_sprite_2d_animation_finished():
	if !alive:
		player_died.emit()
		queue_free()


func take_damage(_damage: int = 0):
	if not is_invulnerable:
		lives -= 1 ## TODO
		life_change.emit()
		$PlayerGun.downgrade()
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
			if lives < 5:
				lives += 1
				lives = min(5, lives) # lives are capped at 5
			else:
				get_tree().current_scene.add_score(10000)
			life_change.emit()
		Powerup.Types.WEAPON_UPGRADE:
			$PlayerGun.upgrade()
		Powerup.Types.ATTACK_SPEED:
			$PlayerGun.double_speed(10)


func _on_invulnerability_animation_finished():
	$Invulnerability.hide()


# used to leave a level upon completion
func exit():
	can_move = false
	$PlayerGun.disable()
	is_invulnerable = true
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position:x", 1400, 5)
	await get_tree().create_timer(5, false).timeout
