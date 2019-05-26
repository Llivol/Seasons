extends Node2D

const ROPE_MAX_DISTANCE = 256

# Declare member variables here. Examples:
var player_left
var player_right
var l_player_left
var l_player_right
var l_distance
var distance = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	player_left = $PlayerLeft
	player_right = $PlayerRight
	l_player_left = $LPlayerLeft
	l_player_right = $LPlayerRight
	l_distance = $LDistance
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	distance = Vector2(abs(player_left.global_position.x - player_right.global_position.x), abs(player_left.global_position.y - player_right.global_position.y))
	l_player_left.set_text(str("Player Left: (", _round_to_dec(player_left.global_position.x, 0), ", ", _round_to_dec(player_left.global_position.y, 0), "), ", player_left.kinematics.get_state_string()))
	l_player_right.set_text(str("Player Right: (", _round_to_dec(player_right.global_position.x, 0), ", ", _round_to_dec(player_right.global_position.y, 0), "), ", player_right.kinematics.get_state_string()))
	l_distance.set_text(str("Distance: ", _round_to_dec(_get_distance(), 0), " (", _round_to_dec(distance.x, 0), ", ", _round_to_dec(distance.y, 0), ")"))
	pass

func _round_to_dec(num, digit):
    return round(num * pow(10.0, digit)) / pow(10.0, digit)


func _get_distance():
	return player_left.global_position.distance_to(player_right.global_position)