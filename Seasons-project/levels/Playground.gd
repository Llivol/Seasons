extends Node2D

const ROPE_MAX_DISTANCE = 256

# Declare member variables here. Examples:
var player1
var player2
var l_player1
var l_player2
var l_distance

# Called when the node enters the scene tree for the first time.
func _ready():
	player1 = get_node("player1")
	player2 = get_node("player2")
	l_player1 = get_node("player1_pos")
	l_player2 = get_node("player2_pos")
	l_distance = get_node("distance")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	l_player1.set_text(str("Player 1: (", _round_to_dec(player1.global_position.x, 0), ", ", _round_to_dec(player1.global_position.y, 0), "), ", player1.player.get_state()))
	l_player2.set_text(str("Player 2: (", _round_to_dec(player2.global_position.x, 0), ", ", _round_to_dec(player2.global_position.y, 0), "), ", player2.player.get_state()))
	l_distance.set_text(str("Distance: ", _round_to_dec(_get_distance(), 0)))
	pass

func _round_to_dec(num, digit):
    return round(num * pow(10.0, digit)) / pow(10.0, digit)


func _get_distance():
	return player1.global_position.distance_to(player2.global_position)