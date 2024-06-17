"""
Sandbox level to test new features.
"""

extends Level
class_name DebugLevel

@export var fighter: PackedScene
@export var powerup_shield: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	var fighter = fighter.instantiate()
	fighter.init_fighter(Vector2(1250, 360), get_player())
	add_child(fighter)
	
	var shield = powerup_shield.instantiate()
	shield.init_powerup(Vector2(1200, 360))
	add_child(shield)
