extends Sprite
class_name Legs

export(int) var leg_index
export(float) var speed = 1.0

var angle = 0.0
var frame_time = 0.0
var traj = Vector2.ZERO


func _process(delta):
	_handle_rotation(delta)
	_update_position()


func _handle_rotation(delta: float):
	var goal_angle = angle
	var tl = traj.length()
	if tl > 0.0:
		goal_angle = traj.angle()
		frame_time += tl * delta * 11.0 * speed
		if frame_time > 6.28:
			frame_time -= 6.28
	else:
		if frame_time > 0.0:
			var unstep = 15.0
			if frame_time < 1.57:
				frame_time -= delta * unstep
				if frame_time < 0.0:
					frame_time = 0.0
			elif frame_time < 3.14:
				frame_time += delta * unstep
				if frame_time >= 3.14:
					frame_time = 0.0
			elif frame_time < 4.71:
				frame_time -= delta * unstep
				if frame_time <= 3.14:
					frame_time = 0.0
			else:
				frame_time += delta * unstep
				if frame_time >= 6.28:
					frame_time = 0.0
	
	var diff = goal_angle - angle
	while diff < -PI:
		diff += PI * 2.0
	while diff > PI:
		diff -= PI * 2.0

	angle += diff * delta * 10.0


func _update_position():
	var ta = angle + (PI if leg_index == 1 else 0.0)
	position = Vector2(
		cos(ta) * sin(frame_time) * 8.0,
		sin(ta) * cos(frame_time) * 8.0 # original sin/sin possible bug?
	)
	rotation = ta
