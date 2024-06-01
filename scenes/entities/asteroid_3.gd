extends Area2D

var alive = true
var health = 50
var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("default")


func _physics_process(delta):
	position -= velocity
	

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
