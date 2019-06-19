extends Node2D
class_name Level

var player_left
var player_right
var l_player_left
var l_player_right
var l_distance
var l_altitude
var distance = Vector2()

var viewport

var max_altitude
var start_altitude
var current_altitude

func _ready():
	player_left = $Twins/PlayerLeft
	player_right = $Twins/PlayerRight
	l_player_left = $Viewport/Camera2D/LPlayerLeft
	l_player_right = $Viewport/Camera2D/LPlayerRight
	l_distance = $Viewport/Camera2D/LDistance
	l_altitude = $Viewport/Camera2D/LAltitude
	viewport = $Viewport
	max_altitude = 0

func _process(delta):
	if not start_altitude:
		start_altitude = player_left.global_position.y
		current_altitude = start_altitude
		max_altitude = start_altitude - current_altitude
		viewport.global_position = Vector2(Global.window_size_x / 2, Global.window_size_y / 2)

	update_altitude()

	distance = Vector2(abs(player_left.global_position.x - player_right.global_position.x), abs(player_left.global_position.y - player_right.global_position.y))
	l_player_left.set_text(str("Player Left: pos", player_left.global_position.round(), ", vel", player_left.get_velocity().round(), ", force", player_left.get_force().round(), "; status: ", player_left.states_strings[player_left.get_state()]))
	l_player_right.set_text(str("Player Right: pos", player_right.global_position.round(), ", vel", player_right.get_velocity().round(), ", force", player_right.get_force().round(), "; status: ", player_right.states_strings[player_right.get_state()]))
	l_distance.set_text(str("Distance: ", _round_to_dec(_get_distance(), 0), " (", _round_to_dec(distance.x, 0), ", ", _round_to_dec(distance.y, 0), ")"))
	l_altitude.set_text(str("Cur altitude: ", round(current_altitude)))
	pass

func _draw():
	if start_altitude:
		draw_line (Vector2(0, current_altitude), Vector2(32*16, current_altitude), Global.COLOR_RED, 2)


func update_altitude():
	if player_left.global_position.y < current_altitude:
		max_altitude += (current_altitude - player_left.global_position.y)
		current_altitude = player_left.global_position.y
		if Global.window_size_y / 2 > current_altitude:
			viewport.global_position.y = current_altitude
		update()
	if player_right.global_position.y < current_altitude:
		max_altitude += (current_altitude - player_right.global_position.y)
		current_altitude = player_right.global_position.y
		if Global.window_size_y / 2 > current_altitude:
			viewport.global_position.y = current_altitude
		update()

func _round_to_dec(num, digit):
    return round(num * pow(10.0, digit)) / pow(10.0, digit)


func _get_distance():
	return player_left.global_position.distance_to(player_right.global_position)