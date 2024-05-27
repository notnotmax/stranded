extends ParallaxBackground

var speed = 1
var scroll = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scroll -= speed
	$Stars.motion_offset = Vector2(scroll * 0.05, 0)
	$Dust.motion_offset = Vector2(scroll * 0.05, 0)
	$PlanetsSmall.motion_offset = Vector2(scroll * 0.15, 0)
	
