extends CharacterBody2D

var level = 1
var xp = 0
var movespeed = 500
var bullet_speed = 2000
const BULLET = preload("res://Bullet.tscn")

func _ready() -> void:
	%LevelLabel.text = str(level)
	pass
	
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

	if Input.is_action_just_pressed("fire"):
		fire()
		
	if Input.is_action_pressed("laser"):
		laser()

	velocity = motion.normalized() * movespeed
	move_and_slide()
	look_at(get_global_mouse_position())
	
func laser():
	%Laser.fire()

func fire():
	var bullet = BULLET.instantiate()
	AudioManager.create_2d_audio_at_location(
		global_position,
		SoundEffect.SOUND_EFFECT_TYPE.ON_FIRE
	)
	get_parent().add_child(bullet)
	bullet.fire(self, bullet_speed)
	
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

func gain_xp() -> void:
	xp += 1
	if xp >= %XPBar.max_value:
		level_up()
	else:
		%XPBar.value = xp
