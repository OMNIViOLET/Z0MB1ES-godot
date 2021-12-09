extends ParticleDef
class_name Geobit

var GEOBIT = load("res://assets/gfx/geobit.tres")


func init(particle: Particle, loc: Vector2, traj: Vector2, player: int, size: float, flags: int):
	particle.lifetime = rand_range(0.2, 0.5)
	particle.position = loc
	particle.traj = traj
	particle.player = -1
	particle.size = size
	particle.r = rand_range(0.0, PI * 2.0)
	particle.g = rand_range(-5.0, 5.0)
	.init(particle, loc, traj, player, size, flags)


func process(delta: float, particle: Particle):
	particle.rotation += particle.g * delta
	.process(delta, particle)


func render(particle: Particle):
	particle.texture = GEOBIT
	particle.modulate = Color(
		0.7 + 0.3 * sin(particle.r + particle.lifetime), 
		0.7 + 0.3 * sin(particle.r + particle.lifetime + 2.0), 
		0.7 + 0.3 * sin(particle.r + particle.lifetime + 4.0), 
		min(1.0, particle.lifetime * 5.0)
	)
	particle.scale = Vector2(particle.size, particle.size) * Vector2(1.0, 0.5)
