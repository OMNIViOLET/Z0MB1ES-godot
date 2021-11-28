extends Projectile
class_name Rocket


func _process(delta):
	if world:
		world.add_particle(
			ParticleCatalog.ParticleType.EXPLODE, 
			position,
			traj * -0.1, 
			player,
			rand_range(0.2, 0.3),
			0
		)

		world.add_particle(
			ParticleCatalog.ParticleType.EXPLODE, 
			position - traj * delta * 0.5,
			traj * -0.1, 
			player,
			rand_range(0.2, 0.3),
			0
		)
	
