extends Monster
class_name Asteroid


func spawn(loc: Vector2, midspawn: bool = false):
	.spawn(loc, midspawn)
	var a = rand_range(0.0, PI * 2.0)
	_traj = Vector2(cos(a), sin(a))


func _ai(delta: float):
	_body.rotation += _atraj * delta
	while _body.rotation > (PI * 2.0):
		_body.rotation -= (PI * 2.0)
	while _body.rotation < 0.0:
		_body.rotation += (PI * 2.0)

	position += _traj * delta

	var width = 10.0	
	if position.x < -width:
		position.x = Map.MAP_SIZE.x + width
	if position.x > Map.MAP_SIZE.x + width:
		position.x = -width
	if position.y < -width:
		position.y = Map.MAP_SIZE.y + width
	if position.y > Map.MAP_SIZE.y + width:
		position.y = -width
