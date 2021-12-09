extends Resource
class_name ParticleDef


func init(particle: Particle, loc: Vector2, traj: Vector2, player: int, size: float, flags: int):
	particle.exists = true


func process(delta: float, particle: Particle):
	particle.position += particle.traj * delta
	particle.lifetime -= delta
	if particle.lifetime < 0.0:
		destroy(particle)


func render(particle: Particle):
	pass


func destroy(particle: Particle):
	particle.exists = false
