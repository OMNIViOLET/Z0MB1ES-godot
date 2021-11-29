extends Asteroid
class_name LittleAsteroid


func spawn(loc: Vector2, midspawn: bool = false):
	.spawn(loc, midspawn)
	_traj *= 200.0
	_atraj = rand_range(-3.0, 3.0)
