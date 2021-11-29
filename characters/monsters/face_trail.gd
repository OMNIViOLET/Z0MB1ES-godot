extends Monster
class_name FaceTrail


func _process(delta):
	modulate = Color(1.0, int(spawn_frame * 8.0) % 2, int(spawn_frame * 8.0) % 2, 1.0) if spawn_frame > 0.0 else Color.red


func spawn(loc: Vector2, midspawn: bool = false):
	.spawn(loc, midspawn)
	_frame_time = 0.1
	_iangle = Rand.rint(0, 4)
	_body.rotation = _iangle * 1.57
	hp = 5.0


func _ai(delta: float):
	if spawn_frame <= 0.0:
		var pframe = _frame_time
		_frame_time -= delta
		
		if int(_frame_time * 10.0) != int(pframe * 10.0):
			world.add_particle(ParticleCatalog.ParticleType.FACE_TRAIL, position, Vector2.ZERO, idx, 0.0, 0)
			position += Vector2(cos(_body.rotation), sin(_body.rotation)) * Vector2(25.0, 33.0)
		if _frame_time < 0.0:
			_frame_time += Rand.rint(5, 10) * 0.1
			if Rand.coin_toss(0.5):
				_iangle = (_iangle + 1) % 4
			else:
				_iangle = (_iangle + 3) % 4
			
			var fbuf = 200.0
			if position.x > Map.MAP_SIZE.x - fbuf:
				if _iangle == 0:
					_iangle = 2
			if position.x < fbuf:
				if _iangle == 2:
					_iangle = 0
			if position.y > Map.MAP_SIZE.y - fbuf:
				if _iangle == 1:
					_iangle = 3
			if position.y < fbuf:
				if _iangle == 3:
					_iangle = 1
			_body.rotation = _iangle * 1.57
