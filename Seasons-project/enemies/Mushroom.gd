extends LandShooter

func _ready():
	set_stats(Global.SIZE_AVERAGE, Global.SIZE_AVERAGE, 0, Global.DAMAGE_LOW, Global.AWARENESS_SMALL)
	set_shooter_stats(Global.DAMAGE_LOW, 2, 500)
	can_attack = true
	set_sprite_size()