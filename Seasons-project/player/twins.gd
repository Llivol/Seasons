extends Node2D

const ROPE_MAX_DISTANCE = 128

# Declare member variables here. Examples:
var _player_left
var _player_right
var _distance

# Called when the node enters the scene tree for the first time.
func _ready():
	_player_left = $PlayerLeft
	_player_right = $PlayerRight

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_update_distance()
	if _distance >= ROPE_MAX_DISTANCE:
		_player_right.kinematics.set_direction(Vector2(0,1))

func _get_distance():
	return self._distance

func _update_distance():
	self._distance = _player_left.global_position.distance_to(_player_right.global_position)
	#self._player_left.kinematics.set_on_rope_max_distance(_distance >= ROPE_MAX_DISTANCE)
	#self._player_right.kinematics.set_on_rope_max_distance(_distance >= ROPE_MAX_DISTANCE)