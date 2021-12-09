extends ParticleDef
class_name Goo

var GOO = load("res://assets/gfx/goo.tres")


func init(particle: Particle, loc: Vector2, traj: Vector2, player: int, size: float, flags: int):
	particle.lifetime = rand_range(0.2, 0.5)
	particle.position = loc
	particle.traj = traj
	particle.player = -1
	particle.size = size
	particle.flags = Rand.rint(0, 3)
	particle.r = rand_range(0.0, 0.4)
	particle.g = rand_range(-10.0, 10.0)
	.init(particle, loc, traj, player, size, flags)


func render(particle: Particle):
	particle.texture = GOO
	particle.modulate = Color(1.0, 1.0, 1.0, min(1.0, particle.lifetime * 5.0))
	particle.scale = Vector2(particle.size, particle.size)
