extends Asteroid
class_name BigAsteroid


func spawn(loc: Vector2, midspawn: bool = false):
	.spawn(loc, midspawn)
	_traj *= 100.0
	_atraj = rand_range(-1.0, 1.0)


func _on_monster_hit(projectile: Projectile):
	exists = false
	
	for i in range(0, 4):
		world.spawn(position, Monster.MonsterType.MID_ASTEROID)
	_make_pixel_splode(projectile.position, 10, rand_range(0.4, 1.0), 500.0)
	_add_points(projectile.player, 200)
	if Rand.coin_toss(0.1):
		world.make_goodie(position)
	._on_monster_hit(projectile)
	
