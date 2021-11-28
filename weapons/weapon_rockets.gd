extends Weapon
class_name WeaponRockets


func fire(world, player: int, loc: Vector2, angle: float):
	var rocket = ROCKET.instance() as Projectile
	rocket.world = world
	rocket.player = player
	rocket.position = loc + Vector2(cos(angle), sin(angle)) * -26.0
	rocket.traj = Vector2(cos(angle), sin(angle)) * -1100.0
	rocket.rotation = rocket.traj.angle() + PI
	world.add_projectile(rocket)
