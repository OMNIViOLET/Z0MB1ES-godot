extends Node2D
class_name MainMenu

const GO_TIME = 1.0

const JOYPAD_CANCEL = "(B) cancel"
const JOYPAD_OK = "(A) ok"
const JOYPAD_SETTINGS = "(X) settings"
const JOYPAD_SCORES = "(Y) scores"

const KEYBOARD_CANCEL = "(esc) cancel"
const KEYBOARD_OK = "(enter) ok"
const KEYBOARD_SETTINGS = "(F2) settings"
const KEYBOARD_SCORES = "(F1) scores"

var _device_grace = {}
var _go_timer = 0.0
var _primary_device_type = PlayerInfo.DeviceType.JOYPAD

onready var _subtitle := $Subtitle
onready var _ok := $Ok
onready var _cancel := $Cancel
onready var _scores := $Scores
onready var _settings := $Settings


func _ready():
	_subtitle.visible = false


func _process(delta):
	if not _subtitle.visible and Players.is_any_slot_filled():
		_subtitle.visible = true
	elif _subtitle.visible and not Players.is_any_slot_filled():
		_subtitle.visible = false
	
	match _primary_device_type:
		PlayerInfo.DeviceType.JOYPAD:
			_ok.text = JOYPAD_OK
			_cancel.text = JOYPAD_CANCEL
			_scores.text = JOYPAD_SCORES
			_settings.text = JOYPAD_SETTINGS
		PlayerInfo.DeviceType.KEYBOARD:
			_ok.text = KEYBOARD_OK
			_cancel.text = KEYBOARD_CANCEL
			_scores.text = KEYBOARD_SCORES
			_settings.text = KEYBOARD_SETTINGS
	
	_device_grace.clear()
	
	if Players.all_slots_ready():
		_go_timer += delta
		if _go_timer >= GO_TIME:
			get_tree().change_scene("res://world/game_world.tscn")
	else:
		_go_timer = 0.0


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
