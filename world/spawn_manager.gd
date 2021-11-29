extends Node
class_name SpawnManager

const MAX_MONSTERS = 384

export(NodePath) var monster_container_path
export(NodePath) var world_path

var MONSTERS = {
	Monster.MonsterType.BIG_ASTEROID: load("res://characters/monsters/big_asteroid.tscn"),
	Monster.MonsterType.BIG_GOO: load("res://characters/monsters/big_goo.tscn"),
	Monster.MonsterType.BLARTARD: load("res://characters/monsters/blartard.tscn"),
	Monster.MonsterType.BOMBER: load("res://characters/monsters/bomber.tscn"),
	Monster.MonsterType.FACE_TRAIL: load("res://characters/monsters/face_trail.tscn"),
	Monster.MonsterType.FATTY: load("res://characters/monsters/fatty.tscn"),
	Monster.MonsterType.GEODE: load("res://characters/monsters/geode.tscn"),
	Monster.MonsterType.LITTLE_ASTEROID: load("res://characters/monsters/little_asteroid.tscn"),
	Monster.MonsterType.LITTLE_GOO: load("res://characters/monsters/little_goo.tscn"),
	Monster.MonsterType.MID_ASTEROID: load("res://characters/monsters/mid_asteroid.tscn"),
	Monster.MonsterType.ZOMBIE: load("res://characters/monsters/zombie.tscn")
}

var monsters = []

onready var _monster_container := get_node(monster_container_path)
onready var _world := get_node(world_path) as GameWorld


func _process(delta):
	for i in monsters.size():
		var monster = monsters[i] as Monster
		if monster and (not monster.exists or monster.hp < 0):
			monster.queue_free()
			monsters.remove(i)
	#print("monsters array: ", monsters.size())
	#print("actual monsters: ", _monster_container.get_child_count())


func do_click(phase: int, beats: int):
	match phase:
		TimeManager.Phase.INTRO_THEME:
			match beats:
				4, 43, 64, 128, 192:
					_make_goodies(4)
				224:
					_make_goodies(8)
			match beats:
				0, 4, 8, 16:
					_spawn(Monster.MonsterType.ZOMBIE, 16)
					_pop(Monster.MonsterType.ZOMBIE, 4)
				24, 32, 40, 48:
					_spawn(Monster.MonsterType.ZOMBIE, 36)
					_spawn(Monster.MonsterType.FATTY, 1)
					_pop(Monster.MonsterType.ZOMBIE, 2)
				64, 68, 72, 74, 76:
					_pop(Monster.MonsterType.ZOMBIE, 24)
					_pop(Monster.MonsterType.FATTY, 1)
				80, 88, 96, 104, 112:
					_spawn(Monster.MonsterType.ZOMBIE, 24)
					_pop(Monster.MonsterType.FATTY, 2)
				120, 124, 132, 140:
					_spawn(Monster.MonsterType.ZOMBIE, 24)
					_spawn(Monster.MonsterType.FATTY, 1)
					_pop(Monster.MonsterType.ZOMBIE, 2)
				144, 148, 152, 154, 156, 160, 164, 168, 170, 172, 176, 180, 184, 186, 188:
					_pop(Monster.MonsterType.ZOMBIE, 16)
					_pop(Monster.MonsterType.FATTY, 1)
				_:
					if beats >= 192 and beats <= 223:
						_pop(Monster.MonsterType.ZOMBIE, 16)
						_pop(Monster.MonsterType.FATTY, 1)
		TimeManager.Phase.SKA:
			match beats:
				0:
					_make_goodies(8)
				4, 112:
					_make_goodies(2)
				96, 160:
					_make_goodies(4)


func _make_goodies(count: int):
	for i in count:
		if Rand.coin_toss(0.3):
			#TODO: spawn power up
			pass


func _make_goodie(loc: Vector2):
	#TODO: spawn power up
	pass


func _get_adjusted_count(count: int) -> int:
	var c = 0
	for i in Players.MAX_PLAYERS:
		var hero = _world.get_hero(i)
		if hero and hero.exists and hero.lives > 0:
			c += 1
	
	match c:
		0, 1:
			if count < 3:
				return count
			return _float_to_int(count * 0.75)
		2:
			return count
		3:
			return _float_to_int(count * 1.5)
		4:
			return _float_to_int(count * 2.0)
	
	return int(count * 0.7)


func _float_to_int(v: float) -> int:
	var i = int(v)
	var r = v - float(i)
	return i + (1 if Rand.coin_toss(r) else 0)


func _spawn(monster_type: int, count: int):
	count = _get_adjusted_count(count)
	for i in count:
		_make_monster(_get_corner_vec(), monster_type)


func _pop(monster_type: int, count: int):
	count = _get_adjusted_count(count)
	for i in count:
		_make_monster(Rand.vec2(0.0, Map.MAP_SIZE.x, 0.0, Map.MAP_SIZE.y), monster_type, true)


func _make_monster(loc: Vector2, monster_type: int, midspawn: bool = false):
	var count = min(monsters.size(), MAX_MONSTERS)	
	
	var monster = MONSTERS[monster_type].instance()
	monster.world = _world
	monster.spawn(loc, midspawn)
	_monster_container.add_child(monster)

	if count < MAX_MONSTERS:
		monsters.append(monster)
	else:
		var oldest = 0
		var oldval = 0.0
		for i in count:
			var m = monsters[i] as Monster
			if m and (not m.exists or m.hp < 0.0):
				m.queue_free()
				monsters[i] = monster
				return
			elif m and m._age > oldval:
				oldest = i
				oldval = m._age
		var m = monsters[oldest] as Monster
		if m:
			m.queue_free()
		monsters[oldest] = monster


func _get_corner_vec() -> Vector2:
	var width = 400.0
	var loc = Vector2.ZERO
	
	if Rand.coin_toss(0.5):
		if Rand.coin_toss(0.5):
			loc = Rand.vec2(0.0, Map.MAP_SIZE.x, 0.0, 0.0) + Vector2(0.0, -width)
		else:
			loc = Rand.vec2(0.0, Map.MAP_SIZE.x, Map.MAP_SIZE.y, Map.MAP_SIZE.y) + Vector2(0.0, width)
	else:
		if Rand.coin_toss(0.5):
			loc = Rand.vec2(0.0, 0.0, 0.0, Map.MAP_SIZE.y) + Vector2(-width, 0.0)
		else:
			loc = Rand.vec2(Map.MAP_SIZE.x, Map.MAP_SIZE.x, 0.0, Map.MAP_SIZE.y) + Vector2(width, 0.0)
	
	return loc
