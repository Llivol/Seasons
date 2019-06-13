extends Enemy
class_name LandShooter

export var default_color = Global.COLOR_RED

onready var bullet_scene = preload("res://enemies/Bullet.tscn")

var ATTACK_CD
var BULLET_SPEED
var BULLET_SIZE
var BULLET_DAMAGE

var can_attack

func _ready():
	set_stats(Global.HEALTH_HIGH, Global.SIZE_AVERAGE, 0, Global.DAMAGE_LOW, Global.AWARENESS_BIG)
	set_shooter_stats()
	can_attack = true


func set_shooter_stats(attack_cd = 2, bullet_speed = 200, bullet_size = 4, bullet_damage = Global.DAMAGE_AVERAGE):
	ATTACK_CD = attack_cd
	BULLET_SPEED = bullet_speed
	BULLET_SIZE = bullet_size
	BULLET_DAMAGE = bullet_damage


func _draw():
	draw_circle(Vector2.ZERO, SIZE, default_color)


func _physics_process(delta):
	move(delta)
	shoot()

func shoot():
	if _target and can_attack:
		var bullet = bullet_scene.instance()
		bullet.set_direction((_target.global_position - global_position).normalized())
		add_child(bullet)
		$AttackCooldown.start()
		can_attack = false


func _on_AttackArea_body_entered(body):
	if body is Player:
		attack(body)

func _on_AwarenessArea_body_entered(body):
	if body is Player:
		_target = body


func _on_FocusArea_body_exited(body):
	if body is Player and body == _target:
		_target = null


func _on_AttackCooldown_timeout():
	can_attack = true
	$AttackCooldown.stop()


""" Override"""
func flip_direction():
	return
