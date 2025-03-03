extends RigidBody2D

func fire(from: CharacterBody2D, speed: int) -> void:
	global_position = from.global_position
	rotation_degrees = from.rotation_degrees
	apply_impulse(Vector2(speed, 0).rotated(rotation), Vector2())
	
	await get_tree().create_timer(10).timeout
	queue_free()
