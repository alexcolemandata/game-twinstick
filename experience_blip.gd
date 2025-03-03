extends StaticBody2D

var player: CharacterBody2D
var motion: Vector2 = Vector2()
var move_speed = 800.0

	
func _physics_process(delta: float) -> void:
	if not player:
		return
	look_at(player.global_position)
	var diff = (player.global_position - global_position)
	motion = (diff.normalized() * move_speed / (2*diff.length()))
		
	move_and_collide(motion)


func _on_pickup_box_body_entered(body: Node2D) -> void:
	if body.has_method("gain_xp"):
		body.gain_xp()
		queue_free()
