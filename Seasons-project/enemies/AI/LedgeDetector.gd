extends Node2D
class_name LedgeDetector

var _parent
var _init
var _floor_detector
var _ledge_detector
var _wall_detector

func _ready():
	_parent = get_parent()
	if has_node("LedgeDetector"):
		_ledge_detector = $LedgeDetector
		_ledge_detector.set_enabled(true)
		_ledge_detector.add_exception(_parent)
	if has_node("FloorDetector"):
		_floor_detector = $FloorDetector
		_floor_detector.set_enabled(true)
		_floor_detector.add_exception(_parent)
	if has_node("WallDetector"):
		_wall_detector = $WallDetector
		_wall_detector.set_enabled(true)
		_wall_detector.add_exception(_parent)
	_init = false
	set_draw_behind_parent(true)

func _process(delta):
	if _init:
		update()
		return
	
	if _parent.SIZE != null:
		if has_node("FloorDetector"):
			_floor_detector.set_cast_to(Vector2(0, 8 + _parent.SIZE))
		if has_node("LedgeDetector"):
			_ledge_detector.translate(Vector2(_parent.SIZE, 0))
			_ledge_detector.set_cast_to(Vector2(0, 8 + _parent.SIZE))
		if has_node("WallDetector"):
			_wall_detector.translate(Vector2(_parent.SIZE, 0))
			_wall_detector.set_cast_to(Vector2(2, 0))
		update()
		_init = true


func is_near_ledge() -> bool:
	return not _ledge_detector.is_colliding()


func is_near_floor() -> bool:
	return _floor_detector.is_colliding()


func is_near_wall() -> bool:
	return _wall_detector.is_colliding()


func set_wall_detector_size(size):
	_wall_detector.set_cast_to(Vector2(size, 0))


func _draw():
	if not Cheats.debug:
		return
	if has_node("FloorDetector"):
		draw_line(_floor_detector.position, _floor_detector.position + _floor_detector.get_cast_to(), Global.COLOR_LIGHT_BLUE, 2.0)
	if has_node("LedgeDetector"):
		draw_line(_ledge_detector.position, _ledge_detector.position + _ledge_detector.get_cast_to(), Global.COLOR_LIGHT_BLUE, 2.0)
	if has_node("WallDetector"):
		draw_line(_wall_detector.position, _wall_detector.position + _wall_detector.get_cast_to(), Global.COLOR_RED, 2.0)