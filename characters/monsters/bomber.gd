extends Monster
class_name Bomber


func _process(delta):
	_body.scale = Vector2.ONE * 0.35 * (((0.5 - spawn_frame) * 2.0) if spawn_frame > 0.0 else 1.0)


func spawn(loc: Vector2, midspawn: bool = false):
	.spawn(loc, midspawn)
	hp = 3
	if spawn_frame > 0.0:
		spawn_frame = 0.5
