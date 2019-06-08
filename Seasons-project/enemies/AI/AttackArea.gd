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
