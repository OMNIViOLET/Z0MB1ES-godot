extends Control
class_name Quit

var _primary_device_type = PlayerInfo.DeviceType.JOYPAD
var _selected = 0

onready var _ok := $ButtonContainer/OK
onready var _cancel := $ButtonContainer/Cancel
onready var _options = [
	$TextContainer/OptionsContainer/Accept,
	$TextContainer/OptionsContainer/Cancel
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


func _input(event):
	var device_type = PlayerInfo.DeviceType.JOYPAD
	if event is InputEventKey:
		device_type = PlayerInfo.DeviceType.KEYBOARD

	if Input.is_action_just_pressed("ui_down"):
		if event.device == 0:
			_primary_device_type = device_type

		_selected += 1
		if _selected >= _options.size():
			_selected = 0
	elif Input.is_action_just_pressed("ui_up"):
		if event.device == 0:
			_primary_device_type = device_type

		_selected -= 1
		if _selected < 0:
			_selected = _options.size() - 1
	elif Input.is_action_just_pressed("ok"):
		if event.device == 0:
			_primary_device_type = device_type

		match _selected:
			0:
				get_tree().quit()
			1:
				get_tree().change_scene("res://menu/main_menu.tscn")
	elif Input.is_action_just_pressed("cancel"):
		if event.device == 0:
			_primary_device_type = device_type

		get_tree().change_scene("res://menu/main_menu.tscn")
