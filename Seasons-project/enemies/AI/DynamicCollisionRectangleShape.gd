extends CollisionShape2D
class_name DynamicCollisionRectangleShape

var _parent
var _init

func _ready():
	_parent = get_parent()
	_init = false
	set_draw_behind_parent(true)

func _process(delta):
	if _init:
		update()
		return

	if _parent.SIZE != null:
		shape.set_extents(Vector2(_parent.SIZE, _parent.SIZE))
		_init = true

func _draw():
	if not Cheats.debug or not _init:
		return

	var red_a128 = Global.COLOR_RED
	red_a128.a = 0.5
	var rect = Rect2(position - Vector2(_parent.SIZE, _parent.SIZE), Vector2(_parent.SIZE * 2, _parent.SIZE * 2))
	draw_rect(rect, red_a128)