extends GPUParticles2D

func fire() -> void:
	emitting = true
	await get_tree().create_timer(20).timeout
	queue_free()
	
