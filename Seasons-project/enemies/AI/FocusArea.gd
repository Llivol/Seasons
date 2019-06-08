extends Area2D

var _parent
var _init

func _ready():
	_parent = get_parent()
	_init = false

func _process(delta):
	if _init:
		return

	if _parent.AWARENESS != null:
		$Shape.shape.set_radius(_parent.AWARENESS * 2)
		_init = true

func _draw():
	if not Global.debug:
		return

	var dark_green_a128 = Global.COLOR_DARK_GREEN
	dark_green_a128.a = 0.5
	draw_circle(position, _parent.AWARENESS * 2, dark_green_a128)
