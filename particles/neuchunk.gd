extends ParticleDef
class_name Neuchunk

var SPRITES = [
	load("res://assets/gfx/muzzle_flash1.tres"),
	load("res://assets/gfx/muzzle_flash2.tres"),
]


func init(particle: Particle, loc: Vector2, traj: Vector2, player: int, size: float, flags: int):
	particle.lifetime = 0.5
	particle.position = loc
	particle.traj = traj
	particle.player = player
	particle.size = rand_range(0.0, 0.5)
	particle.rotation = traj.angle()
	particle.flags = 3
	particle.set_alpha(true)
	.init(particle, loc, traj, player, size, flags)


func render(particle: Particle):
	particle.texture = SPRITES[Rand.rint(0, 2)]
	particle.modulate = Color(0.7, 1.0, 0.7, particle.lifetime)
	particle.rotation = rand_range(0.0, PI * 2.0)
	particle.scale = Vector2(0.5, 0.1)
