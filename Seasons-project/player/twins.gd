extends Node2D

const ROPE_MAX_DISTANCE = Global.UNIT * 8
const ROPE_MIN_DISTANCE = Global.UNIT
const HUG_DISTANCE = Global.UNIT / 2
const ERROR_MARGIN = Global.UNIT / 8

var _player_left
var _player_right
var _rope
var _distance := 0.0
var _joint


func _ready():
	_player_left = $PlayerLeft
	_player_right = $PlayerRight
	_rope = $Rope
	_joint = true


func _process(delta):
	if _joint:
		_update_rope()
		_update_distance()
		if _distance >= ROPE_MAX_DISTANCE:
			_rope.default_color = Global.COLOR_RED
		else:
			_rope.default_color = Global.COLOR_ORANGE
		
		if _player_left.is_dead() and _player_right.is_dead():
			print("emit signal game over")
			var current_scene = get_tree().get_current_scene().filename
			get_tree().change_scene(current_scene)
			print(">> Reloading scene...")
	else:
		if _player_left and _player_left.is_dead() or _player_right and _player_right.is_dead():
			print("emit signal game over")
			var current_scene = get_tree().get_current_scene().filename
			get_tree().change_scene(current_scene)
			print(">> Reloading scene...")


func get_distance():
	if not _joint:
		return -1
	return _distance

func get_twin(player):
	return _player_left if (player == _player_right) else _player_right


func cut_the_rope(player):
	var twin = get_twin(player)
	if twin == _player_left:
		_player_left = null
	else:
		_player_right = null
	_joint = false
	$Rope.queue_free()


func is_joint():
	return _joint

func _update_distance():
	_distance = _player_left.global_position.distance_to(_player_right.global_position)
	
	_player_left.set_on_rope_max_distance(_distance >= ROPE_MAX_DISTANCE and not Cheats.infinite_rope_lenght)
	_player_right.set_on_rope_max_distance(_distance >= ROPE_MAX_DISTANCE and not Cheats.infinite_rope_lenght)
	
	_player_left.set_on_rope_min_distance(abs(_player_right.global_position.y - _player_left.global_position.y) <= ROPE_MIN_DISTANCE)
	_player_right.set_on_rope_min_distance(abs(_player_right.global_position.y - _player_left.global_position.y) <= ROPE_MIN_DISTANCE)
	
	_player_left.set_on_hug_distance(_distance <= HUG_DISTANCE)
	_player_right.set_on_hug_distance(_distance <= HUG_DISTANCE)
	
	_player_left.set_direction_to_twin((_player_right.global_position - _player_left.global_position).normalized())
	_player_right.set_direction_to_twin((_player_left.global_position - _player_right.global_position).normalized())


func _update_rope():
	_rope.set_point_position(0, _player_left.get_position())
	_rope.set_point_position(1, _player_right.get_position())

#this has 0 scalability .-.
func _on_Player_collided_with_tilemap(collision, player):
	var tile_pos = collision.collider.world_to_map(player.global_position)
	tile_pos -= collision.normal
	var tile = collision.collider.get_cellv(tile_pos)
	var tile_name = collision.collider.get_tileset().tile_get_name(tile)
	
	if "cold" in tile_name:
		player.set_stamina_recover_time(PlayerGlobal.RECOVER_STAMINA_TIME_TEMPERATURE)
		player.set_stamina_recover_speed(PlayerGlobal.RECOVER_STAMINA_SPEED_TEMPERATURE)
		player.set_stop_force(PlayerGlobal.STOP_FORCE)

	if "hot" in tile_name:
		player.set_stamina_recover_time(PlayerGlobal.RECOVER_STAMINA_TIME_TEMPERATURE)
		player.set_stamina_recover_speed(PlayerGlobal.RECOVER_STAMINA_SPEED_TEMPERATURE)
		player.set_stop_force(PlayerGlobal.STOP_FORCE)

	if "fragile" in tile_name:
		var timer = FragileTileTimer.new()
		timer.set_wait_time(Global.TIME_AVERAGE)
		timer.set_tilemap(collision.collider)
		timer.set_tile_pos(tile_pos)
		timer.connect("timeout", timer, "_on_timeout")
		add_child(timer)
		timer.start()

	if "icy" in tile_name:
		player.set_stamina_recover_time(PlayerGlobal.RECOVER_STAMINA_TIME)
		player.set_stamina_recover_speed(PlayerGlobal.RECOVER_STAMINA_SPEED)
		player.set_stop_force(PlayerGlobal.STOP_FORCE_ICE)

	if "standard" in tile_name:
		player.set_stamina_recover_time(PlayerGlobal.RECOVER_STAMINA_TIME)
		player.set_stamina_recover_speed(PlayerGlobal.RECOVER_STAMINA_SPEED)
		player.set_stop_force(PlayerGlobal.STOP_FORCE)