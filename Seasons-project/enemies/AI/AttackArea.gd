extends Area2D

var _parent
var _init

func _ready():
	_parent = get_parent()
	_init = false

func _process(delta):
	if _init:
		return
	
	if _parent.SIZE != null:
		$Shape.shape.set_radius(_parent.SIZE + 1)
		_init = true

func _draw():
	if not Global.debug:
		return
	
	"""
	var light_green_a128 = Global.COLOR_LIGHT_GREEN
	light_green_a128.a = 0.5
	draw_circle(position, _parent.SIZE*2, light_green_a128)
	"""
	draw_circle(position, _parent.SIZE, Global.COLOR_GREEN)

