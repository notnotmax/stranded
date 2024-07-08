"""
Sandbox level to test new features.
"""

extends Level
class_name DebugLevel

@export var fighter: PackedScene
@export var fighter2: PackedScene
@export var medium_enemy: PackedScene
@export var boss_enemy: PackedScene
@export var powerup_shield: PackedScene
@export var powerup_life: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	var boss = boss_enemy.instantiate()
	boss.init(Vector2(1000, 360), get_player())
	boss.move_on_path($Path2D, 1, 1)
