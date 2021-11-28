extends Projectile
class_name Neutron


onready var _ball1 := $Ball1
onready var _ball2 := $Ball2
onready var _ball3 := $Ball3


func _process(delta):
	_randomize_ball(_ball1)
	_randomize_ball(_ball2)
	_randomize_ball(_ball3)


func _randomize_ball(ball: Sprite):
	ball.region_rect.position.x = (randi() % 2) * 128.0
	ball.rotation = rand_range(0.0, PI * 2.0)
