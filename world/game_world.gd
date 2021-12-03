extends Node2D
class_name GameWorld

var HERO = load("res://characters/hero.tscn")

onready var _camera := $Camera2D
onready var _heroes := $Heroes
onready var _projectiles := $Projectiles
onready var _powerups := $Powerups
onready var _alpha_particle_manager := $AlphaParticleManager
onready var _additive_particle_manager := $AdditiveParticleManager
onready var _time_manager := $Managers/TimeManager
onready var _spawn_manager := $Managers/SpawnManager


func _ready():
	_time_manager.connect("beat", self, "_on_beat")
	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")

	for i in Players.active_players:
		var hero = HERO.instance() as Hero
		hero.world = self
		hero.set_player(i)
		hero.spawn_center()
		_heroes.add_child(hero)


func _process(delta):
	_camera.position = _heroes.get_child(0).position


func make_goodie(loc: Vector2):
	_spawn_manager.make_goodie(loc)


func spawn(loc: Vector2, monster_type: int, midspawn: bool = false):
	_spawn_manager._make_monster(loc, monster_type, midspawn)


func get_hero(player: int) -> Hero:
	for i in _heroes.get_child_count():
		var hero = _heroes.get_child(i) as Hero
		if hero.player == player:
			return hero
	return null


func add_particle(particle_type: int, loc: Vector2, traj: Vector2, player: int, size: float, flags: int):
	match particle_type:
		ParticleCatalog.ParticleType.BLOOD:
			_alpha_particle_manager.add_particle(particle_type, loc, traj, player, size, flags)
		ParticleCatalog.ParticleType.DYING:
			_alpha_particle_manager.add_particle(particle_type, loc, traj, player, size, flags)
		ParticleCatalog.ParticleType.EXPLODE:
			_alpha_particle_manager.add_particle(particle_type, loc, traj, player, size, flags)
		ParticleCatalog.ParticleType.FACE_DIE:
			_alpha_particle_manager.add_particle(particle_type, loc, traj, player, size, flags)
		ParticleCatalog.ParticleType.FACE_TRAIL:
			_alpha_particle_manager.add_particle(particle_type, loc, traj, player, size, flags)
		ParticleCatalog.ParticleType.GEOBIT:
			_additive_particle_manager.add_particle(particle_type, loc, traj, player, size, flags)
		ParticleCatalog.ParticleType.GOO:
			_alpha_particle_manager.add_particle(particle_type, loc, traj, player, size, flags)
		ParticleCatalog.ParticleType.MUZZLE_FLASH:
			_additive_particle_manager.add_particle(particle_type, loc, traj, player, size, flags)
		ParticleCatalog.ParticleType.NEUCHUNK:
			_additive_particle_manager.add_particle(particle_type, loc, traj, player, size, flags)
		ParticleCatalog.ParticleType.PIXEL:
			_alpha_particle_manager.add_particle(particle_type, loc, traj, player, size, flags)
		ParticleCatalog.ParticleType.POWERUP:
			_alpha_particle_manager.add_particle(particle_type, loc, traj, player, size, flags)
		ParticleCatalog.ParticleType.SCORE:
			_alpha_particle_manager.add_particle(particle_type, loc, traj, player, size, flags)


func add_projectile(projectile: Projectile):
	_projectiles.add_child(projectile)


func _on_beat(phase: int, beat: int):
	_spawn_manager.do_click(phase, beat)


func _on_joy_connection_changed(device: int, connected: bool):
	print("joy ", device, " ", "connected" if connected else "disconnected")
