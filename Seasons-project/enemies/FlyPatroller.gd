extends Enemy
class_name FlyPatroller

onready var ledge_detector = $LedgeDetector
onready var fly_timer = $FlyTimer

const FLY_TIME = 2


func _ready():
	set_stats(Global.SIZE_SMALL, Global.SPEED_SLOW, Global.DAMAGE_AVERAGE)


func _process(delta):
	if ledge_detector.is_near_wall():
		flip_direction()


func _physics_process(delta):
	move(delta, true)


"""Override"""
func flip_direction():
	.flip_direction()
	fly_timer.start(FLY_TIME)


func _on_FlyTimer_timeout():
	flip_direction()


func _on_AttackArea_body_entered(body):
	if body is Player:
		attack(body)
