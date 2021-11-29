extends Node
class_name SpawnManager

signal the_end_is_nigh()

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
var num_monsters = 0
var next_idx = 0

onready var _monster_container := get_node(monster_container_path)
onready var _world := get_node(world_path) as GameWorld


func _process(delta):
	num_monsters = 0
	var removals = []
	for i in range(0, monsters.size()):
		var monster = monsters[i]
		if not is_instance_valid(monster) or monster.is_queued_for_deletion():
			monsters[i] = null
			continue
		if monster and monster.exists:
			num_monsters += 1
		if monster and (not monster.exists or monster.hp < 0):
			removals.append(monster)
			monster.queue_free()

	for monster in removals:
		monsters.erase(monster)


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
			match beats:
				16, 17, 18, 19, 32, 33, 34, 35, 48, 49, 50, 51, 64, 65, 66, 67:
					_pop(Monster.MonsterType.BIG_GOO, 1)
					_pop(Monster.MonsterType.FACE_TRAIL, 1)
				96, 97, 100, 101, 104, 105, 108, 109:
					_pop(Monster.MonsterType.FATTY, 2)
					_spawn(Monster.MonsterType.ZOMBIE, 10)
					_pop(Monster.MonsterType.ZOMBIE, 10)
				112, 113, 114, 115, 128, 129, 130, 131, 144, 145, 146, 147, 160, 161, 162, 163:
					_pop(Monster.MonsterType.BIG_GOO, 1)
					_pop(Monster.MonsterType.FACE_TRAIL, 1)
				164, 165, 168, 169, 172, 173:
					_pop(Monster.MonsterType.FATTY, 2)
					_spawn(Monster.MonsterType.ZOMBIE, 10)
					_pop(Monster.MonsterType.ZOMBIE, 10)
				176:
					_pop(Monster.MonsterType.FATTY, 2)
					_spawn(Monster.MonsterType.ZOMBIE, 10)
					_pop(Monster.MonsterType.ZOMBIE, 10)
					_pop(Monster.MonsterType.BIG_GOO, 4)
					_pop(Monster.MonsterType.FACE_TRAIL, 4)
		TimeManager.Phase.SPACE:
			match beats:
				0:
					_clear_monsters()
					_make_goodies(12)
				64, 128, 192, 256:
					_make_goodies(4)
			match beats:
				0, 16, 32, 48, 64, 96, 128:
					_spawn(Monster.MonsterType.BIG_ASTEROID, 7)
		TimeManager.Phase.ROCK:
			match beats:
				0:
					_clear_monsters()
					_make_goodies(4)
				32, 64, 96, 128, 160, 192, 224, 256:
					_make_goodies(4)
			if beats % 4 == 0:
				_pop(Monster.MonsterType.BOMBER, 4)
				_spawn(Monster.MonsterType.BOMBER, 4)
			match beats:
				0, 32:
					_pop(Monster.MonsterType.FATTY, 2)
					_spawn(Monster.MonsterType.ZOMBIE, 20)
					_pop(Monster.MonsterType.ZOMBIE, 20)
					_spawn(Monster.MonsterType.BOMBER, 20)
					_pop(Monster.MonsterType.BOMBER, 20)
				16, 96:
					_pop(Monster.MonsterType.BIG_GOO, 6)
				64, 128:
					_pop(Monster.MonsterType.FATTY, 2)
					_spawn(Monster.MonsterType.ZOMBIE, 20)
					_pop(Monster.MonsterType.ZOMBIE, 20)
					_pop(Monster.MonsterType.FACE_TRAIL, 4)
					_spawn(Monster.MonsterType.BOMBER, 20)
					_pop(Monster.MonsterType.BOMBER, 20)
				160, 192:
					_pop(Monster.MonsterType.FATTY, 2)
					_spawn(Monster.MonsterType.ZOMBIE, 20)
					_pop(Monster.MonsterType.ZOMBIE, 20)
					_spawn(Monster.MonsterType.BOMBER, 10)
					_pop(Monster.MonsterType.BOMBER, 10)
				176, 240, 304:
					_spawn(Monster.MonsterType.BOMBER, 10)
					_pop(Monster.MonsterType.BOMBER, 10)
				224, 256, 288, 320:
					_pop(Monster.MonsterType.FATTY, 2)
					_spawn(Monster.MonsterType.ZOMBIE, 20)
					_pop(Monster.MonsterType.ZOMBIE, 20)
					_pop(Monster.MonsterType.FACE_TRAIL, 4)
					_spawn(Monster.MonsterType.BOMBER, 10)
					_pop(Monster.MonsterType.BOMBER, 10)
		TimeManager.Phase.JUNGLE:
			match beats:
				0, 32, 64, 128, 192:
					_make_goodies(4)
			match beats:
				0, 4, 8, 12, 16, 20, 24, 28:
					_pop(Monster.MonsterType.GEODE, 3)
					_spawn(Monster.MonsterType.GEODE, 3)
				32, 36, 40, 44, 48, 52, 56, 60:
					_pop(Monster.MonsterType.GEODE, 3)
					_spawn(Monster.MonsterType.GEODE, 3)
					_pop(Monster.MonsterType.BIG_GOO, 1)
				64, 68, 72, 76, 80, 84, 88, 92:
					_pop(Monster.MonsterType.GEODE, 4)
					_spawn(Monster.MonsterType.GEODE, 4)
				96, 100, 104, 108, 112, 116, 120, 124:
					_pop(Monster.MonsterType.GEODE, 5)
					_spawn(Monster.MonsterType.GEODE, 5)
					_pop(Monster.MonsterType.BIG_GOO, 1)
				128, 132, 136, 140, 144, 148, 152, 156:
					_pop(Monster.MonsterType.GEODE, 3)
					_spawn(Monster.MonsterType.GEODE, 3)
					_pop(Monster.MonsterType.BIG_GOO, 1)
					_pop(Monster.MonsterType.FACE_TRAIL, 1)
				160, 164, 168, 172, 176, 180, 184, 188, 192, 196, 200, 204, 208, 212, 216, 220:
					_pop(Monster.MonsterType.GEODE, 1)
					_spawn(Monster.MonsterType.GEODE, 1)
					_pop(Monster.MonsterType.BIG_GOO, 1)
					_pop(Monster.MonsterType.FACE_TRAIL, 1)
		TimeManager.Phase.METAL:
			match beats:
				0, 32, 64, 96:
					_make_goodies(4)
			match beats:
				0, 4, 8, 12, 16, 20, 24, 28, 64, 68, 72, 76, 80, 84, 88, 92:
					_pop(Monster.MonsterType.BLARTARD, 8)
					_pop(Monster.MonsterType.FACE_TRAIL, 1)
				32, 36, 40, 44, 48, 52, 56, 60, 96, 100, 104, 108, 112, 116, 120, 124:
					_pop(Monster.MonsterType.BLARTARD, 16)
					_pop(Monster.MonsterType.FACE_TRAIL, 1)
					_pop(Monster.MonsterType.BIG_GOO, 1)
		TimeManager.Phase.OUTTRO_THEME:
			match beats:
				0, 54, 196, 212, 220, 228:
					_make_goodies(8)
			match beats:
				4,  8, 12, 14, 16, 20, 24, 28, 30, 32:
					_pop(Monster.MonsterType.ZOMBIE, 24)
					_pop(Monster.MonsterType.FATTY, 1)
				36, 38, 40, 42, 44:
					_pop(Monster.MonsterType.ZOMBIE, 20)
					_pop(Monster.MonsterType.FATTY, 1)
					_pop(Monster.MonsterType.BOMBER, 4)
				54, 62, 70, 78, 84, 92, 100, 108:
					_spawn(Monster.MonsterType.ZOMBIE, 24)
					_pop(Monster.MonsterType.BOMBER, 24)
					_pop(Monster.MonsterType.FATTY, 2)
					_pop(Monster.MonsterType.BIG_GOO, 2)
				116, 124, 132, 140, 148, 156, 164, 172, 180, 188, 196:
					_spawn(Monster.MonsterType.ZOMBIE, 12)
					_pop(Monster.MonsterType.BOMBER, 4)
					_pop(Monster.MonsterType.FATTY, 2)
					_pop(Monster.MonsterType.BIG_GOO, 2)
					_pop(Monster.MonsterType.BLARTARD, 2)
					_pop(Monster.MonsterType.FACE_TRAIL, 1)
				200, 204, 208, 212, 214, 218, 222, 226, 230, 234, 238:
					_spawn(Monster.MonsterType.ZOMBIE, 12)
					_pop(Monster.MonsterType.BOMBER, 4)
					_pop(Monster.MonsterType.FATTY, 2)
					_pop(Monster.MonsterType.BIG_GOO, 2)
					_pop(Monster.MonsterType.BLARTARD, 4)
					_pop(Monster.MonsterType.FACE_TRAIL, 1)
				242, 248, 282, 256:
					_spawn(Monster.MonsterType.ZOMBIE, 24)
					_pop(Monster.MonsterType.BOMBER, 4)
					_pop(Monster.MonsterType.FATTY, 2)
					_pop(Monster.MonsterType.BIG_GOO, 2)
					_pop(Monster.MonsterType.BLARTARD, 4)
					_pop(Monster.MonsterType.FACE_TRAIL, 1)
				260:
					_clear_monsters()
		TimeManager.Phase.END:
			match beats:
				0:
					_clear_monsters()
					_on_the_end_is_nigh()


func make_goodie(loc: Vector2):
	#TODO: spawn power up
	pass


func _clear_monsters():
	for i in monsters.size():
		var monster = monsters[i]
		if not is_instance_valid(monster) or monster.is_queued_for_deletion():
			continue
		if monster:
			monster.queue_free()
	monsters.clear()


func _make_goodies(count: int):
	for i in count:
		if Rand.coin_toss(0.3):
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
	var count = min(num_monsters, MAX_MONSTERS)
	
	var monster = MONSTERS[monster_type].instance()
	monster.idx = next_idx
	next_idx += 1
	monster.world = _world
	monster.spawn(loc, midspawn)
	_monster_container.call_deferred("add_child", monster)

	if count < MAX_MONSTERS:
		monsters.append(monster)
	else:
		var oldest = 0
		var oldval = 0.0
		for i in monsters.size():
			var m = monsters[i]
			if not is_instance_valid(m) or m.is_queued_for_deletion():
				monsters[i] = null
				continue
			if m and (not m.exists or m.hp < 0.0):
				m.queue_free()
				monsters[i] = monster
				return
			elif not m or m._age > oldval:
				oldest = i
				if m:
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


func _on_the_end_is_nigh():
	emit_signal("the_end_is_nigh")
