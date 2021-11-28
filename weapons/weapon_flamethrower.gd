extends Weapon
class_name WeaponFlamethrower


func fire(world, player: int, loc: Vector2, angle: float):
	var flame = FLAME.instance() as Projectile
	flame.player = player
	flame.position = loc + Vector2(cos(angle), sin(angle)) * -26.0
	flame.traj = Vector2(cos(angle), sin(angle)) * -500.0
	flame.rotation = flame.traj.angle() + PI
	world.add_projectile(flame)
