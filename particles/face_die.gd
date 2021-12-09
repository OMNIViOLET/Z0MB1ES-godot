extends ParticleDef
class_name FaceDie

var SPRITES = load("res://assets/gfx/sprites.png")


func init(particle: Particle, loc: Vector2, traj: Vector2, player: int, size: float, flags: int):
	particle.lifetime = rand_range(0.25, 0.75)
	particle.position = loc
	particle.traj = traj
	particle.player = player
	particle.flags = Rand.rint(0, 2)
	particle.rotation = traj.angle()
	.init(particle, loc, traj, player, size, flags)


func render(particle: Particle):
	particle.texture = SPRITES
	particle.region_enabled = true
	particle.region_rect = Rect2(Rand.rint(0, 6) * 128, 1024.0, 128.0, 128.0)
	particle.modulate = Color(1.0, particle.flags, particle.flags, min(1.0, particle.lifetime * 5.0))
	particle.scale = Vector2(0.25, 0.25)
