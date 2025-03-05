extends RigidBody2D

const IS_PROJECTILE = true

var prev_position: Vector2

func _process(_delta) -> void:
	if prev_position:
		$Line2D.set_point_position(0, to_local(global_position))
		$Line2D.set_point_position(1, to_local(prev_position))
	prev_position = global_position

func fire(from: Node2D, speed: int) -> void:
	global_position = from.global_position
	global_rotation = from.global_rotation
	apply_impulse(Vector2(speed, 0).rotated(rotation), Vector2())
	
	await get_tree().create_timer(4).timeout
	fade_out_and_die()

func destroy_by_environment(environment: Node2D) -> void:
	queue_free()

func fade_out_and_die() -> void:
	$AnimationPlayer.play("fade_out")
	await get_tree().create_timer(0.5).timeout
	queue_free()
