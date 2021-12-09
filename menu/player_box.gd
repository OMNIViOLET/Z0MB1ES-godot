extends Node2D
class_name PlayerBox

export(int) var slot = 0

onready var _player_name := get_node("PlayerName")
onready var _text1 := get_node("Text1")
onready var _text2 := get_node("Text2")


func _ready():
	Players.connect("slot_updated", self, "_on_slot_updated")
	Players.connect("slots_updated", self, "_on_slots_updated")
	update_player_box()


func update_player_box():
	var info = Players.get_player_info(slot)
	if not info:
		return
		
	_player_name.text = info.player_name
	_player_name.modulate = Color.gray

	_text1.modulate = Color.white
	_text1.flashing = false
	_text2.modulate = Color.white
	_text2.flashing = false
	match info.player_state:
		PlayerInfo.PlayerState.OUT:
			_text1.text = "j0in"
			_text2.text = "game!1"
		PlayerInfo.PlayerState.IN:
			_text1.text = "ready??"
			
			if info.device_type == PlayerInfo.DeviceType.JOYPAD:
				_text2.text = "press (A)!"
			else:
				_text2.text = "press (enter)!"
			_text2.flashing = true
		PlayerInfo.PlayerState.READY:
			_text1.text = "READY!!!1"
			_text1.modulate = info.color
			_text2.text = ""


func _on_slot_updated(slot: int):
	if self.slot != slot: 
		return
	update_player_box()


func _on_slots_updated():
	update_player_box()
