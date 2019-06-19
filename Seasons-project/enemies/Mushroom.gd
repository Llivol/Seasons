extends LandShooter

func _ready():
	set_stats(Global.HEALTH_AVERAGE, Global.SIZE_AVERAGE, 0, Global.DAMAGE_LOW, true, Global.AWARENESS_SMALL)
	set_shooter_stats(Global.DAMAGE_LOW, 2, 250)
	can_attack = true
	set_sprite_size()