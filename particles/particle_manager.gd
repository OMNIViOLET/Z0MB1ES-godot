extends Node2D
class_name ParticleManager

const PARTICLE_COUNT = 2048

var PARTICLE = load("res://particles/particle.tscn")

var catalog = ParticleCatalog.new()
var particles = []


func _init():
	for i in PARTICLE_COUNT:
		particles.append(PARTICLE.instance())


func _process(delta):
	for i in particles.size():
		var particle = particles[i] as Particle
		if not particle.exists:
			particle.visible = false
			if is_a_parent_of(particle):
				remove_child(particle)
			continue
		if not is_a_parent_of(particle):
			particle.visible = true
			add_child(particle)
		particle.region_enabled = false
		var def = catalog.get_particle_def(particle.particle_type)
		def.process(delta, particle)
		def.render(particle)


func add_particle(particle_type: int, loc: Vector2, traj: Vector2, player: int, size: float, flags: int):
	for i in particles.size():
		var particle = particles[i] as Particle
		if particle.exists:
			continue
		particle.alpha = false
		var def = catalog.get_particle_def(particle_type)
		def.init(particle, loc, traj, player, size, flags)
		particle.particle_type = particle_type
		break
