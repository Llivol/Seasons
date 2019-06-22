extends LandShooter

func _ready():
	set_stats(Global.HEALTH_AVERAGE, Global.SIZE_AVERAGE, 0, Global.DAMAGE_AVERAGE, true, Global.AS_FAST, Global.AWARENESS_TINY)
	set_shooter_stats(Global.AS_SLOW, Global.SPEED_SLOW, Global.BULLET_SIZE_AVERAGE, Global.DAMAGE_AVERAGE, Global.COLOR_GREEN)
	can_attack = true
	set_sprite_size()