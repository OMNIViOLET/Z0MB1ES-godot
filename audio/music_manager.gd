extends Node
class_name MusicManager

export(NodePath) var time_manager_path

var EPIC_OPUS = preload("res://assets/sfx/music/epicopus.mp3")

onready var _audio_player := $AudioStreamPlayer
onready var _time_manager := get_node(time_manager_path)


func _ready():
	_audio_player.stream = EPIC_OPUS


func _process(delta):
	if not _audio_player.playing:
		if _time_manager.can_start_playing():
			start()


func start():
	stop()
	_audio_player.play()
	_time_manager.start()


func stop():
	if _audio_player.playing:
		_audio_player.stop()


func seek(time: float):
	_audio_player.seek(time)


func pause():
	if _audio_player.playing:
		_audio_player.stream_paused = true


func resume():
	if _audio_player.stream_paused:
		_audio_player.stream_paused = false

