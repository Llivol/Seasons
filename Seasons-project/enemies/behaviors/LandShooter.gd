extends Enemy
class_name LandShooter

export var default_color = Global.COLOR_RED

onready var bullet_scene = preload("res://enemies/AI/Bullet.tscn")

var ATTACK_CD
var BULLET_SPEED
var BULLET_SIZE
var BULLET_DAMAGE

var can_attack

onready var ledge_detector = $LedgeDetector

func set_shooter_stats(bullet_damage = Global.DAMAGE_AVERAGE, attack_cd = 2, bullet_speed = 200, bullet_size = 4):
	ATTACK_CD = attack_cd
	BULLET_SPEED = bullet_speed
	BULLET_SIZE = bullet_size
	BULLET_DAMAGE = bullet_damage

func _process(delta):
	if ledge_detector.is_near_ledge() or ledge_detector.is_near_wall():
		if ledge_detector.is_near_floor():
			flip_direction()
	if _target and _target.is_dead():
		_target = null

func _draw():
	if not Cheats.sprites:
		draw_circle(Vector2.ZERO, SIZE, default_color)


func _physics_process(delta):
	move(delta)
	shoot()

func shoot():
	if _target and can_attack:
		flip_direction()
		var bullet = bullet_scene.instance()
		bullet.set_direction((_target.global_position - global_position).normalized() * _direction) 
		add_child(bullet)
		$AttackCooldown.start()
		can_attack = false


func _on_AttackArea_body_entered(body):
	if body is Player and not body.is_dead():
		attack(body)
		if body == _target and body.is_dead():
			_target = null

func _on_AwarenessArea_body_entered(body):
	if body is Player:
		_target = body
		if body.is_dead():
			_target = null


func _on_FocusArea_body_exited(body):
	if body is Player and body == _target:
		_target = null


func _on_AttackCooldown_timeout():
	can_attack = true
	$AttackCooldown.stop()