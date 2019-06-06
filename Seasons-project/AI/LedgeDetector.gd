extends Node2D

var _parent
var _floor_detector
var _wall_detector

func _ready():
	_parent = get_parent()
	_floor_detector = $FloorDetector
	_wall_detector = $WallDetector


func is_near_ledge() -> bool:
	return not _floor_detector.is_colliding()


func is_near_wall() -> bool:
	return _wall_detector.is_colliding()


func set_wall_detector_size(size):
	_wall_detector.set_cast_to(Vector2(size, 0))