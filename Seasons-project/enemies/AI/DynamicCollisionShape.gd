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