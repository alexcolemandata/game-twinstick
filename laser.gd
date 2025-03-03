extends Area2D

const CHARGE_TO_FIRE = 1000
const MAX_CHARGE = 1020
const CHARGE_AMOUNT = 5
var firing = false
var charge = 0

func _ready() -> void:
	$LaserBeam.visible = false
	$LaserChargeParticles.emitting = false
	$ChargeBarHolder/LaserChargeBar.value = 0
	$ChargeBarHolder/LaserChargeBar.max_value = CHARGE_TO_FIRE
	
func _process(delta) -> void:
	$LaserBeam.visible = firing
	
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
			
	
func fire() -> void:
	if not firing:
		charge += CHARGE_AMOUNT

		if charge >= CHARGE_TO_FIRE:
			firing = true			
			$LaserChargeParticles.emitting = false
		else:
			$LaserChargeParticles.emitting = true
