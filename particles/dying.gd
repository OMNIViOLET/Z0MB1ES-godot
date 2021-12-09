extends ParticleDef
class_name Dying


func init(particle: Particle, loc: Vector2, traj: Vector2, player: int, size: float, flags: int):
	particle.lifetime = 2.0
	particle.position = loc
	particle.traj = Vector2.ZERO
	particle.player = -1
	particle.size = size

	var text = DynamicText.new()
	text.text = "DEDZ!!1"
	text.size = 5.0
	text.justify = DynamicText.Justify.CENTER
	text.flashing = true
	text.flash_color_max = 1.0
	text.flash_color_min = 0.75
	text.flash_color_alpha = 0.8
	text.z_index = 8
	particle.add_child(text)
	.init(particle, loc, traj, player, size, flags)


func destroy(particle: Particle):
	if particle.get_child_count() > 0:
		particle.get_child(0).queue_free()
	.destroy(particle)
