"""
Sandbox level to test new features.
"""

extends Level
class_name DebugLevel

@export var fighter: PackedScene
@export var fighter2: PackedScene
@export var medium_enemy: PackedScene
@export var boss_enemy: PackedScene
@export var ProbeBomb: PackedScene
@export var probe_spiral: PackedScene
@export var powerup_shield: PackedScene
@export var powerup_life: PackedScene

var spawnpoint: Vector2 = Vector2(1000, 360) # spawn for testing

# Called when the node enters the scene tree for the first time.
func _ready():
	#var boss = boss_enemy.instantiate()
	#boss.init(Vector2(0, 0), get_player(), 5)
	#add_child(boss)
	#boss.start_bossfight()
	
	var pb = ProbeBomb.instantiate()
	pb.init(
		spawnpoint, get_player(), 1
	)
	add_child(pb)
	
	#var ps = probe_spiral.instantiate()
	#ps.init(
		#Vector2(1000, 360), get_player(), 2, 5, 0.1, 6, 1
	#)
	#add_child(ps)
