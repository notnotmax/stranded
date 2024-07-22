"""
Sandbox level to test new features.
"""

extends Level
class_name DebugLevel

@export var asteroid: PackedScene
@export var fighter: PackedScene
@export var fighter2: PackedScene
@export var medium_enemy: PackedScene
@export var boss_enemy: PackedScene
@export var probe_bomb: PackedScene
@export var probe_spiral: PackedScene
@export var powerup_shield: PackedScene
@export var powerup_life: PackedScene
@export var powerup_weapon: PackedScene
@export var powerup_speed: PackedScene

var spawnpoint: Vector2 = Vector2(1000, 360) # spawn for testing

# Called when the node enters the scene tree for the first time.
func _ready():
	var boss = boss_enemy.instantiate()
	boss.init(Vector2(0, 0), get_player(), 5)
	add_child(boss)
	boss.start_bossfight()
	
	for i in range(3):
		var ast = asteroid.instantiate()
		ast.init(
			spawnpoint + i * 50 * Vector2.LEFT,
			1,
			Vector2.LEFT
		)
		add_child(ast)
	#
	#var ps = probe_spiral.instantiate()
	#ps.init(
		#Vector2(1000, 360), get_player(), 2, 5, 0.1, 6, 1
	#)
	#add_child(ps)
	#var lambda = func():
		#ps.exit(5)
	#ps.call_delayed(lambda, 2)
	
	for i in range(5):
		var atkup = powerup_weapon.instantiate()
		atkup.init(spawnpoint)
		add_child(atkup)
		await delay(2)
	
	var spdup = powerup_speed.instantiate()
	spdup.init(spawnpoint)
	add_child(spdup)
