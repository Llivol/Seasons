extends Area2D
class_name FocusArea

export var area_multiplier = 2.5

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
		$Shape.shape.set_radius(_parent.AWARENESS * area_multiplier)
		_init = true

func _draw():
	if not Cheats.debug:
		return

	var dark_green_a128 = Global.COLOR_DARK_GREEN
	dark_green_a128.a = 0.5
	draw_circle(position, _parent.AWARENESS * area_multiplier, dark_green_a128)
