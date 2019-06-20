extends Enemy
class_name LandShooter

export var default_color = Global.COLOR_RED

onready var bullet_scene = preload("res://enemies/AI/Bullet.tscn")

var BULLET_SPEED
var BULLET_SIZE
var BULLET_DAMAGE

onready var ledge_detector = $LedgeDetector

func set_shooter_stats(attack_cd = 2, bullet_speed = 100, bullet_size = 2, bullet_damage = Global.DAMAGE_AVERAGE):
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
	move(delta, false, _target)
	shoot()

func shoot():
	if _target and can_attack:
		flip_direction()
		var bullet = bullet_scene.instance()
		var bullet_direction = (_target.global_position - global_position).normalized()
		bullet.set_direction(bullet_direction) 
		get_parent().add_child(bullet)
		bullet.set_stats(self, BULLET_SIZE, BULLET_SPEED, BULLET_DAMAGE)
		bullet.global_position = self.global_position
		$AttackCooldown.start()
		can_attack = false