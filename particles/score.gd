extends ParticleDef
class_name Score


func init(particle: Particle, loc: Vector2, traj: Vector2, player: int, size: float, flags: int):
	particle.lifetime = 0.5
	particle.position = loc
	particle.traj = Vector2(0.0, -350.0)
	particle.player = -1
	particle.size = size
	particle.flags = flags

	var text = DynamicText.new()
	text.set_score(flags)
	text.size = 2.0
	text.justify = DynamicText.Justify.CENTER
	text.flashing = true
	text.flash_color_max = 1.0
	text.flash_color_min = 0.75
	text.flash_color_alpha = 0.8
	text.z_index = 8
	particle.add_child(text)
	.init(particle, loc, traj, player, size, flags)


func process(delta: float, particle: Particle):
	if particle.lifetime < 0.4:
		particle.traj.y = 0.0
	.process(delta, particle)


func destroy(particle: Particle):
	if particle.get_child_count() > 0:
		particle.get_child(0).queue_free()
	.destroy(particle)
