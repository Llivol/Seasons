extends Enemy
class_name LandChaser

export var default_color = Global.COLOR_ORANGE

onready var ledge_detector = $LedgeDetector


func _ready():
	set_stats(Global.HEALTH_AVERAGE, Global.SIZE_SMALL, Global.SPEED_AVERAGE, Global.DAMAGE_LOW, Global.AWARENESS_SMALL)


func _process(delta):
	if ledge_detector.is_near_ledge() or ledge_detector.is_near_wall():
		if ledge_detector.is_near_floor():
			flip_direction()

func _draw():
	draw_circle(Vector2.ZERO, SIZE, default_color)


func _physics_process(delta):
	move(delta) if (not _target) else chase(delta)


func _on_AttackArea_body_entered(body):
	if body is Player:
		attack(body)

func _on_AwarenessArea_body_entered(body):
	if body is Player:
		_target = body
		_velocity = Vector2.ZERO
		flip_direction()


func _on_FocusArea_body_exited(body):
	if body is Player and body == _target:
		_target = null
		update_direction()
