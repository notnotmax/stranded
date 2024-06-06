extends Area2D

@export var Bullet: PackedScene

var alive: bool = true
var health: int = 30
var speed: float = 0
var direction: Vector2 = Vector2.ZERO
var is_firing: bool = false
var shot_cooldown: int = 0
var fire_rate: int = 15


func with_params(p_position: Vector2, p_speed: float,
	p_direction: Vector2):
	position = p_position
	speed = p_speed
	direction = p_direction.normalized()
	return self


func _ready():
	$AnimatedSprite2D.play("default")


func _physics_process(_delta):
	position += direction * speed
	if alive:
		if shot_cooldown > 0:
			shot_cooldown -= 1
		if shot_cooldown <= 0:
			if is_firing:
				var bullet = Bullet.instantiate().with_params(
					position,
					3,
					Vector2(-1, 0)
				)
				owner.add_child(bullet)
			shot_cooldown += fire_rate


func _on_area_entered(area):
	if alive:
		if area.get_collision_layer_value(2):
			area.die()


func _on_animated_sprite_2d_animation_finished():
	if !alive:
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func damage(dmg):
	health -= dmg
	if health <= 0:
		die()


func die():
	if alive:
		alive = false
		set_collision_layer_value(3, false)
		$AnimatedSprite2D.play("death")


func set_firing(p_firing):
	is_firing = p_firing
