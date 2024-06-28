extends ParallaxBackground

var speed = 1
var scroll = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	scroll -= speed
	$Stars.motion_offset = Vector2(scroll * 0.05, 0)
	$Dust.motion_offset = Vector2(scroll * 0.05, 0)
	$PlanetsSmall.motion_offset = Vector2(scroll * 0.15, 0)


# Moves the background back to its initial position and pauses movement.
func reset():
	set_physics_process(false)
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property($Stars, "motion_offset", Vector2(0, 0), 1)
	tween.tween_property($Dust, "motion_offset", Vector2(0, 0), 1)
	tween.tween_property($PlanetsSmall, "motion_offset", Vector2(0, 0), 1)
