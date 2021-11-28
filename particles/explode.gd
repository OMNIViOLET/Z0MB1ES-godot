extends ParticleDef
class_name Explode

var SPRITES = load("res://assets/gfx/sprites.png")


func init(particle: Particle, loc: Vector2, traj: Vector2, player: int, size: float, flags: int):
	particle.lifetime = rand_range(0.4, 0.5)
	particle.position = loc
	particle.traj = traj
	particle.player = player
	particle.size = size
	particle.r = rand_range(-1.0, 1.0)
	.init(particle, loc, traj, player, size, flags)


func process(delta: float, particle: Particle):
	particle.rotation += particle.r * delta
	.process(delta, particle)


func render(particle: Particle):
	var a = int((0.5 - particle.lifetime) * 2.0 * 9.0)
	particle.texture = SPRITES
	particle.region_enabled = true
	particle.region_rect = Rect2(1024.0, a * 64.0, 64.0, 64.0)	
	particle.modulate = Color(1.0, 1.0, 1.0, 0.7)
	particle.scale = Vector2(particle.size, particle.size)
