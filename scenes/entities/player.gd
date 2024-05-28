extends Area2D
@export var Bullet : PackedScene

var alive: bool = true
var is_firing: bool = false
# cooldown timer before next shot
var shot_cooldown = 0
# shoot every (fire_rate / 60) seconds
var fire_rate = 15

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
				var bullet = Bullet.instantiate()
				owner.add_child(bullet)
				bullet.transform = $Gun.global_transform
			shot_cooldown += fire_rate

func _input(event):
	if alive:
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
				$AnimatedSprite2D.play("moving_up_fast")
		
		# toggle fire mode
		elif event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT:
				is_firing = event.pressed


func _on_area_entered(area):
	if alive:
		# layer 4 for enemies, pickupable items in future layers
		if area.get_collision_layer() == 4:
			alive = false
			$AnimatedSprite2D.play("death")


func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "death":
		queue_free()
