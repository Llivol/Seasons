extends Area2D
class_name AttackArea

var _parent
var _init

func _ready():
	_parent = get_parent()
	_init = false
	set_draw_behind_parent(true)

func _process(delta):
	if _init:
		return
	
	if _parent.SIZE != null:
		$Shape.shape.set_radius(_parent.SIZE * 1.5)
		_init = true

func _draw():
	if not Cheats.debug:
		return
	
	draw_circle(position, _parent.SIZE * 1.5, Global.COLOR_GREEN)

