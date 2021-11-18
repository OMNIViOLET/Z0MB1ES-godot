extends Control
class_name MainMenu


var _device_grace = {}
var _primary_device_type = PlayerInfo.DeviceType.JOYPAD

onready var _subtitle := $TitleContainer/Subtitle
onready var _ok := $ButtonContainer/OK
onready var _cancel := $ButtonContainer/Cancel
onready var _scores := $ButtonContainer/Scores
onready var _settings := $ButtonContainer/Settings


func _ready():
	_subtitle.visible = false


func _process(delta):
	if not _subtitle.visible and Players.is_any_slot_filled():
		_subtitle.visible = true
	elif _subtitle.visible and not Players.is_any_slot_filled():
		_subtitle.visible = false
	
	match _primary_device_type:
		PlayerInfo.DeviceType.JOYPAD:
			_ok.text = "(A) ok"
			_cancel.text = "(B) cancel"
			_scores.text = "(Y) scores"
			_settings.text = "(X) settings"
		PlayerInfo.DeviceType.KEYBOARD:
			_ok.text = "(enter) ok"
			_cancel.text = "(esc) cancel"
			_scores.text = "(F1) scores"
			_settings.text = "(F2) settings"
	
	_device_grace.clear()


func _input(event):
	# We give input a grace frame to allow semi-ambiguous input events 
	# to not cause false positives across multiple devices.
	if _device_grace.has(event.device) and _device_grace[event.device]:
		return

	var device_type = PlayerInfo.DeviceType.JOYPAD
	if event is InputEventKey:
		device_type = PlayerInfo.DeviceType.KEYBOARD
	var slot = Players.get_device_slot(event.device, device_type)

	if Input.is_action_just_pressed("player_ready"):
		if event.device == 0:
			_primary_device_type = device_type

		_device_grace[event.device] = true
		if slot == Players.DEVICE_NOT_ASSIGNED:
			slot = Players.get_available_slot()
			if slot == Players.NO_AVAILABLE_SLOTS:
				return
			
		Players.ready_slot(slot)
		Players.set_slot_device(slot, event.device, device_type)
	elif Input.is_action_just_pressed("player_cancel"):
		if event.device == 0:
			_primary_device_type = device_type

		_device_grace[event.device] = true
		if slot == Players.DEVICE_NOT_ASSIGNED:
			if event.device == 0:
				get_tree().change_scene("res://menu/quit.tscn")
			return
		Players.unready_slot(slot)
	elif Input.is_action_just_pressed("cancel"):
		if event.device == 0:
			_primary_device_type = device_type
			
		if slot == Players.DEVICE_NOT_ASSIGNED:
			get_tree().change_scene("res://menu/quit.tscn")
