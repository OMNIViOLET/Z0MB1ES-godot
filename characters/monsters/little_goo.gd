extends Monster
class_name LittleGoo


func _process(delta):
	_body.scale = Vector2(cos(_leg1.frame_time + rand_range(-0.5, 0.5)) * 0.25 + 0.7, 0.6)
	_body.scale *= 0.35 * (((0.5 - spawn_frame) * 2.0) if spawn_frame > 0.0 else 1.0)


func spawn(loc: Vector2, midspawn: bool = false):
	.spawn(loc, midspawn)
	_vtarg = loc + Rand.vec2(-100.0, 100.0, -100.0, 100.0)
	target = -1
	if spawn_frame > 0.0:
		spawn_frame = 0.5
