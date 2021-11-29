extends Monster
class_name Zombie


func _process(delta):
	_body.scale = Vector2.ONE * 0.3 * (((0.5 - spawn_frame) * 2.0) if spawn_frame > 0.0 else 1.0)


func spawn(loc: Vector2, midspawn: bool = false):
	.spawn(loc, midspawn)
	if spawn_frame > 0.0:
		spawn_frame = 0.5


func _on_monster_hit(projectile: Projectile):
	Players.add_points(projectile.player, 100)
	_make_blood_chunks(position, projectile.traj)
	exists = false
	if Rand.coin_toss(0.01):
		world.make_goodie(position)
	._on_monster_hit(projectile)
