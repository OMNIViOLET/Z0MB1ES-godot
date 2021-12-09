extends Weapon
class_name WeaponShotty


func fire(world, player: int, loc: Vector2, angle: float):
	for i in range(0, 10):
		var a = angle
		a += rand_range(-0.2, 0.2)
		var shot = SHOT.instance() as Projectile
		shot.player = player
		shot.position = loc
		shot.traj = Vector2(cos(a), sin(a)) * -2000.0
		shot.rotation = shot.traj.angle() + PI
		world.add_projectile(shot)
	
	for i in range(0, 10):
		world.add_particle(
			ParticleCatalog.ParticleType.MUZZLE_FLASH,
			loc + ((float(i) + 20.0) * -2.0 * Vector2(cos(angle), sin(angle))),
			Vector2(cos(angle), sin(angle)) * 5.0,
			player,
			rand_range(0.0, 0.5),
			0
		)
