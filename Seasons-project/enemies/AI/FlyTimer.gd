extends Timer

var _parent
var _init

func _ready():
	_parent = get_parent()
	_init = false

func _process(delta):
	if _init:
		return
	
	if _parent.FLY_TIME != null:
		set_wait_time(_parent.FLY_TIME)
		_init = true