extends Area2D
class_name AwarenessArea

var _parent
var _init

func _ready():
	_parent = get_parent()
	_init = false
	set_draw_behind_parent(true)

func _process(delta):
	if _init:
		return

	if _parent.AWARENESS != null:
		$Shape.shape.set_radius(_parent.AWARENESS)
		_init = true

func _draw():
	if not Cheats.debug:
		return

	var light_green_a128 = Global.COLOR_LIGHT_GREEN
	light_green_a128.a = 0.5
	draw_circle(position, _parent.AWARENESS, light_green_a128)
