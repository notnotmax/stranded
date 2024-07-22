"""
Enemy projectile attack. A larger bullet that releases smaller bullets
along its path, and does not disappear upon hitting the player.
"""
extends EnemyProjectile
class_name EnemyComet

@export var Bullet: PackedScene
var rate: int # frames per bullet


func init(p_position: Vector2 = Vector2(0,0),
	p_speed: float = 0, p_acc: float = 0, p_direction: Vector2 = Vector2(-1,0)):
	super.init(p_position, p_speed, p_acc, p_direction)
	rate = ceil(30 / speed)
	rotation = get_angle_to(p_position + p_direction) + PI


var frame = 0
func _physics_process(delta):
	super._physics_process(delta)
	if frame >= rate:
		var bullet = Bullet.instantiate()
		bullet.init(
			global_position,
			randf_range(3, 5),
			0,
			self.direction.rotated(PI).rotated(randf_range(-PI / 4, PI / 4))
			)
		get_tree().current_scene.add_child(bullet)
		frame = 0
	frame += 1


func _on_area_entered(area):
	if area.get_collision_layer_value(2):
		area.take_damage()
		queue_free()
