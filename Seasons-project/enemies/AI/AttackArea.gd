extends Area2D
class_name AttackArea

var _parent
var _init

var size_multiplier = 1

func _ready():
	_parent = get_parent()
	_init = false
	set_draw_behind_parent(true)

func _process(delta):
	if _init:
		update()
		return
	
	if _parent.SIZE != null:
		size_multiplier = _parent.get_size_multiplier() / 2
		size_multiplier += 0.1 * _parent.get_size_multiplier()
		$Shape.shape.set_extents(Vector2(_parent.get_sprite().texture.get_size().x, _parent.get_sprite().texture.get_size().y) * size_multiplier)
		update()
		_init = true

func _draw():
	if not Cheats.debug:
		return
	
	var rect = Rect2(position - Vector2(_parent.get_sprite().texture.get_size().x, _parent.get_sprite().texture.get_size().y) * size_multiplier, Vector2(_parent.get_sprite().texture.get_size().x * 2, _parent.get_sprite().texture.get_size().y * 2) * size_multiplier)
	draw_rect(rect, Global.COLOR_BLUE)