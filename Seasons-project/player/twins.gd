extends Node2D

const ROPE_MAX_DISTANCE = 252
const ROPE_MIN_DISTANCE = 32

var _player_left
var _player_right
var _distance := 0.0


func _ready():
	_player_left = $PlayerLeft
	_player_right = $PlayerRight


func _process(delta):
	_update_distance()
	if _distance >= ROPE_MAX_DISTANCE:
		#_player_right.kinematics.set_direction(Vector2(0,1))
		pass


func _get_distance():
	return self._distance


func _update_distance():
	self._distance = _player_left.global_position.distance_to(_player_right.global_position)
	
	self._player_left.set_on_rope_max_distance(_distance >= ROPE_MAX_DISTANCE)
	self._player_right.set_on_rope_max_distance(_distance >= ROPE_MAX_DISTANCE)
	
	self._player_left.set_on_rope_min_distance(_distance <= ROPE_MIN_DISTANCE)
	self._player_right.set_on_rope_min_distance(_distance <= ROPE_MIN_DISTANCE)
	
	self._player_left.set_direction_to_twin((self._player_right.global_position - self._player_left.global_position).normalized())
	self._player_right.set_direction_to_twin((self._player_left.global_position - self._player_right.global_position).normalized())
	