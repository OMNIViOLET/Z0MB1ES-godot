extends Resource
class_name Weapon

enum WeaponType {
	RIFLE,
	MACHINE_GUN,
	ROCKETS,
	FLAMETHROWER,
	SHOTTY,
	BEAM,
	NEUTRON
}

var FLAME = load("res://weapons/projectiles/flame.tscn")
var LASER_BEAM = load("res://weapons/projectiles/laser_beam.tscn")
var NEUTRON = load("res://weapons/projectiles/neutron.tscn")
var ROCKET = load("res://weapons/projectiles/rocket.tscn")
var SHOT = load("res://weapons/projectiles/shot.tscn")

export(WeaponType) var weapon_type = WeaponType.RIFLE
export(Resource) var sound_effect
export(float, 0.0, 1.0) var shoot_frame_time = 0.0


func fire(world, player: int, loc: Vector2, angle: float):
	pass
