extends Enemy
class_name LandPatroller

export var default_color = Global.COLOR_YELLOW

onready var ledge_detector = $LedgeDetector


func _process(delta):

	if ledge_detector.is_near_ledge() or ledge_detector.is_near_wall():
		if ledge_detector.is_near_floor():
			flip_direction()


func _draw():
	if not Cheats.sprites:
		draw_circle(Vector2.ZERO, SIZE, default_color)


func _physics_process(delta):
	move(delta)


func _on_AttackArea_body_entered(body):
	if body is Player and not body.is_dead():
		attack(body)