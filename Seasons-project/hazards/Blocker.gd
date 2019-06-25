extends Hazard
class_name Blocker

var ATTACK_CD = Global.TIME_VERY_LOW

var _attack_target
var can_attack

func attack(player = _attack_target):
	if player:
		if not player.is_invulnerable and not player.is_dead():
			.attack(player)
		$AttackCooldown.start()

func _on_AttackArea_body_entered(body):
	_attack_target = body
	
	if body.is_dead():
		_attack_target = null
	else:
		attack()


func _on_AttackArea_body_exited(body):
	_attack_target = null
	$AttackCooldown.stop()


func _on_AttackCooldown_timeout():
	if _attack_target and not _attack_target.is_dead():
		attack()