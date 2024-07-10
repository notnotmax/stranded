extends TextureProgressBar

var max_hp: int = 100

func init(p_max_hp: int):
	max_hp = p_max_hp


func appear():
	pass
	#get_tree().current_scene.add_child(self)


func disappear():
	queue_free()


func update(p_health: int):
	print(p_health)
	print(max_hp)
	
	value = float(p_health) / max_hp * 100
	print(value)
