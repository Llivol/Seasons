extends Hazard
class_name Spawner

var CHILD_SCENE
var SPAWN_CD
var AWARENESS

var _target

func set_spawner_stats(child_path, spawn_cd, awareness):
	CHILD_SCENE = load(child_path)
	SPAWN_CD = spawn_cd
	AWARENESS = awareness


func _process(delta):
	if _target and not _target.is_dead() and $SpawnCooldown.is_stopped():
		spawn()


func spawn():
		var child = CHILD_SCENE.instance()
		get_parent().add_child(child)
		var child_position = self.global_position
		randomize()
		var angle = rand_range(PI,  2 * PI) if (BELOW) else rand_range(0, PI) 
		var distance = rand_range(min(SIZE * 2, AWARENESS / 2), AWARENESS)
		child_position.x += distance * cos(angle)
		child_position.y -= distance * sin(angle)
		child.global_position = child_position
		$SpawnCooldown.start()


func die():
	var power_up_scene = load("res://powerups/HealthUp.tscn")
	var power_up = power_up_scene.instance()
	power_up.set_position(position)
	get_parent().add_child(power_up)
	.die()


func _on_AwarenessArea_body_entered(body):
	_target = body
	$SpawnCooldown.start()
	
	if body.is_dead():
		_target = null

func _on_AwarenessArea_body_exited(body):
	_target = null
	
	$SpawnCooldown.stop()

func _on_SpawnCooldown_timeout():
	if _target and not _target.is_dead():
		spawn()