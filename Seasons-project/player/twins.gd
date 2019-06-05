	extends Node2D

const ROPE_MAX_DISTANCE = 128
const ROPE_MIN_DISTANCE = 33

var _player_left
var _player_right
var _rope
var _distance := 0.0


func _ready():
	_player_left = $PlayerLeft
	_player_right = $PlayerRight
	_rope = $Rope


func _process(delta):
	_update_rope()
	_update_distance()
	if _distance >= ROPE_MAX_DISTANCE:
		_rope.default_color = Global.COLOR_RED
	else:
		_rope.default_color = Global.COLOR_ORANGE


func get_distance():
	return _distance


func _update_distance():
	_distance = _player_left.global_position.distance_to(_player_right.global_position)
	
	_player_left.set_on_rope_max_distance(_distance >= ROPE_MAX_DISTANCE)
	_player_right.set_on_rope_max_distance(_distance >= ROPE_MAX_DISTANCE)
	
	_player_left.set_on_rope_min_distance(_distance <= ROPE_MIN_DISTANCE)
	_player_right.set_on_rope_min_distance(_distance <= ROPE_MIN_DISTANCE)
	
	_player_left.set_direction_to_twin((_player_right.global_position - _player_left.global_position).normalized())
	_player_right.set_direction_to_twin((_player_left.global_position - _player_right.global_position).normalized())


func _update_rope():
	_rope.set_point_position(0, _player_left.get_position())
	_rope.set_point_position(1, _player_right.get_position())