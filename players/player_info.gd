class_name PlayerInfo

enum DeviceType {
	KEYBOARD,
	JOYPAD
}

enum PlayerState {
	OUT,
	IN,
	READY
}

var color = Color.white
var device_id = -1
var device_type = DeviceType.KEYBOARD
var player_name = "player"
var player_state = PlayerState.OUT


func set_device(device_id: int, device_type: int):
	self.device_id = device_id
	self.device_type = device_type


func ready_player():
	match player_state:
		PlayerState.OUT:
			player_state = PlayerState.IN
		PlayerState.IN:
			player_state = PlayerState.READY


func unready_player():
	match player_state:
		PlayerState.IN:
			player_state = PlayerState.OUT
			set_device(-1, DeviceType.KEYBOARD)
		PlayerState.READY:
			player_state = PlayerState.IN
