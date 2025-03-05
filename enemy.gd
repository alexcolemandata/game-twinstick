extends CharacterBody2D

const MAX_HEALTH = 1
const EXPERIENCE = 5
var health = MAX_HEALTH
var move_speed = 2.0
var player: CharacterBody2D
var motion: Vector2 = Vector2()
const BULLET = preload("res://Bullet.tscn")
const BULLET_IMPACT = preload("res://BulletImpact.tscn")
const ENEMY_DESTROYED_EXPLOSION = preload("res://EnemyDestroyedExplosion.tscn")
const EXPERIENCE_BLIP = preload("res://ExperienceBlip.tscn")

const COLORS = [
	Color.AQUA,
	Color.CORAL,
	Color.VIOLET,
	Color.TEAL,
	Color.SKY_BLUE,
	Color.SALMON,
	Color.RED,
	Color.DEEP_PINK,
	Color.PINK,
]

func _ready() -> void:
	%HealthBar.max_value = MAX_HEALTH
	%HealthBar.value = MAX_HEALTH
	%HealthBar.visible = false
	$Polygon2D.color = COLORS.pick_random() * 1.2
	$AnimationPlayer.play("Idle")
	
func _physics_process(delta: float) -> void:
	if not player:
		return
	look_at(player.global_position)
	motion = (player.global_position - global_position).normalized() * move_speed
		
	move_and_collide(motion)

func take_damage() -> void:
	print("owie!");
	health -= 1
	%HealthBar.visible = true
	%HealthBar.value = health
	if health == 0:
		die()
		return
	
	var clr = $Polygon2D.color
	$Polygon2D.color = Color.WHITE
	await get_tree().create_timer(0.1).timeout
	$Polygon2D.color = clr
	
	
		
func die() -> void:
	print("i'm slain!")
	AudioManager.create_2d_audio_at_location(
		global_position,
		SoundEffect.SOUND_EFFECT_TYPE.ON_ENEMY_DEATH
	)
	var death_explosion = ENEMY_DESTROYED_EXPLOSION.instantiate()
	add_sibling(death_explosion)
	death_explosion.global_position = global_position
	death_explosion.process_material.color = $Polygon2D.color.lightened(0.5)
	death_explosion.fire()
	
	for i in range(EXPERIENCE):
		var xp =  EXPERIENCE_BLIP.instantiate()
		xp.player = player
		add_sibling(xp)
		xp.global_position = global_position + Vector2(randf()*5, randf()*5)
	
	queue_free()
	

func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.has_method("fire"):
		take_damage()
		var impact = BULLET_IMPACT.instantiate()
		add_sibling(impact)
		impact.global_position = global_position
		impact.fire()
		body.queue_free()
		
