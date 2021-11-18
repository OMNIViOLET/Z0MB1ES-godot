extends Node

const MAX_PLAYERS = 4
const NO_AVAILABLE_SLOTS = -1
const DEVICE_NOT_ASSIGNED = -1

signal slot_updated(slot)
signal slots_updated()

var players = [
	PlayerInfo.new(),
	PlayerInfo.new(),
	PlayerInfo.new(),
	PlayerInfo.new()
]


func _init():
	reset_players()


func reset_players():
	players[0].player_name = "Player 1"
	players[0].color = Color(0.5, 0.5, 1.0)
	players[1].player_name = "Player 2"
	players[1].color = Color(1.0, 0.5, 0.5)
	players[2].player_name = "Player 3"
	players[2].color = Color(1.0, 1.0, 0.5)
	players[3].player_name = "Player 4"
	players[3].color = Color(0.5, 1.0, 0.5)
	_on_slots_updated()


func get_player_info(slot: int) -> PlayerInfo:
	return players[slot]


func occupy_slot(slot: int):
	players[slot].player_state == PlayerInfo.PlayerState.IN
	_on_slot_updated(slot)


func free_slot(slot: int):
	players[slot].player_state == PlayerInfo.PlayerState.OUT
	_on_slot_updated(slot)


func get_available_slot() -> int:
	for i in MAX_PLAYERS:
		if players[i].player_state == PlayerInfo.PlayerState.OUT:
			return i
	return NO_AVAILABLE_SLOTS


func set_slot_device(slot: int, device_id: int, device_type: int):
	players[slot].set_device(device_id, device_type)
	_on_slot_updated(slot)


func get_device_slot(device_id: int, device_type: int) -> int:
	for i in MAX_PLAYERS:
		if players[i].device_id == device_id and players[i].device_type == device_type:
			return i
	return DEVICE_NOT_ASSIGNED


func ready_slot(slot: int):
	players[slot].ready_player()
	_on_slot_updated(slot)


func unready_slot(slot: int):
	players[slot].unready_player()
	_on_slot_updated(slot)


func is_any_slot_filled() -> bool:
	for i in MAX_PLAYERS:
		if players[i].player_state != PlayerInfo.PlayerState.OUT:
			return true
	return false


func is_slot_ready(slot: int) -> bool:
	return players[slot].player_state == PlayerInfo.PlayerState.READY


func all_slots_ready() -> bool:
	var ready = true
	for i in MAX_PLAYERS:
		ready = ready and is_slot_ready(i)
	return ready


func _on_slot_updated(slot: int):
	emit_signal("slot_updated", slot)


func _on_slots_updated():
	emit_signal("slots_updated")
