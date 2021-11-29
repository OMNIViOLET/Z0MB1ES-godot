extends Projectile
class_name Rocket

onready var _explode := $ExplodeFX


func _process(delta):
	if world:
		world.add_particle(
			ParticleCatalog.ParticleType.EXPLODE, 
			position,
			traj * -0.1, 
			player,
			rand_range(0.2, 0.3),
			0
		)

		world.add_particle(
			ParticleCatalog.ParticleType.EXPLODE, 
			position - traj * delta * 0.5,
			traj * -0.1, 
			player,
			rand_range(0.2, 0.3),
			0
		)


func explode():
	for i in range(0, 10):
		world.add_particle(
			ParticleCatalog.ParticleType.EXPLODE,
			position,
			Rand.vec2(-200.0, 200.0, -200.0, 200.0),
			0,
			rand_range(1.3, 2.0),
			0
		)
	_explode.play()
	
	var monsters = get_tree().get_nodes_in_group("monster")
	for monster in monsters:
		if not monster.exists:
			continue
		var diff = monster.position - position
		if diff.length_squared() < 10000.0:
			while monster.exists:
				monster._on_monster_hit(self)
