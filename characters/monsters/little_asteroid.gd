extends Asteroid
class_name LittleAsteroid


func spawn(loc: Vector2, midspawn: bool = false):
	.spawn(loc, midspawn)
	_traj *= 200.0
	_atraj = rand_range(-3.0, 3.0)


func _on_monster_hit(projectile: Projectile):
	exists = false
	_make_pixel_splode(projectile.position, 5, rand_range(0.3, 0.4), 200.0)
	_add_points(projectile.player, 50)
	if Rand.coin_toss(0.02):
		world.make_goodie(position)
	._on_monster_hit(projectile)
