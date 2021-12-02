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
		particle.visible = true
		particle.region_enabled = false
		var def = catalog.get_particle_def(particle.particle_type)
		def.process(delta, particle)
		def.render(particle)


func add_particle(particle_type: int, loc: Vector2, traj: Vector2, player: int, size: float, flags: int):
	for i in particles.size():
		var particle = particles[i] as Particle
		if particle.exists:
			continue
		# Reset particle
		particle.set_alpha(false)
		particle.modulate = Color.white
		particle.texture = null
		particle.rotation = 0.0
		particle.scale = Vector2.ONE
		var def = catalog.get_particle_def(particle_type)
		def.init(particle, loc, traj, player, size, flags)
		particle.particle_type = particle_type
		break
