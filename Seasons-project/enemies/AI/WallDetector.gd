extends Node2D

var _parent
var _right
var _left
var _up
var _down

func _ready():
	_parent = get_parent()
	_right = $RightDetector
	_left = $LeftDetector
	_up = $UpDetector
	_down = $DownDetector
	
	_right.add_exception(_parent)
	_left.add_exception(_parent)
	_up.add_exception(_parent)
	_down.add_exception(_parent)


func is_near_wall() -> bool:
	return _right.is_colliding() or _left.is_colliding() or _up.is_colliding() or _down.is_colliding()


func set_wall_detector_size(size):
	_right.translate(Vector2(size, 0))
	_left.translate(Vector2(-size, 0))
	_up.translate(Vector2(0, -size))
	_down.translate(Vector2(0, size))