extends Node2D
class_name GameWorld

var HERO = load("res://characters/hero.tscn")

var _last_analog_traj = Vector2.ZERO
var _last_analog_shoot = Vector2.ZERO

onready var _game := $Game
onready var _camera := $Game/Camera2D
onready var _heroes := $Game/Heroes
onready var _projectiles := $Game/Projectiles
onready var _powerups := $Game/Powerups
onready var _particle_manager := $Game/Particles
onready var _time_manager := $Managers/TimeManager
onready var _spawn_manager := $Managers/SpawnManager
onready var _pause := $HUD/Pause


func _ready():
	_time_manager.connect("beat", self, "_on_beat")
	_spawn_manager.connect("the_end_is_nigh", self, "_on_the_end")
	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")

	for i in Players.active_players:
		var hero = HERO.instance() as Hero
		hero.world = self
		hero.set_player(i)
		hero.spawn_center()
		_heroes.add_child(hero)


func _process(delta):
	_adjust_camera(delta)
	_check_game_over()
	
	if _time_manager._play_mode == TimeManager.PlayMode.PAUSED and not get_tree().paused:
		_time_manager.resume()
	
	if Input.is_action_just_pressed("pause") and not get_tree().paused:
		_time_manager.pause()
		_pause.show_pause()


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
	_particle_manager.add_particle(particle_type, loc, traj, player, size, flags)


func add_projectile(projectile: Projectile):
	_projectiles.add_child(projectile)


func _check_game_over():
	var all_done = true
	for i in Players.MAX_PLAYERS:
		var hero = get_hero(i)
		if not hero:
			continue
		if hero.exists:
			all_done = false
	
	if all_done:
		Players.reset_players()
		get_tree().change_scene("res://menu/main_menu.tscn")


func _adjust_camera(delta: float):
	var tl = Vector2()
	var br = Vector2()
	var first = true
	var buffer = 200.0
	for i in Players.MAX_PLAYERS:
		var hero = get_hero(i)
		if hero and hero.exists:
			if first:
				first = false
				tl = hero.position
				br = hero.position
			if hero.position.x < tl.x:
				tl.x = hero.position.x
			if hero.position.x > br.x:
				br.x = hero.position.x
			if hero.position.y < tl.y:
				tl.y = hero.position.y
			if hero.position.y > br.y:
				br.y = hero.position.y
	
	tl -= Vector2(buffer, buffer)
	br += Vector2(buffer, buffer)
	_camera.position = (tl + br) * 0.5
	
	var zoom_goal = 1.0
	var dif = (br - tl)
	var max_area = Vector2(Map.MAP_SIZE.x, Map.MAP_SIZE.y)
	
	var zoom_diff = dif / max_area
	if zoom_diff.x > zoom_diff.y:
		zoom_goal = zoom_diff.x * Map.MAP_SCALE
	else:
		zoom_goal = zoom_diff.y * Map.MAP_SCALE

	zoom_goal = max(1.0, zoom_goal)
	
	var zoom = (zoom_goal - _camera.zoom.x) * delta * 3.0
	_camera.zoom += Vector2(zoom, zoom)
	if _camera.zoom.x > Map.MAP_SCALE:
		_camera.zoom = Vector2(Map.MAP_SCALE, Map.MAP_SCALE)
	if _camera.zoom.x < 1.0:
		_camera.zoom = Vector2(1.0, 1.0)


func _on_beat(phase: int, beat: int):
	_spawn_manager.do_click(phase, beat)


func _on_joy_connection_changed(device: int, connected: bool):
	print("joy ", device, " ", "connected" if connected else "disconnected")


func _on_the_end():
	_game.visible = false
	for i in Players.MAX_PLAYERS:
		var hero = get_hero(i)
		if hero and hero.exists:
			Players.add_points(i, Players.get_lives(i) * 10000)
			Players.set_lives(i, 1)
			hero._kill()
