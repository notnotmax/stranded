extends Area2D

var speed = 500
# dmg variable for killing obstacles with health
var damage = 10


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += transform.x * speed * delta


# damage enemy obstacles on impact
func _on_area_entered(area):
	area.damage(damage)
	queue_free()
