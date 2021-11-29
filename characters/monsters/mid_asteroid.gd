extends Asteroid
class_name MidAsteroid


func spawn(loc: Vector2, midspawn: bool = false):
	.spawn(loc, midspawn)
	_traj *= 150.0
	_atraj = rand_range(-2.0, 2.0)
