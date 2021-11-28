extends Weapon
class_name WeaponBeam


func fire(world, player: int, loc: Vector2, angle: float):
	var laser = LASER_BEAM.instance() as Projectile
	laser.player = player
	laser.position = loc + Vector2(cos(angle), sin(angle)) * -26.0
	laser.traj = Vector2(cos(angle), sin(angle)) * -2000.0
	laser.rotation = laser.traj.angle() + PI
	world.add_projectile(laser)

