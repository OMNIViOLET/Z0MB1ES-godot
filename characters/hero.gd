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
var lives = 0
var player = 0
var player_tag = ""
var world = null
var score = 0

var _angle = 0.0
var _respawn_frame = 0.0
var _shoot = Vector2.ZERO
var _shoot_frame = 0.0
var _spawn_frame = 0.0
var _speed_frame = 0.0
var _traj = Vector2.ZERO
var _weapon = Weapon.WeaponType.RIFLE
var _ammo = 0


onready var _body := $Body
onready var _leg1 := $Leg1
onready var _leg2 := $Leg2
onready var _collider := $Collider
onready var _sfx := $SFX


func _ready():
	_body.texture = HEROES[player]


func _process(delta):
	if not exists or _respawn_frame > 0.0:
		_hide_player()
	else:
		_show_player()
	
	_check_respawn(delta)
	_check_spawn(delta)
	
	if not exists:
		return
	
	_handle_input()
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
	lives = 5
	position = loc
	exists = true
	set_weapon(Weapon.WeaponType.RIFLE, 0)
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


func _check_respawn(delta):
	if _respawn_frame > 0.0:
		_respawn_frame -= delta
		if _respawn_frame <= 0.0:
			_spawn_frame = 5.0
			position = _get_spawn_location()
		else:
			return


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
		
