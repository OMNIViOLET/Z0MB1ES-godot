extends Asteroid
class_name BigAsteroid


func spawn(loc: Vector2, midspawn: bool = false):
	.spawn(loc, midspawn)
	_traj *= 100.0
	_atraj = rand_range(-1.0, 1.0)
