extends LandShooter

func _ready():
	set_stats(Global.HEALTH_AVERAGE, Global.SIZE_AVERAGE, 0, Global.DAMAGE_LOW, true, Global.AS_SLOW, Global.AWARENESS_SMALL)
	set_shooter_stats(Global.AS_SLOW, Global.SPEED_SLOW, Global.BULLET_SIZE_TINY, Global.DAMAGE_LOW, Global.COLOR_GREEN)
	can_attack = true
	set_sprite_size()