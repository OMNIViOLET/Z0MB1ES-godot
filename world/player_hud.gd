extends Node2D
class_name PlayerHud

export(int) var slot = 0
export(NodePath) var heroes_path

onready var _heroes := get_node(heroes_path)
onready var _name := get_node("PlayerName")
onready var _lives := get_node("Lives")
onready var _score := get_node("Score")
onready var _weapon := get_node("Weapon")
onready var _ammo := get_node("Ammo")
onready var _initials := get_node("Initials")


func _ready():
	_set_visibility()
	_update_hud()


func _process(delta):
	_set_visibility()
	_update_hud()


func _input(event):
	var player_device_id = Players.get_slot_device(slot)
	var keyboard = Players.get_slot_device_type(slot) == PlayerInfo.DeviceType.KEYBOARD
	if event.device != player_device_id or (keyboard and not event is InputEventKey):
		return

	var hero = _get_hero()
	if not hero:
		return
		
	if hero.name_in > 0:
		if hero.name_in < 4:
			if Input.is_action_just_pressed("ui_up"):
				var o = ord(hero.initials[hero.name_in - 1])
				o += 1
				if o > 90:
					o = 65
				hero.initials[hero.name_in - 1] = char(o)
			if Input.is_action_just_pressed("ui_down"):
				var o = ord(hero.initials[hero.name_in - 1])
				o -= 1
				if o < 65:
					o = 90
				hero.initials[hero.name_in - 1] = char(o)
			if hero.name_in == 1:
				hero.initials[1] = '-'
				hero.initials[2] = '-'
			elif hero.name_in == 2:
				hero.initials[2] = '-'
			
			if Input.is_action_just_pressed("ui_accept"):
				hero.name_in += 1
				if hero.name_in == 4:
					var player_name = hero.initials[0] + hero.initials[1] + hero.initials[2]
					HighScores.add_score(player_name, Players.get_points(hero.player))
				else:
					hero.initials[hero.name_in - 1] = 'A'
			if Input.is_action_just_pressed("ui_cancel"):
				if hero.name_in > 1:
					hero.name_in -= 1


func _update_hud():
	_name.text = Players.get_player_info(slot).player_name
	_name.modulate = Players.get_player_info(slot).color
	_lives.text = "x%d" % Players.get_lives(slot)
	_lives.modulate = Players.get_player_info(slot).color
	_score.text = str(Players.get_points(slot))
	_weapon.visible = false
	_ammo.visible = false

	var hero = _get_hero()
	if hero:
		if hero._weapon != Weapon.WeaponType.RIFLE:
			_weapon.region_rect.position.x = (hero._weapon - 1) * 128
			_ammo.text = str(hero._ammo)
			_weapon.visible = true
			_ammo.visible = true


func _get_hero() -> Hero:
	for i in _heroes.get_child_count():
		var hero = _heroes.get_child(i) as Hero
		if hero and hero.player == slot:
			return hero
	return null


func _set_visibility():
	var hero = _get_hero()
	visible = hero and hero.exists
	if hero and hero.name_in > 0:
		_initials.visible = true
		_initials.text = hero.initials[0] + hero.initials[1] + hero.initials[2]
		_initials.flashing_character = hero.name_in - 1
	else:
		_initials.visible = false
