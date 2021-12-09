extends Asteroid
class_name MidAsteroid


func spawn(loc: Vector2, midspawn: bool = false):
	.spawn(loc, midspawn)
	_traj *= 150.0
	_atraj = rand_range(-2.0, 2.0)


func _on_monster_hit(projectile: Projectile):
	exists = false
	
	for i in range(0, 3):
		world.spawn(position, Monster.MonsterType.LITTLE_ASTEROID)
	_make_pixel_splode(projectile.position, 7, rand_range(0.3, 0.7), 300.0)
	_add_points(projectile.player, 150)
	if Rand.coin_toss(0.02):
		world.make_goodie(position)
	._on_monster_hit(projectile)
