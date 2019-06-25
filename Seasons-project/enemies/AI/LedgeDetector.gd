extends Node2D
class_name LedgeDetector

var _parent
var _init
var _floor_detector
var _ceil_detector
var _ledge_detector
var _wall_detector
var _wall_detector_top
var _wall_detector_bot

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
	if has_node("CeilDetector"):
		_ceil_detector = $CeilDetector
		_ceil_detector.set_enabled(true)
		_ceil_detector.add_exception(_parent)
	if has_node("WallDetector"):
		_wall_detector = $WallDetector
		_wall_detector.set_enabled(true)
		_wall_detector.add_exception(_parent)
		
		_wall_detector_top = $WallDetectorTop
		_wall_detector_top.set_enabled(true)
		_wall_detector_top.add_exception(_parent)
		
		_wall_detector_bot = $WallDetectorBot
		_wall_detector_bot.set_enabled(true)
		_wall_detector_bot.add_exception(_parent)

	_init = false
	set_draw_behind_parent(true)

func _process(delta):
	if _init:
		update()
		return
	
	if _parent.SIZE != null:
		if has_node("FloorDetector"):
			_floor_detector.set_cast_to(Vector2(0, _parent.get_sprite_size().y / 2 * _parent.get_size_multiplier() + 0.2))
		if has_node("CeilDetector"):
			_ceil_detector.set_cast_to(Vector2(0, - _parent.get_sprite_size().y / 2 * _parent.get_size_multiplier() - 0.2))
		if has_node("LedgeDetector"):
			_ledge_detector.translate(Vector2(_parent.get_sprite_size().x * _parent.get_size_multiplier() / 2, 0))
			_ledge_detector.set_cast_to(Vector2(0, _parent.get_sprite_size().y * _parent.get_size_multiplier()))
		if has_node("WallDetector"):
			_wall_detector.translate(Vector2(_parent.get_sprite_size().x * _parent.get_size_multiplier() / 2 + 1, 0))
			_wall_detector.set_cast_to(Vector2(2, 0))
			
			_wall_detector_top.translate(Vector2(_parent.get_sprite_size().x * _parent.get_size_multiplier() / 2 + 1, -_parent.get_sprite_size().y * _parent.get_size_multiplier() / 4))
			_wall_detector_top.set_cast_to(Vector2(2, -_parent.get_sprite_size().y * _parent.get_size_multiplier() / 4))
			
			_wall_detector_bot.translate(Vector2(_parent.get_sprite_size().x * _parent.get_size_multiplier() / 2 + 1, _parent.get_sprite_size().y * _parent.get_size_multiplier() / 4))
			_wall_detector_bot.set_cast_to(Vector2(2, _parent.get_sprite_size().y * _parent.get_size_multiplier() / 4))

		update()
		_init = true


func is_near_ledge() -> bool:
	if not _ledge_detector:
		return false
	return not _ledge_detector.is_colliding()


func is_near_floor() -> bool:
	if not _floor_detector:
		return false
	return _floor_detector.is_colliding()


func is_near_ceil() -> bool:
	if not _ceil_detector:
		return false
	return _ceil_detector.is_colliding()


func is_near_wall() -> bool:
	if not _wall_detector:
		return false
	return _wall_detector.is_colliding() or _wall_detector_top.is_colliding() or _wall_detector_bot.is_colliding()


func set_wall_detector_size(size):
	_wall_detector.set_cast_to(Vector2(size, 0))


func _draw():
	if not Cheats.debug:
		return
	if has_node("FloorDetector"):
		draw_line(_floor_detector.position, _floor_detector.position + _floor_detector.get_cast_to(), Global.COLOR_LIGHT_BLUE, 1.0)
	if has_node("CeilDetector"):
		draw_line(_ceil_detector.position, _ceil_detector.position + _ceil_detector.get_cast_to(), Global.COLOR_LIGHT_BLUE, 1.0)
	if has_node("LedgeDetector"):
		draw_line(_ledge_detector.position, _ledge_detector.position + _ledge_detector.get_cast_to(), Global.COLOR_LIGHT_BLUE, 1.0)
	if has_node("WallDetector"):
		draw_line(_wall_detector.position, _wall_detector.get_cast_to(), Global.COLOR_RED, 1.0)
		draw_line(_wall_detector_top.position, _wall_detector_top.get_cast_to(), Global.COLOR_RED, 1.0)
		draw_line(_wall_detector_bot.position, _wall_detector_bot.get_cast_to(), Global.COLOR_RED, 1.0)