extends LandShooter

func _ready():
	set_stats(Global.HEALTH_HIGH, Global.SIZE_LARGE, Global.SPEED_SLOW, Global.DAMAGE_HIGH, true, Global.AS_SLOW, Global.AWARENESS_AVERAGE)
	set_shooter_stats(Global.AS_SLOW, Global.SPEED_SLOW, Global.BULLET_SIZE_AVERAGE, Global.DAMAGE_AVERAGE, Global.COLOR_WHITE)
	can_attack = true
	set_sprite_size()