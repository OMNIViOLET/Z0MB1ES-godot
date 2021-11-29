extends Monster
class_name Blartard


func _process(delta):
	_body.region_rect = Rect2(1152.0, 192.0 + (int(_blar_frame) * 128), 128.0, 128.0)


func _ai(delta: float):
	if spawn_frame <= 0.0:
		var pframe = _frame_time
		_frame_time -= delta

		_blar_frame += delta * 10.0
		if _blar_frame >= 4.0:
			_blar_frame -= 4.0
			
		position += Vector2(cos(_body.rotation), sin(_body.rotation)) * delta * 80.0
			
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
