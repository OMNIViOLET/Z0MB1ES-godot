extends Area2D
class_name Powerup

enum PowerupType {
	WEAPON_MACHINE_GUN,
	WEAPON_ROCKET,
	WEAPON_FLAME,
	WEAPON_SHOTTY,
	WEAPON_BEAM,
	WEAPON_NEUTRON,
	HELP_SPEEDUP,
	HELP_LIFE,
	FUN_SHIELD
}

var powerup_type = PowerupType.WEAPON_MACHINE_GUN setget _set_powerup_type, _get_powerup_type
var lifetime = 20.0
var speed = 100.0
var buf = 150.0
var exists = true
var pulse = 0.0

onready var _sprite1 := $Sprite1
onready var _sprite2 := $Sprite2
onready var _sfx := $SFX


func _process(delta):
	if position.x < buf:
		position.x += speed * delta
	if position.x > Map.MAP_SIZE.x - buf:
		position.x -= speed * delta
	if position.y < buf:
		position.y += speed * delta
	if position.y > Map.MAP_SIZE.y - buf:
		position.y -= speed * delta
	
	pulse += 1.5 * delta
	if pulse > 1.4:
		pulse = 1.0
	
	var a = min(0.15, lifetime * 5.0)
	if lifetime < 5.0:
		visible = int(lifetime * 6.0) % 2 == 0
	
	_sprite1.region_rect.position.x = powerup_type * 128.0
	_sprite1.scale = Vector2.ONE * pulse * 0.4
	_sprite1.modulate.a = a
	_sprite2.region_rect.position.x = powerup_type * 128.0
	_sprite2.scale = Vector2.ONE * 0.4
	_sprite2.modulate.a = min(1.0, lifetime * 5.0)
	
	lifetime -= delta
	if lifetime <= 0.0:
		exists = false
		queue_free()


func _set_powerup_type(type: int):
	powerup_type = type
	if type == PowerupType.HELP_LIFE:
		if Rand.coin_toss(0.7):
			powerup_type = randi() % 9


func _get_powerup_type() -> int:
	return powerup_type


func _on_Powerup_area_entered(area):
	var hero = area as Hero
	if not exists or not hero or not hero.exists:
		return
	
	exists = false
	match powerup_type:
		PowerupType.FUN_SHIELD:
			hero._spawn_frame = 10.0
		PowerupType.HELP_LIFE:
			Players.add_lives(hero.player, 1)
		PowerupType.HELP_SPEEDUP:
			hero._speed_frame = 30.0
		PowerupType.WEAPON_BEAM:
			hero.set_weapon(Weapon.WeaponType.BEAM, 50)
		PowerupType.WEAPON_FLAME:
			hero.set_weapon(Weapon.WeaponType.FLAMETHROWER, 250)
		PowerupType.WEAPON_MACHINE_GUN:
			hero.set_weapon(Weapon.WeaponType.MACHINE_GUN, 400)
		PowerupType.WEAPON_NEUTRON:
			hero.set_weapon(Weapon.WeaponType.NEUTRON, 60)
		PowerupType.WEAPON_ROCKET:
			hero.set_weapon(Weapon.WeaponType.ROCKETS, 50)
		PowerupType.WEAPON_SHOTTY:
			hero.set_weapon(Weapon.WeaponType.SHOTTY, 50)
	queue_free()
