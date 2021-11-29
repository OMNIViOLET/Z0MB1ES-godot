extends Monster
class_name Geode

onready var _body1 := $Body1
onready var _body2 := $Body2
onready var _body3 := $Body3


func _process(delta):
	if spawn_frame > 0.0:
		_body1.visible = true
		_body1.modulate = Color(
			0.7 + 0.3 * sin(_body1.rotation),
			0.7 + 0.3 * sin(_body1.rotation + 2.0),
			0.7 + 0.3 * sin(_body1.rotation + 4.0),
			0.5
		)
		_body1.scale = Vector2.ONE * (0.3 + spawn_frame / 2.0)
	else:
		_body1.visible = false

	_body2.modulate = Color(
		0.7 + 0.3 * sin(_body2.rotation),
		0.7 + 0.3 * sin(_body2.rotation + 2.0),
		0.7 + 0.3 * sin(_body2.rotation + 4.0),
		0.5
	)


func spawn(loc: Vector2, midspawn: bool = false):
	.spawn(loc, midspawn)
	_traj = Rand.vec2(-100.0, 100.0, -100.0, 100.0)
	_atraj = rand_range(-2.0, 2.0)


func _ai(delta: float):
	var hero = world.get_hero(target)
	if hero:
		if not hero.exists:
			if Rand.coin_toss(0.5):
				target = (target + 1) % 4
			else:
				target = (target + 3) % 4
		else:
			var a = (hero.position - position).angle() + PI
			var goal_traj = Vector2(cos(a), sin(a)) * -300.0
			_traj += (goal_traj - _traj) * delta * 0.3
	
	_body1.rotation += _atraj * delta
	_body2.rotation += _atraj * delta
	_body3.rotation += _atraj * delta
	
	_clamp_rotation(_body1)
	_clamp_rotation(_body2)
	_clamp_rotation(_body3)
	
	position += _traj * delta
	
	if position.x < 0.0:
		if _traj.x < 0.0:
			_traj.x = -_traj.x
	if position.x > Map.MAP_SIZE.x:
		if _traj.x > 0.0:
			_traj.x = -_traj.x
	if position.y < 0.0:
		if _traj.y < 0.0:
			_traj.y = -_traj.y
	if position.y > Map.MAP_SIZE.y:
		if _traj.y > 0.0:
			_traj.y = -_traj.y


func _clamp_rotation(body: Sprite):
	while body.rotation > (PI * 2.0):
		body.rotation -= (PI * 2.0)
	while body.rotation < 0.0:
		body.rotation += (PI * 2.0)
