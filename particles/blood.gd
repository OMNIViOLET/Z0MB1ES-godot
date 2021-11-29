extends ParticleDef
class_name Blood

var SPRITES = load("res://assets/gfx/sprites.png")


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


func process(delta: float, particle: Particle):
	particle.rotation += particle.g * delta
	.process(delta, particle)


func render(particle: Particle):
	particle.texture = SPRITES
	particle.region_enabled = true
	particle.region_rect = Rect2(particle.flags * 128, 128.0, 128.0, 128.0)
	particle.modulate = Color(particle.r, 0.0, 0.0, min(1.0, particle.lifetime * 5.0))
	particle.scale = Vector2(particle.size, particle.size)
