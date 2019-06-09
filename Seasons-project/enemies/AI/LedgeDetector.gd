extends Node2D

var _parent
var _init
var _floor_detector
var _wall_detector

func _ready():
	_parent = get_parent()
	_floor_detector = $FloorDetector
	_wall_detector = $WallDetector
	_init = false

func _process(delta):
	if _init:
		return
	
	if _parent.SIZE != null:
		translate(Vector2(_parent.SIZE, 0))
		_floor_detector.set_cast_to(Vector2(0, 8 + _parent.SIZE))
		update()
		_init = true


func is_near_ledge() -> bool:
	return not _floor_detector.is_colliding()


func is_near_wall() -> bool:
	return _wall_detector.is_colliding()


func set_wall_detector_size(size):
	_wall_detector.set_cast_to(Vector2(size, 0))


func _draw():
	if not Global.debug:
		return
	draw_line(_floor_detector.position, _floor_detector.get_cast_to(), Global.COLOR_BLUE, 2.0)
	draw_line(_wall_detector.position, _wall_detector.get_cast_to(), Global.COLOR_RED, 2.0)