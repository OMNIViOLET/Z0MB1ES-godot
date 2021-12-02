extends Node

const MAX_PLAYERS = 4
const NO_AVAILABLE_SLOTS = -1
const DEVICE_NOT_ASSIGNED = -1

signal slot_updated(slot)
signal slots_updated()

var active_players = 0
var players = [
	PlayerInfo.new(),
	PlayerInfo.new(),
	PlayerInfo.new(),
	PlayerInfo.new()
]


func _init():
	reset_players()


func reset_players():
	active_players = 0
	players[0].player_name = "Player 1"
	players[0].color = Color(0.5, 0.5, 1.0)
	players[1].player_name = "Player 2"
	players[1].color = Color(1.0, 0.5, 0.5)
	players[2].player_name = "Player 3"
	players[2].color = Color(1.0, 1.0, 0.5)
	players[3].player_name = "Player 4"
	players[3].color = Color(0.5, 1.0, 0.5)
	_on_slots_updated()


func add_points(player: int, points: int):
	get_player_info(player).points += points


func get_points(player: int) -> int:
	return get_player_info(player).points


func set_points(player: int, points: int):
	get_player_info(player).points = points


func get_lives(player: int) -> int:
	return get_player_info(player).lives


func add_lives(player: int, lives: int):
	get_player_info(player).lives += lives


func set_lives(player: int, lives: int):
	get_player_info(player).lives = lives


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


func get_slot_device(slot: int) -> int:
	return players[slot].device_id


func get_slot_device_type(slot: int) -> int:
	return players[slot].device_type


func get_device_slot(device_id: int, device_type: int) -> int:
	for i in MAX_PLAYERS:
		if players[i].device_id == device_id and players[i].device_type == device_type:
			return i
	return DEVICE_NOT_ASSIGNED


func ready_slot(slot: int):
	if get_slot_state(slot) == PlayerInfo.PlayerState.OUT:
		active_players += 1
	players[slot].ready_player()
	_on_slot_updated(slot)


func unready_slot(slot: int):
	if get_player_info(slot).player_state == PlayerInfo.PlayerState.IN:
		active_players -= 1
	players[slot].unready_player()
	_on_slot_updated(slot)


func is_any_slot_filled() -> bool:
	for i in MAX_PLAYERS:
		if players[i].player_state != PlayerInfo.PlayerState.OUT:
			return true
	return false


func get_slot_state(slot: int) -> int:
	return players[slot].player_state


func all_slots_ready() -> bool:
	var any_ready = false
	var all_ready = true
	
	for i in active_players:
		var ready = get_slot_state(i) == PlayerInfo.PlayerState.READY
		if ready:
			any_ready = true
		all_ready = all_ready and ready
	
	return any_ready and all_ready


func _on_slot_updated(slot: int):
	emit_signal("slot_updated", slot)


func _on_slots_updated():
	emit_signal("slots_updated")
