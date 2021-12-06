extends Node2D
class_name Pause

var _primary_device_type = PlayerInfo.DeviceType.JOYPAD
var _selected = 0

onready var _ok := $Ok
onready var _cancel := $Cancel
onready var _options = [
	$Option1,
	$Option2
]


func _process(_delta):
	if not visible:
		return

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
	if not visible:
		return
		
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
				hide_pause()
			1:
				Events.emit_signal("quitting")
				Players.reset_players()
				get_tree().paused = false
				get_tree().change_scene("res://menu/main_menu.tscn")
	elif Input.is_action_just_pressed("cancel"):
		if event.device == 0:
			_primary_device_type = device_type
		hide_pause()


func show_pause():
	visible = true
	get_tree().paused = true


func hide_pause():
	visible = false
	get_tree().paused = false
