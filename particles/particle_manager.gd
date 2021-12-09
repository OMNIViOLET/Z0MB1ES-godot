extends Node2D
class_name ParticleManager

const PARTICLE_COUNT = 2048

var PARTICLE = load("res://particles/particle.tscn")

var catalog = ParticleCatalog.new()
var particles = []


func _init():
	for i in PARTICLE_COUNT:
		var particle = PARTICLE.instance()
		particle.visible = false
		particles.append(particle)
		add_child(particle)


func _process(delta):
	for i in particles.size():
		var particle = particles[i] as Particle
		if not particle.exists:
			particle.set_alpha(false)
			particle.visible = false
			continue
		var def = catalog.get_particle_def(particle.particle_type)
		def.process(delta, particle)
		def.render(particle)


func add_particle(particle_type: int, loc: Vector2, traj: Vector2, player: int, size: float, flags: int):
	for i in particles.size():
		var particle = particles[i] as Particle
		if particle.exists:
			continue

		# Reset particle
		particle.texture = null
		particle.modulate = Color.white
		particle.position = Vector2.ZERO
		particle.rotation = 0.0
		particle.scale = Vector2.ONE
		particle.set_alpha(false)
		particle.region_enabled = false
		particle.region_rect = Rect2(0.0, 0.0, 0.0, 0.0)
		particle.particle_type = particle_type
		particle.visible = true

		var def = catalog.get_particle_def(particle_type)
		def.init(particle, loc, traj, player, size, flags)
		break
