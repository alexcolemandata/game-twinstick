extends Polygon2D

var bullet_speed = 2000
const BULLET = preload("res://Bullet.tscn")

func _process(_delta) -> void:
	$RayCast2D.rotation = rotation

func fire():
	var bullet = BULLET.instantiate()
	AudioManager.create_2d_audio_at_location(
		global_position,
		SoundEffect.SOUND_EFFECT_TYPE.ON_FIRE
	)
	get_parent().get_parent().add_child(bullet)
	bullet.fire(self, bullet_speed)
