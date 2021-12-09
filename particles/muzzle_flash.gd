extends ParticleDef
class_name MuzzleFlash

var MUZZLE_FLASHES = [
	load("res://assets/gfx/muzzle_flash1.tres"),
	load("res://assets/gfx/muzzle_flash2.tres")
]


func init(particle: Particle, loc: Vector2, traj: Vector2, player: int, size: float, flags: int):
	particle.lifetime = 0.1
	particle.position = loc
	particle.traj = traj
	particle.player = player
	particle.size = size
	particle.flags = randi() % 2
	particle.set_alpha(true)
	particle.g = rand_range(-10.0, 10.0)
	.init(particle, loc, traj, player, size, flags)


func process(delta: float, particle: Particle):
	particle.rotation += particle.g * delta
	.process(delta, particle)


func render(particle: Particle):
	particle.texture = MUZZLE_FLASHES[particle.flags]
	particle.modulate = Color(
		1.0, 
		min(1.0, particle.lifetime * 40.0),
		min(1.0, particle.lifetime * 20.0), 
		min(1.0, particle.lifetime * 10.0)
	)
	particle.scale = Vector2(particle.size, particle.size)
