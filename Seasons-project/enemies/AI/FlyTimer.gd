extends Timer

var _parent
var _init

func _ready():
	_parent = get_parent()
	_init = false

func _process(delta):
	if _init:
		return
	
	if _parent.fly_time != null:
		set_wait_time(_parent.fly_time)
		_init = true