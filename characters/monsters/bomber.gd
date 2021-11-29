extends Monster
class_name Bomber

onready var _explode := $ExplodeFX


func _process(delta):
	_body.scale = Vector2.ONE * 0.35 * (((0.5 - spawn_frame) * 2.0) if spawn_frame > 0.0 else 1.0)


func spawn(loc: Vector2, midspawn: bool = false):
	.spawn(loc, midspawn)
	hp = 3
	if spawn_frame > 0.0:
		spawn_frame = 0.5


func _on_monster_hit(projectile: Projectile):
	hp -= 1
	if hp <= 0:
		for i in range(0, 10):
			world.add_particle(
				ParticleCatalog.ParticleType.EXPLODE,
				position,
				Rand.vec2(-200.0, 200.0, -200.0, 200.0),
				0,
				rand_range(1.3, 2.0),
				0
			)
		_explode.play()
		Players.add_points(projectile.player, 500)
		exists = false
		if Rand.coin_toss(0.1):
			world.make_goodie(position)
	else:
		_make_blood_splode(projectile.position, 3, 0.2, 150.0)
		position += projectile.traj * 0.002
