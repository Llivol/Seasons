extends LandShooter

func _ready():
	set_stats(Global.HEALTH_HIGH, Global.SIZE_LARGE, Global.SPEED_SLOW, Global.DAMAGE_HIGH, true, Global.AS_SLOW, Global.AWARENESS_LARGE)
	set_shooter_stats(Global.AS_SLOW, Global.SPEED_SLOW, Global.BULLET_SIZE_LARGE, Global.DAMAGE_HIGH, Global.COLOR_WHITE)
	can_attack = true
	set_sprite_size()