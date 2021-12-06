extends Node2D
class_name Quit

var _primary_device_type = PlayerInfo.DeviceType.JOYPAD
var _selected = 0

onready var _ok := $Ok
onready var _cancel := $Cancel
onready var _options = [
	$Option1,
	$Option2
]


func _process(_delta):
	for i in _options.size():
		_options[i].modulate = Color.white
		_options[i].flashing = i == _selected

	match _primary_device_type:
		PlayerInfo.DeviceType.JOYPAD:
			_ok.text = "(A) ok"
			_cancel.text = "(B) cancel"
		PlayerInfo.DeviceType.KEYBOARD:
			_ok.text = "(enter) ok"
			_cancel.text = "(esc) cancel"

	if Input.is_action_just_pressed("ui_down"):
		_selected += 1
		if _selected >= _options.size():
			_selected = 0
	elif Input.is_action_just_pressed("ui_up"):
		_selected -= 1
		if _selected < 0:
			_selected = _options.size() - 1
	elif Input.is_action_just_pressed("ok"):
		match _selected:
			0:
				get_tree().quit()
			1:
				get_tree().change_scene("res://menu/main_menu.tscn")
	elif Input.is_action_just_pressed("cancel"):
		get_tree().change_scene("res://menu/main_menu.tscn")


func _input(event):
	var device_type = PlayerInfo.DeviceType.JOYPAD
	if event is InputEventKey:
		device_type = PlayerInfo.DeviceType.KEYBOARD
		_primary_device_type = device_type
	elif event.device == 0:
		_primary_device_type = device_type

