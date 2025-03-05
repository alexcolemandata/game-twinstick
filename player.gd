extends CharacterBody2D

var level = 1
var xp = 0
var movespeed = 500
const GUN = preload("res://gun.tscn")
var num_guns = 1
var guns = []


func set_fire_rate(per_second: float) -> void:
	%PrimaryFireRate.wait_time = 1 / per_second

func _ready() -> void:
	%LevelLabel.text = str(level)
	spawn_guns()
	pass
	
func spawn_guns() -> void:
	for gun in guns:
		gun.queue_free()
	
	guns = []
	var is_odd_num_guns = (num_guns % 2) == 1
	for n in range(1, (1 + num_guns - int(is_odd_num_guns))/2 + 1):
		var l_gun = GUN.instantiate()
		add_child(l_gun)
		l_gun.position = Vector2(15, 15 * n)
		guns.append(l_gun)
		
		var r_gun = GUN.instantiate()
		add_child(r_gun)
		r_gun.position = Vector2(15, -15 * n)
		guns.append(r_gun)
	
	if is_odd_num_guns:
		var middle_gun = GUN.instantiate()
		add_child(middle_gun)
		middle_gun.position = Vector2(15, 0)
		guns.append(middle_gun)
		
	return
	
func _physics_process(delta: float) -> void:
	var motion: Vector2 = Vector2()

	if Input.is_action_pressed("up"):
		motion.y += -1
		
	if Input.is_action_pressed("down"):
		motion.y += 1
		
	if Input.is_action_pressed("left"):
		motion.x += -1
		
	if Input.is_action_pressed("right"):
		motion.x += 1

	if Input.is_action_pressed("laser"):
		laser()

	velocity = motion.normalized() * movespeed
	move_and_slide()
	look_at(get_global_mouse_position())
	
func laser():
	%Laser.fire()


	
func take_damage() -> void:
	print("ow!")

func _on_hit_box_body_entered(body: Node2D) -> void:
	if "Enemy" in body.name:
		take_damage()
		
func level_up():
	AudioManager.create_2d_audio_at_location(
		global_position,
		SoundEffect.SOUND_EFFECT_TYPE.ON_LEVEL_UP
	)
	level += 1
	xp = 0
	%XPBar.value = 0
	%LevelLabel.text = str(level)
	$LevelUpBurst.emitting = true
	
	if level == 2:
		set_fire_rate(1.5)
	elif level > 10:
		return
	elif (level % 2) == 1:
		num_guns = (level / 2) + 1
		spawn_guns()
	else:
		set_fire_rate(1 + (level / 2))

func gain_xp() -> void:
	AudioManager.create_2d_audio_at_location(
		global_position, SoundEffect.SOUND_EFFECT_TYPE.ON_XP_PICKUP
	)
	xp += 1
	if xp >= %XPBar.max_value:
		level_up()
	else:
		%XPBar.value = xp

func fire_main_guns() -> void:
	for gun in guns:
		gun.fire()

func _on_primary_fire_rate_timeout() -> void:
	fire_main_guns()
