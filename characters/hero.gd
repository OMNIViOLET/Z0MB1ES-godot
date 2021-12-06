extends Area2D
class_name Hero

const BOUNDRY_BUFFER = 100.0
const SPEED_NORMAL = 140.0
const SPEED_FAST = 240.0

var HEROES = [
	load("res://assets/gfx/hero1.tres"),
	load("res://assets/gfx/hero2.tres"),
	load("res://assets/gfx/hero3.tres"),
	load("res://assets/gfx/hero4.tres")
]

var WEAPONS = {
	Weapon.WeaponType.BEAM: load("res://weapons/weapon_beam.tres"),
	Weapon.WeaponType.FLAMETHROWER: load("res://weapons/weapon_flamethrower.tres"),
	Weapon.WeaponType.MACHINE_GUN: load("res://weapons/weapon_machine_gun.tres"),
	Weapon.WeaponType.NEUTRON: load("res://weapons/weapon_neutron.tres"),
	Weapon.WeaponType.RIFLE: load("res://weapons/weapon_rifle.tres"),
	Weapon.WeaponType.ROCKETS: load("res://weapons/weapon_rockets.tres"),
	Weapon.WeaponType.SHOTTY: load("res://weapons/weapon_shotty.tres")
}

var exists = false
var player = 0
var player_tag = ""
var world = null
var score = 0
var respawn_frame = 0.0
var initials = [ 'A', 'A', 'A' ]
var name_in: int = 0

var _angle = 0.0
var _shoot = Vector2.ZERO
var _shoot_frame = 0.0
var _spawn_frame = 0.0
var _speed_frame = 0.0
var _traj = Vector2.ZERO
var _weapon = Weapon.WeaponType.RIFLE
var _ammo = 0
var _colliding = []


onready var _body := $Body
onready var _leg1 := $Leg1
onready var _leg2 := $Leg2
onready var _collider := $Collider
onready var _underglow := $Underglow
onready var _sfx := $SFX
onready var _shield1 := $Shield1
onready var _shield2 := $Shield1


func _ready():
	initials.append(65)
	initials.append(65)
	initials.append(65)

	_body.texture = HEROES[player]
	_underglow.player = player
	_shield1.player = player
	_shield2.player = player


func _process(delta):
	if not exists or respawn_frame > 0.0:
		_hide_player()
	else:
		_show_player()

	if name_in > 0:
		if name_in >= 4:
			respawn_frame -= delta
			if respawn_frame <= 0.0:
				exists = false
		return
	
	if not _check_respawn(delta):
		return
		
	_check_spawn(delta)
	
	if not exists:
		return
	
	_handle_input()
	
	if _spawn_frame > 0.0:
		var circle = _collider.shape as CircleShape2D
		circle.radius = 50
		_shield1.visible = true
		_shield2.visible = true
		var a1 = _spawn_frame + (0 * 0.2)
		while a1 > 0.4:
			a1 -= 0.4
		var a2 = _spawn_frame + (1 * 0.2)
		while a2 > 0.4:
			a2 -= 0.4
		_shield1.size = a1
		_shield2.size = a2
	else:
		var circle = _collider.shape as CircleShape2D
		circle.radius = 20
		_shield1.visible = false
		_shield2.visible = false


func _physics_process(delta):
	if not exists or respawn_frame > 0.0:
		return
		
	_shoot_and_move(delta)


func add_points(loc: Vector2, points: int):
	#TODO: Particles
	score += points


func set_player(player: int):
	self.player = player
	if _body:
		_body.texture = HEROES[player]


func set_weapon(weapon: int, ammo: int):
	if _weapon == weapon:
		_ammo += ammo
	else:
		_weapon = weapon
		_ammo = ammo


func spawn_center():
	spawn(_get_spawn_location())


func spawn(loc: Vector2):
	Players.set_lives(player, 5)
	position = loc
	exists = true
	set_weapon(Weapon.WeaponType.SHOTTY, 999)
	score = 0


func _hide_player():
	visible = false
	_collider.disabled = true


func _show_player():
	visible = true
	_collider.disabled = false


func _get_spawn_location() -> Vector2:
	randomize()
	var offset = Vector2(rand_range(-200.0, 200.0), rand_range(-200.0, 200.0))
	return (Map.MAP_SIZE * 0.5) + offset


func _check_respawn(delta) -> bool:
	if respawn_frame > 0.0:
		respawn_frame -= delta
		if respawn_frame <= 0.0:
			_spawn_frame = 5.0
			position = _get_spawn_location()
		else:
			return false
	return true


func _check_spawn(delta):
	if _spawn_frame > 0.0:
		_spawn_frame -= delta


func _handle_input():
	var device_id = Players.get_slot_device(player)
	if device_id == Players.DEVICE_NOT_ASSIGNED:
		return
		
	var device_type = Players.get_slot_device_type(player)
	match device_type:
		PlayerInfo.DeviceType.JOYPAD:
			_traj = Vector2(Input.get_joy_axis(device_id, JOY_AXIS_0), Input.get_joy_axis(device_id, JOY_AXIS_1))
			if _traj.length() < 0.1:
				_traj = Vector2.ZERO
			_shoot = Vector2(Input.get_joy_axis(device_id, JOY_AXIS_2), Input.get_joy_axis(device_id, JOY_AXIS_3))
			if _shoot.length() < 0.1:
				_shoot = Vector2.ZERO
		PlayerInfo.DeviceType.KEYBOARD:
			_traj = Input.get_vector("move_left", "move_right", "move_up", "move_down")
			if Input.is_action_pressed("shoot"):
				_shoot = (get_global_mouse_position() - global_position).normalized()
			else:
				_shoot = Vector2.ZERO


func _shoot_and_move(delta):
	_leg1.traj = _traj
	_leg2.traj = _traj

	var speed = SPEED_NORMAL
	if _speed_frame > 0.0:
		_speed_frame -= delta
		speed = SPEED_FAST

	position += _traj * delta * speed
	
	var goal_angle = _body.rotation
	if _shoot.length() > 0.1:
		goal_angle = _shoot.angle() + PI
		if _shoot_frame <= 0.0 and _shoot.length() > 0.9:
			_angle = goal_angle
			var t_shoot = _shoot.normalized()
			
			var weapon_def = WEAPONS[_weapon] as Weapon
			_shoot_frame = weapon_def.shoot_frame_time
			_sfx.volume_db = weapon_def.volume_db
			_sfx.stream = weapon_def.sound_effect
			_sfx.play()
			
			weapon_def.fire(world, player, position, _angle)
			
			if _weapon != Weapon.WeaponType.RIFLE:
				_ammo -= 1
				if _ammo <= 0:
					_weapon = Weapon.WeaponType.RIFLE
	elif _traj.length() > 0.0:
		goal_angle = _traj.angle() + PI
		goal_angle += sin(_leg1.frame_time) * 0.1

	if _shoot_frame > 0.0:
		_shoot_frame -= delta
	
	var diff = goal_angle - _angle
	while diff < -PI:
		diff += PI * 2.0
	while diff > PI:
		diff -= PI * 2.0
	
	_angle += diff * delta * 20.0
	
	if position.x < BOUNDRY_BUFFER:
		position.x = BOUNDRY_BUFFER
	if position.y < BOUNDRY_BUFFER:
		position.y = BOUNDRY_BUFFER
	if position.x > (Map.MAP_SIZE.x - BOUNDRY_BUFFER):
		position.x = Map.MAP_SIZE.x - BOUNDRY_BUFFER
	if position.y > (Map.MAP_SIZE.y - BOUNDRY_BUFFER):
		position.y = Map.MAP_SIZE.y - BOUNDRY_BUFFER
	
	_body.rotation = _angle
	
	for monster in _colliding:
		if monster and monster.exists:
			_hit_monster(monster)


func _kill():
	Players.add_lives(player, -1)
	_weapon = Weapon.WeaponType.RIFLE
	_speed_frame = 0.0
	_make_blood_splode(position, 10, rand_range(0.5, 1.0), 300.0)
	world.add_particle(
		ParticleCatalog.ParticleType.DYING,
		position,
		Vector2.ZERO,
		player,
		0.0,
		0
	)
	
	respawn_frame = 3.0
	if Players.get_lives(player) <= 0:
		name_in = true
		initials[0] = 'A'
		initials[1] = 'A'
		initials[2] = 'A'


func _make_blood_splode(loc: Vector2, reps: int, size: float, traj: float):
	for i in range(0, reps):
		world.add_particle(
			ParticleCatalog.ParticleType.BLOOD,
			loc,
			Rand.vec2(-traj, traj, -traj, traj),
			0,
			size,
			0
		)


func _on_Hero_area_entered(area):
	if not exists or respawn_frame > 0.0:
		return
		
	var monster = area as Monster
	if not monster or not monster.exists or monster._grace > 0.0:
		return
	
	if _spawn_frame > 0.0:
		_hit_monster(monster)
		if monster.exists:
			_colliding.append(monster)
	else:
		_kill()


func _hit_monster(monster: Monster):
	var projectile = Projectile.new()
	projectile.position = position
	projectile.traj = monster.position - position
	projectile.player = player
	monster._on_monster_hit(projectile)


func _on_Hero_area_exited(area):
	var monster = area as Monster
	if monster:
		_colliding.erase(monster)
