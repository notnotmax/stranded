"""
Warning beam for enemy shots. Appears as a white line.
"""
extends Line2D
class_name WarningBeam

var duration: float

func _ready():
	modulate.a = 0


func init(p_direction: Vector2, p_duration: float):
	points[1] = p_direction.normalized() * 1920
	duration = max(0.1, p_duration) # minimum duration of 0.1s


func appear():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1, 0.1)
	await Global.delay(duration)
	hide()
	call_deferred("queue_free")
