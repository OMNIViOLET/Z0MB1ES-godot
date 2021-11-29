extends Projectile
class_name Neutron

var _hits = 2

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


func pew():
	for i in range(0, 3):
		var t = Rand.vec2(-400.0, 400.0, -400.0, 400.0)
		for j in range(0, 3):
			world.add_particle(
				ParticleCatalog.ParticleType.NEUCHUNK,
				position,
				t,
				0, 
				0.0,
				0
		)
	_hits -= 1
	exists = _hits > 0
