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


func _ready():
	_set_visibility()
	_update_hud()


func _process(delta):
	_set_visibility()
	_update_hud()


func _update_hud():
	_name.text = Players.get_player_info(slot).player_name
	_lives.text = "x%d" % Players.get_lives(slot)
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
