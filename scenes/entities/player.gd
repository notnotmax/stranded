extends Area2D
signal hit

# Called when the node enters the scene tree for the first time.
func _ready():
	# Lock the cursor to the center of the screen and hide it
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	position.x = 1280 / 2
	position.y = 720 / 2
	$AnimatedSprite2D.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	# Player movement
	if event is InputEventMouseMotion:
		position += event.relative
		position.x = clamp(position.x, 16, get_viewport_rect().size.x - 24)
		position.y = clamp(position.y, 16, get_viewport_rect().size.y - 16)
		# change movement sprite
		if event.relative.y >= 3:
			$AnimatedSprite2D.play("moving_down_fast")
		elif event.relative.y >= 1:
			$AnimatedSprite2D.play("moving_down_slow")
		elif event.relative.y >= -1:
			$AnimatedSprite2D.play("default")
		elif event.relative.y >= -3:
			$AnimatedSprite2D.play("moving_up_slow")
		else:
			print("ASD")
			$AnimatedSprite2D.play("moving_up_fast")
