extends CollisionShape2D
class_name DynamicCollisionShape

var _parent
var _init

func _ready():
	_parent = get_parent()
	_init = false

func _process(delta):
	if _init:
		return

	if _parent.SIZE != null:
		self.shape.set_radius(_parent.SIZE)
		_init = true

func _draw():
	if not Cheats.debug or not _init:
		return
	
	var red_a128 = Global.COLOR_RED
	red_a128.a = 0.5
	draw_circle(position, _parent.SIZE, red_a128)