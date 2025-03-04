extends Area2D

const CHARGE_TO_FIRE = 1000
const MAX_CHARGE = 1020
const CHARGE_AMOUNT = 5
var firing = false
var charge = 0
var desired_volume = 0

func _ready() -> void:
	$LaserBeam.visible = false
	$LaserChargeParticles.emitting = false
	$ChargeBarHolder/LaserChargeBar.value = 0
	$ChargeBarHolder/LaserChargeBar.max_value = CHARGE_TO_FIRE
	
func _process(delta) -> void:
	$LaserBeam.visible = firing
	if not Input.is_action_pressed("laser"):
		desired_volume = -70 + (charge / float(MAX_CHARGE))
	else:
		desired_volume = 0
		
	var sound_effect = AudioManager.sound_effect_dict[SoundEffect.SOUND_EFFECT_TYPE.ON_LASER_CHARGING].sound_effect
	for audio: AudioStreamPlayer2D in AudioManager.get_children():
		if audio.stream != sound_effect:
			continue
		var volume = audio.volume_db
		if volume == desired_volume:
			continue
		if volume > desired_volume:
			audio.volume_db = volume - min(volume - desired_volume, 0.07)
		else:
			audio.volume_db = volume + min(desired_volume - volume, 0.2)
		
	
	if firing:
		$LaserChargeParticles.emitting = false

		charge -= CHARGE_AMOUNT
		AudioManager.create_2d_audio_at_location(
			get_parent().global_position,
			SoundEffect.SOUND_EFFECT_TYPE.ON_LASER_FIRING
		)
		
		for body in get_overlapping_bodies():
			if body.has_method("take_damage"):
				body.take_damage()
		
		if charge <= 0:
			firing = false
	else:
		charge -= 1
	
	charge = max(0, charge)
	if charge <= 0:
		$LaserChargeParticles.emitting = false

	$ChargeBarHolder/LaserChargeBar.value = charge
	$ChargeBarHolder/LaserChargeBar.visible = (charge > 0)
			
	
const EFFECT_TIERS = 10
func fire() -> void:
	if not firing:
		charge += CHARGE_AMOUNT
		var sound_effect: SoundEffect = AudioManager.sound_effect_dict[SoundEffect.SOUND_EFFECT_TYPE.ON_LASER_CHARGING]
		for effect_tier in range(EFFECT_TIERS):
			var threshold = (1 / float(EFFECT_TIERS)) * effect_tier
			var charge_ratio = charge / float(MAX_CHARGE)
			if (charge_ratio > threshold) and (sound_effect.audio_count <= effect_tier):
				sound_effect.pitch_scale = 0.9 + (threshold / 4.0)
				print("reached effect_tier: ", effect_tier)
				print("sound_effect.audio_count", sound_effect.audio_count)
				AudioManager.create_2d_audio_at_location(
					get_parent().global_position,
					SoundEffect.SOUND_EFFECT_TYPE.ON_LASER_CHARGING
				)
				break

		if charge >= CHARGE_TO_FIRE:
			firing = true			
			$LaserChargeParticles.emitting = false
			AudioManager.stop_sound_effect(SoundEffect.SOUND_EFFECT_TYPE.ON_LASER_CHARGING)
		else:
			$LaserChargeParticles.emitting = true
