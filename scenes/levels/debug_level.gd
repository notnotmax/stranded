"""
Sandbox level to test new features.
"""

extends Level
class_name DebugLevel

@export var fighter: PackedScene
@export var medium_enemy: PackedScene
@export var powerup_shield: PackedScene

var fighter1

# Called when the node enters the scene tree for the first time.
func _ready():
	fighter1 = fighter.instantiate()
	fighter1.init_fighter(Vector2(1000, 360), get_player())
	add_child(fighter1)
	fighter1.move_by(Vector2(50,50), 1)
	
	var medium = medium_enemy.instantiate()
	medium.init_fighter(Vector2(1000, 180), get_player())
	add_child(medium)
	
	var shield = powerup_shield.instantiate()
	shield.init_powerup(Vector2(1200, 360))
	add_child(shield)


#func _on_timer_timeout():
	#fighter1.move_on_path($Path2D, 1, 1)
#
#
#func _on_timer_2_timeout():
	#fighter1.move_by(Vector2(100,0), 1)
#
#
#func _on_timer_3_timeout():
	#fighter1.move_on_path($Path2D, 1, 1)
