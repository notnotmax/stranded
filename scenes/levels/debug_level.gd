"""
Sandbox level to test new features.
"""

extends Level
class_name DebugLevel

@export var fighter: PackedScene
@export var powerup_shield: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	var fighter1 = fighter.instantiate()
	fighter1.init_fighter(Vector2(1250, 360), get_player())
	add_child(fighter1)
	
	var shield = powerup_shield.instantiate()
	shield.init_powerup(Vector2(1200, 360))
	add_child(shield)
