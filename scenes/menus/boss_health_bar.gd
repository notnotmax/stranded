extends TextureProgressBar

var max_hp: int = 100

func init(p_max_hp: int):
	max_hp = p_max_hp


func delay(seconds: float):
	await get_tree().create_timer(seconds, false).timeout


func _ready():
	value = 0
	modulate.a = 0
	position.y = 32


func appear(seconds: float):
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	var tween2 = create_tween().set_trans(Tween.TRANS_SINE)
	tween2.tween_property(self, "position:y", 12, 1)
	tween.tween_property(self, "modulate:a", 1, 1)
	tween.tween_property(self, "value", 100, max(seconds - 1, 1))


func disappear():
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "modulate:a", 0, 3)
	await delay(3)
	queue_free()


func update(p_health: int):
	value = float(p_health) / max_hp * 100
