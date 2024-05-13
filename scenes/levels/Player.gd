extends Area2D
signal hit

var player_size = 30  # radius in pixels


# Called when the node enters the scene tree for the first time.
func _ready():
	position.x = 50


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y = clamp(
		get_viewport().get_mouse_position().y,
		player_size / 2,
		get_viewport_rect().size.y - player_size / 2
		)


func _on_body_entered(body):
	hit.emit()
	$Hurtbox.set_deferred("disabled", true)
