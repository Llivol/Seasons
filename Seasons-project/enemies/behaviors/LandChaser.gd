extends Enemy
class_name LandChaser

export var default_color = Global.COLOR_ORANGE

onready var ledge_detector = $LedgeDetector

func _process(delta):
	if ledge_detector.is_near_ledge() or ledge_detector.is_near_wall():
		if ledge_detector.is_near_floor():
			flip_direction()

func _draw():
	if not Cheats.sprites:
		draw_circle(Vector2.ZERO, SIZE, default_color)

func _physics_process(delta):
	move(delta) if (not _target) else chase(delta)
	attack()

"""
func _on_AttackArea_body_entered(body):
	_attack_target = body
	if _attack_target is Player and not _attack_target.is_dead():
		attack(_attack_target)
		$AttackCooldown.start()
		if _attack_target == _target and _attack_target.is_dead():
			_target = null
			_attack_target = null


func _on_AwarenessArea_body_entered(body):
	if body is Player and not body.is_dead():
		_target = body
		_velocity = Vector2.ZERO
		flip_direction()


func _on_FocusArea_body_exited(body):
	if body is Player and body == _target:
		_target = null
		update_direction()


func _on_AttackCooldown_timeout():
	if _attack_target is Player and not _attack_target.is_dead():
		attack(_attack_target)
		$AttackCooldown.start()
		if _attack_target == _target and _attack_target.is_dead():
			_target = null
			_attack_target = null
"""