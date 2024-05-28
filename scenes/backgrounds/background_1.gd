extends ParallaxBackground

var speed = 1
var scroll = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	scroll -= speed
	$Stars.motion_offset = Vector2(scroll * 0.05, 0)
	$Dust.motion_offset = Vector2(scroll * 0.05, 0)
	$PlanetsSmall.motion_offset = Vector2(scroll * 0.15, 0)
	
