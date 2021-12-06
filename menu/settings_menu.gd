extends Node2D
class_name SettingsMenu

var _primary_device_type = PlayerInfo.DeviceType.JOYPAD
var _selected = 0
var _master_volume = 1.0
var _music_volume = 1.0
var _sound_volume = 1.0
var _fullscreen = true
var _device_grace = {}

onready var _ok := $Ok
onready var _master_volume_value := $MasterVolume
onready var _music_volume_value := $MusicVolume
onready var _sound_volume_value := $SoundVolume
onready var _fullscreen_value := $FullscreenOpt
onready var _options = [
	$Master,
	$Music,
	$Sound,
	$Fullscreen
]


func _ready():
	_master_volume = db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	_music_volume = db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	_sound_volume = db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Sound")))
	_fullscreen = OS.window_fullscreen


func _process(_delta):
	for i in _options.size():
		_options[i].modulate = Color.white
		_options[i].flashing = i == _selected

	_master_volume_value.text = str(round(_master_volume * 100))
	_music_volume_value.text = str(round(_music_volume * 100))
	_sound_volume_value.text = str(round(_sound_volume * 100))
	_fullscreen_value.text = "On" if _fullscreen else "Off"

	_device_grace.clear()
	
	match _primary_device_type:
		PlayerInfo.DeviceType.JOYPAD:
			_ok.text = "(A) ok"
		PlayerInfo.DeviceType.KEYBOARD:
			_ok.text = "(enter) ok"


func _input(event):
	# We give input a grace frame to allow semi-ambiguous input events 
	# to not cause false positives across multiple devices.
	if _device_grace.has(event.device) and _device_grace[event.device]:
		return

	var device_type = PlayerInfo.DeviceType.JOYPAD
	if event is InputEventKey:
		device_type = PlayerInfo.DeviceType.KEYBOARD
		_primary_device_type = device_type
	elif event.device == 0:
		_primary_device_type = device_type

	if Input.is_action_just_pressed("ui_down"):
		_device_grace[event.device] = true
		_selected += 1
		if _selected >= _options.size():
			_selected = 0
	elif Input.is_action_just_pressed("ui_up"):
		_device_grace[event.device] = true
		_selected -= 1
		if _selected < 0:
			_selected = _options.size() - 1
	elif Input.is_action_just_pressed("ui_left"):
		_device_grace[event.device] = true
		match _selected:
			0:
				_master_volume = max(0.0, _master_volume - 0.1)
				AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(_master_volume))
			1:
				_music_volume = max(0.0, _music_volume - 0.1)
				AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear2db(_music_volume))
			2:
				_sound_volume = max(0.0, _sound_volume - 0.1)
				AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound"), linear2db(_sound_volume))
			3:
				_fullscreen = false
				OS.window_fullscreen = false
				OS.window_borderless = false
				OS.window_size = Vector2(1280.0, 720.0)
				OS.center_window()
	elif Input.is_action_just_pressed("ui_right"):
		_device_grace[event.device] = true
		match _selected:
			0:
				_master_volume = min(1.0, _master_volume + 0.1)
				AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(_master_volume))
			1:
				_music_volume = min(1.0, _music_volume + 0.1)
				AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear2db(_music_volume))
			2:
				_sound_volume = min(1.0, _sound_volume + 0.1)
				AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound"), linear2db(_sound_volume))
			3:
				_fullscreen = true
				OS.window_fullscreen = true
				OS.window_borderless = true
	elif Input.is_action_just_pressed("ok") or Input.is_action_just_pressed("cancel"):
		_device_grace[event.device] = true
		get_tree().change_scene("res://menu/main_menu.tscn")
