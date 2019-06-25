extends Spawner

func _ready():
	set_stats(Global.SIZE_AVERAGE, Global.HEALTH_AVERAGE, 0, false)
	set_spawner_stats("res://enemies/VulturePlus.tscn", Global.TIME_HIGH, Global.AWARENESS_AVERAGE)