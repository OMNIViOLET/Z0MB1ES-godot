extends Node
class_name TimeManager

signal beat(phase, beat)

enum PlayMode {
	STOPPED,
	PLAYING,
	PAUSED
}

enum Phase {
	INTRO_THEME,
	SKA,
	SPACE,
	ROCK,
	JUNGLE,
	METAL,
	OUTTRO_THEME,
	END
}

var _phase = Phase.INTRO_THEME
var _play_mode = PlayMode.STOPPED
var _start_time = 0.0
var _pause_start_time = 0.0
var _time = 0.0
var _time_slices = []
var _pulse = 0.0
var _beat = 0
var _quad_beat = 0
var _octo_beat = 0
var _track_time = 0.0
var _track_left = 0.0
var _play_num = 0


func _init():
	_create_time_slices()


func _process(delta):
	if _play_mode != PlayMode.PLAYING:
		return	
	
	var prev_beat = _beat
	var prev_time = _time
	
	var now = OS.get_ticks_msec()
	var diff = now - _start_time
	_time = float(diff) / 1000.0

	for i in _time_slices.size():
		if _time_slices[i].start < _time:
			_phase = i

	var current_slice = _time_slices[_phase] as TimeSlice
	var prog = _time - current_slice.start
	var beat_time = 60.0 / current_slice.bpm

	_pulse = prog
	_beat = 0
	while _pulse > beat_time:
		_pulse -= beat_time
		_beat += 1
	
	_pulse /= beat_time
	
	_quad_beat = _beat * 4 + int(_pulse * 4.0)
	_octo_beat = _beat * 8 + int(_pulse * 8.0)
	
	_track_time = _time - current_slice.start
	if _phase < _time_slices.size() - 1:
		_track_left = current_slice.start - _time
	else:
		_track_left = 0.0
	
	if _track_time >= 0.0:
		if _beat != prev_beat:
			_on_beat(_phase, _beat)
		else:
			var first_slice = _time_slices[0] as TimeSlice
			if prev_time < first_slice.start and _time >= first_slice.start:
				_on_beat(Phase.INTRO_THEME, 0)


func start():
	_beat = -1
	_phase = Phase.INTRO_THEME
	_start_time = OS.get_ticks_msec()
	_time = 0.0
	_play_mode = PlayMode.PLAYING
	_play_num += 1


func pause():
	_pause_start_time = OS.get_ticks_msec()
	_play_mode = PlayMode.PAUSED
	# TODO: Pause music


func resume():
	var diff = OS.get_ticks_msec() - _pause_start_time
	_start_time += diff
	_play_mode = PlayMode.PLAYING
	# TODO: Resume music


func _create_time_slices():
	_time_slices.clear()
	_create_time_slice(0, 0.0, 120.0)
	_create_time_slice(2, 0.0, 110.0)
	_create_time_slice(3, 36.0, 120.0)
	_create_time_slice(5, 32.0, 100.0)
	_create_time_slice(8, 44.0, 180.0)
	_create_time_slice(9, 58.666667, 110.0)
	_create_time_slice(11, 8.485, 120.0)
	_create_time_slice(13, 18.485, 120.0)


func _create_time_slice(minutes: int, seconds: float, bpm: float):
	var slice = TimeSlice.new()
	slice.calculate(minutes, seconds, bpm)
	_time_slices.append(slice)
	

func _on_beat(phase: int, beat: int):
	emit_signal("beat", phase, beat)
