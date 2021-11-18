extends Control
class_name MainMenu

enum PlayerState {
	OUT,
	IN,
	READY
}

var _device_grace = {}

onready var _subtitle := $TitleContainer/Subtitle


func _ready():
	Players.reset_players()
	_subtitle.visible = false


func _process(delta):
	if not _subtitle.visible and Players.is_any_slot_filled():
		_subtitle.visible = true
	elif _subtitle.visible and not Players.is_any_slot_filled():
		_subtitle.visible = false
	
	_device_grace.clear()


func _input(event):
	# We give input a grace frame to allow semi-ambiguous input events 
	# to not cause false positives across multiple devices.
	if _device_grace.has(event.device) and _device_grace[event.device]:
		return

	_device_grace[event.device] = true
	if Input.is_action_just_pressed("player_ready"):
		var device_type = PlayerInfo.DeviceType.KEYBOARD
		if event is InputEventJoypadButton:
			device_type = PlayerInfo.DeviceType.JOYPAD
		
		var slot = Players.get_device_slot(event.device, device_type)
		if slot == Players.DEVICE_NOT_ASSIGNED:
			slot = Players.get_available_slot()
			if slot == Players.NO_AVAILABLE_SLOTS:
				return
			
		Players.ready_slot(slot)
		Players.set_slot_device(slot, event.device, device_type)
	elif Input.is_action_just_pressed("player_cancel"):
		var device_type = PlayerInfo.DeviceType.KEYBOARD
		if event is InputEventJoypadButton:
			device_type = PlayerInfo.DeviceType.JOYPAD
		var slot = Players.get_device_slot(event.device, device_type)
		if slot == Players.DEVICE_NOT_ASSIGNED:
			return
		Players.unready_slot(slot)
