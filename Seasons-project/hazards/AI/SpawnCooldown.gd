extends Timer
class_name SpawnCooldown

var _parent
var _init

func _ready():
	_parent = get_parent()
	_init = false

func _process(delta):
	if _init:
		return

	if _parent.SPAWN_CD != null:
		set_wait_time(_parent.SPAWN_CD)
		_init = true