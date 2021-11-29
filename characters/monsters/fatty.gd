extends Monster
class_name Fatty


func _process(delta):
	_body.scale = Vector2.ONE * 0.3 * (((0.5 - spawn_frame) * 2.0) if spawn_frame > 0.0 else 1.0)


func spawn(loc: Vector2, midspawn: bool = false):
	.spawn(loc, midspawn)
	hp = 5
	if spawn_frame > 0.0:
		spawn_frame = 0.5


func _on_monster_hit(projectile: Projectile):
	hp -= 1
	if hp <= 0:
		Players.add_points(projectile.player, 500)
		_make_blood_chunks(position, projectile.traj)
		_make_blood_splode(position, 10, rand_range(0.5, 1.0), 300.0)
		exists = false
		if Rand.coin_toss(0.4):
			world.make_goodie(position)
		queue_free()
	else:
		_make_blood_splode(projectile.position, 3, 0.2, 150.0)
		position += projectile.traj * 0.002
	._on_monster_hit(projectile)

