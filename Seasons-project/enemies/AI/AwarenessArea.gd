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
		$Shape.shape.set_radius(_parent.AWARENESS + 1)
		_init = true

func _draw():
	if not Global.debug:
		return

	draw_circle(position, _parent.SIZE, Global.COLOR_LIGHT_GREEN)
