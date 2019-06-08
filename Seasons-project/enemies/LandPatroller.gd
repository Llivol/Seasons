extends Enemy
class_name LandPatroller

onready var ledge_detector = $LedgeDetector


func _ready():
	set_stats(Global.SIZE_SMALL, Global.SPEED_AVERAGE, Global.DAMAGE_LOW)


func _process(delta):
	if ledge_detector.is_near_ledge() or ledge_detector.is_near_wall():
		flip_direction()


func _physics_process(delta):
	move(delta)


func _on_AttackArea_body_entered(body):
	if body is Player:
		attack(body)