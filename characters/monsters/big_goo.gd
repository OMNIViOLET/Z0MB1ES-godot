extends Monster
class_name BigGoo


func _process(delta):
	_body.scale = Vector2(cos(_leg1.frame_time + rand_range(-0.5, 0.5)) * 0.08 + 0.7, 0.6)
	_body.scale *= 0.9 * (((0.5 - spawn_frame) * 2.0) if spawn_frame > 0.0 else 1.0)


func spawn(loc: Vector2, midspawn: bool = false):
	.spawn(loc, midspawn)
	hp = 10.0
	if spawn_frame > 0.0:
		spawn_frame = 0.5


func _on_monster_hit(projectile: Projectile):
	hp -= 1
	if hp <= 0:
		_make_goo(projectile.position, 10, rand_range(0.5, 1.0), 300.0)
		_add_points(projectile.player, 100)
		exists = false
		if Rand.coin_toss(0.4):
			world.make_goodie(position)
	else:
		_make_goo(projectile.position, 3, 0.2, 50.0)
		position += projectile.traj * 0.002
		
		for i in range(0, 3):
			world.spawn(position + Rand.vec2(-20.0, 20.0, -20.0, 20.0), Monster.MonsterType.LITTLE_GOO, true)
	._on_monster_hit(projectile)
