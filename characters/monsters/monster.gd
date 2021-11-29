extends Area2D
class_name Monster

enum MonsterType {
	ZOMBIE,
	FATTY,
	BIG_ASTEROID,
	MID_ASTEROID,
	LITTLE_ASTEROID,
	BIG_GOO,
	LITTLE_GOO,
	FACE_TRAIL,
	BOMBER,
	BLARTARD,
	GEODE
}

export(MonsterType) var monster_type = MonsterType.ZOMBIE
export(float) var speed = 80.0

var world = null
var exists = false
var target = 0
var hp = 0
var idx = 0
var spawn_frame = 0.0

var _traj = Vector2.ZERO
var _atraj = 0.0
var _shoot = Vector2.ZERO
var _vtarg = Vector2.ZERO
var _frame_time = 0.0
var _blar_frame = 0.0
var _iangle = 0
var _grace = 0.0
var _age = 0.0

onready var _leg1 := get_node_or_null("Legs1") as Legs
onready var _leg2 := get_node_or_null("Legs2") as Legs
onready var _body := get_node_or_null("Body") as Sprite


func _process(delta):
	if not exists:
		return
		
	if spawn_frame > 0.0:
		spawn_frame -= delta
		
	_age += delta

	_ai(delta)

	if _grace > 0.0:
		_grace -= delta


func _ai(delta: float):
	if target < 0:
		_traj = _vtarg - position
		if _traj.length() < 20.0:
			target = Rand.rint(0, 4)
	else:
		var hero = world.get_hero(target)
		if hero and hero.exists:
			_traj = hero.position - position
			if hero.respawn_frame > 0.0:
				_traj *= -1.0
				position.x = max(0.0, min(Map.MAP_SIZE.x, position.x))
				position.y = max(0.0, min(Map.MAP_SIZE.y, position.y))
		else:
			if Rand.coin_toss(0.5):
				target = (target + 1) % 4
			else:
				target = (target + 3) % 4
	_traj = _traj.normalized()
	
	if spawn_frame > 0.0:
		if monster_type == MonsterType.ZOMBIE or monster_type == MonsterType.BOMBER:
			_traj = Vector2.ZERO
			_body.rotation = spawn_frame * 9.0
	
	if _leg1:
		_leg1.traj = _traj
	if _leg2:
		_leg2.traj = _traj

	position += _traj * delta * speed
	var goal_angle = _body.rotation
	if _shoot.length() > 0.2:
		goal_angle = _shoot.angle() + PI
	elif _traj.length() > 0.0:
		goal_angle = _traj.angle() + PI
		match monster_type:
			MonsterType.BIG_GOO:
				pass
			MonsterType.LITTLE_GOO:
				pass
			_:
				if _leg1:
					goal_angle += sin(_leg1.frame_time) * 0.15
	var adif = goal_angle - _body.rotation
	while adif < -PI:
		adif += (PI * 2.0)
	while adif > PI:
		adif -= (PI * 2.0)
	_body.rotation += adif * delta * 10.0


func spawn(loc: Vector2, midspawn: bool = false):
	position = loc
	exists = true
	target = Rand.rint(0, 4)
	spawn_frame = 1.0 if midspawn else 0.0
	if midspawn and _body:
		_body.scale = Vector2.ZERO
	_age = 0.0
	_grace = 2.0
