extends Weapon
class_name WeaponRifle


func fire(world, player: int, loc: Vector2, angle: float):
	var shot = SHOT.instance() as Projectile
	shot.player = player
	shot.position = loc
	shot.traj = Vector2(cos(angle), sin(angle)) * -2000.0
	shot.rotation = shot.traj.angle() + PI
	world.add_projectile(shot)
	
	for i in 10:
		world.add_particle(
			ParticleCatalog.ParticleType.MUZZLE_FLASH,
			loc + ((float(i) + 20.0) * -2.0 * Vector2(cos(angle), sin(angle))),
			Vector2(cos(angle), sin(angle)) * 5.0,
			player,
			rand_range(0.0, 0.5),
			0
		)
