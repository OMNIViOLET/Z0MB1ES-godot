extends ParticleDef
class_name FaceTrailParticle

var SPRITE = load("res://assets/gfx/face_trail.tres")


func init(particle: Particle, loc: Vector2, traj: Vector2, player: int, size: float, flags: int):
	particle.lifetime = 1.0
	particle.position = loc
	particle.traj = traj
	particle.player = player
	particle.size = size
	.init(particle, loc, traj, player, size, flags)


func process(delta: float, particle: Particle):
	particle.rotation += particle.r * delta
	.process(delta, particle)


func render(particle: Particle):
	particle.texture = SPRITE
	particle.modulate = Color(1.0, 1.0, 1.0, min(1.0, particle.lifetime * 5.0))
	particle.scale = Vector2(0.25, 0.25)
