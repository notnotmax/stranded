extends Area2D
signal hit

var player_sprite_move_up = load("res://assets/ship.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	# Lock the cursor to the center of the screen and hide it
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	position.x = 1280 / 2
	position.y = 720 / 2

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
		if event.relative.y > 4:
			$Sprite.frame = 1
		elif event.relative.y > 0:
			$Sprite.frame = 3
		elif event.relative.y == 0:
			$Sprite.frame = 5
		elif event.relative.y > -2:
			$Sprite.frame = 7
		else:
			$Sprite.frame = 9
