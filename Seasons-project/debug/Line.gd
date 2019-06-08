extends Line2D

var _parent
var _init

func _ready():
	_parent = get_parent()
	_init = false

func _process(delta):
	if _init:
		return
	
	if _parent.get_cast_to() != null:
		_init = true

func _draw():
	if not Global.debug:
		return
	draw_line(position, _parent.get_cast_to(), Global.COLOR_RED)