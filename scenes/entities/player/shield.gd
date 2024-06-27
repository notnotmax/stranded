extends Area2D


func enable():
	$GPUParticles2D.emitting = true
	set_collision_layer_value(2, true)
	$Timer.start()


func disable():
	$GPUParticles2D.emitting = false
	set_collision_layer_value(2, false)


func _on_timer_timeout():
	disable()


func take_damage():
	$Timer.stop()
	disable()
