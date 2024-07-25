"""
Sandbox level to test new features.
"""

extends Level
class_name DebugLevel

# environmental obstacles (asteroids)
@export var asteroid: PackedScene
# enemies
@export var probe_bomb: PackedScene
@export var probe_spiral: PackedScene
# powerups
@export var powerup_shield: PackedScene
@export var powerup_life: PackedScene
@export var powerup_weapon: PackedScene
@export var powerup_speed: PackedScene

var spawnpoint: Vector2 = Vector2(1000, 360) # spawn for testing

# Called when the node enters the scene tree for the first time.
func _ready():
	#var boss = boss_enemy.instantiate()
	#boss.init(Vector2(0, 0), get_player(), 5)
	#add_child(boss)
	#boss.start_bossfight()
	
	test_all()


func test_all():
	var f1 = fighter.instantiate()
	f1.init(Vector2(1000, 50), get_player(), 1)
	add_child(f1)
	var f2 = fighter2.instantiate()
	f2.init(Vector2(1000, 100), get_player(), 1)
	add_child(f2)
	var db = deathbomber.instantiate()
	db.init(Vector2(1000, 150), get_player(), 1)
	add_child(db)
	var med = medium_enemy.instantiate()
	med.init(Vector2(1000, 200), get_player(), 1)
	add_child(med)
	var sp = probe_spiral.instantiate()
	sp.init(Vector2(1000, 250), get_player(), 1, 3, 0.5, 15, 5)
	add_child(sp)
	var bp = probe_bomb.instantiate()
	bp.init(Vector2(1000, 300), get_player(), 1)
	add_child(bp)
	var boss = boss_enemy.instantiate()
	boss.init(Vector2(1000, 350), get_player(), 5)
	add_child(boss)
	boss.start_bossfight()
	var pow_shield = powerup_shield.instantiate()
	pow_shield.init(Vector2(1000, 400))
	add_child(pow_shield)
	var pow_life = powerup_life.instantiate()
	pow_life.init(Vector2(1000, 450))
	add_child(pow_life)
	var pow_weapon = powerup_weapon.instantiate()
	pow_weapon.init(Vector2(1000, 500))
	add_child(pow_weapon)
	var pow_speed = powerup_speed.instantiate()
	pow_speed.init(Vector2(1000, 550))
	add_child(pow_speed)
	
