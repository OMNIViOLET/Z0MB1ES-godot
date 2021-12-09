extends Weapon
class_name WeaponNeutron


func fire(world, player: int, loc: Vector2, angle: float):
	for i in range(-1, 2):
		var sangle = angle + (i * 0.3)
		var neutron = NEUTRON.instance() as Projectile
		neutron.world = world
		neutron.player = player
		neutron.position = loc + Vector2(cos(sangle), sin(sangle)) * -26.0
		neutron.traj = Vector2(cos(sangle), sin(sangle)) * -1300.0
		neutron.rotation = neutron.traj.angle() + PI
		world.add_projectile(neutron)

