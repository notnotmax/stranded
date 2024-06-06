extends Area2D

var alive: bool = true
var health: int = 30
var speed: float = 0
var direction: Vector2 = Vector2.ZERO


# Setter function to be chained after instantiation
func with_params(p_position: Vector2, p_speed: float,
	p_direction: Vector2):
	position = p_position
	speed = p_speed
	direction = p_direction.normalized()
	return self


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("default")


func _physics_process(_delta):
	position += direction * speed
	

# destroy the player on impact
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
		set_collision_layer_value(6, false)
		$AnimatedSprite2D.play("death")
