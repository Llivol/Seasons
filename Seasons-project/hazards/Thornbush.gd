extends Blocker

func _ready():
	set_stats(Global.SIZE_AVERAGE, Global.HEALTH_AVERAGE, Global.DAMAGE_LOW, false)

func _process(delta):
	if _attack_target:
		_attack_target.apply_velocity(Vector2(_attack_target.get_velocity().x * 0.1, 0))

func attack(player = _attack_target, knockback = false):
	.attack(_attack_target, knockback)