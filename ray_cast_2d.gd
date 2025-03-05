extends RayCast2D


func _process(_delta) -> void:
	
	var pos = target_position
	if is_colliding():
		pos = get_collision_point()
		$Line2D.set_point_position(1, $Line2D.to_local(pos))
	else:
		$Line2D.points[1] = pos
