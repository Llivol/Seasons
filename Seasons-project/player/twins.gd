extends Node2D

const ROPE_MAX_DISTANCE = 192
const ROPE_MIN_DISTANCE = 32

var _player_left
var _player_right
var _rope
var _distance


func _ready():
	_player_left = $PlayerLeft
	_player_right = $PlayerRight
	_distance = Vector2()
	_rope = $Rope


func _process(delta):
	_update_rope()
	_update_distance()
	if _distance.length() >= ROPE_MAX_DISTANCE + 16:
		print("too much distance")
	if _distance.length() >= ROPE_MAX_DISTANCE:
		_rope.default_color = Global.COLOR_RED
	else:
		_rope.default_color = Global.COLOR_ORANGE


func get_distance():
	return _distance.length()


func _update_distance():
	_distance = Vector2(abs(_player_left.global_position.x - _player_right.global_position.x), abs(_player_left.global_position.y - _player_right.global_position.y))
	
	_player_left.set_on_rope_max_distance(_distance.length() >= ROPE_MAX_DISTANCE)
	_player_right.set_on_rope_max_distance(_distance.length() >= ROPE_MAX_DISTANCE)
	
	_player_left.set_on_rope_min_distance(_distance.y <= ROPE_MIN_DISTANCE)
	_player_right.set_on_rope_min_distance(_distance.y <= ROPE_MIN_DISTANCE)
	
	_player_left.set_direction_to_twin((_player_right.global_position - _player_left.global_position).normalized())
	_player_right.set_direction_to_twin((_player_left.global_position - _player_right.global_position).normalized())


func _update_rope():
	_rope.set_point_position(0, _player_left.get_position())
	_rope.set_point_position(1, _player_right.get_position())