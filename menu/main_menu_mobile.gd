extends Node2D
class_name MainMenuMobile

var _selected = 0

var _button_colors = [
	Color.lime,
	Color.red,
	Color.yellow,
	Color.blue
]

onready var _buttons = [
	$StartGame,
	$QuitGame,
	$Scores,
	$Settings
]


func _ready():
	Players.set_slot_device(0, 0, PlayerInfo.DeviceType.JOYPAD)
	Players.set_slot_state(0, PlayerInfo.PlayerState.READY)
	Players.active_players = 1


func _process(delta):
	for i in _buttons.size():
		_buttons[i].flashing = _selected == i
		_buttons[i].modulate = Color.white if _selected == i else _button_colors[i]
	
	if Input.is_action_just_pressed("ui_up"):
		_selected -= 1
		if _selected < 0:
			_selected = 0
	if Input.is_action_just_pressed("ui_down"):
		_selected += 1
		if _selected >= _buttons.size():
			_selected = _buttons.size() - 1
	if Input.is_action_just_pressed("ui_left"):
		_selected -= 2
		if _selected < 0:
			_selected = 0
	if Input.is_action_just_pressed("ui_right"):
		_selected += 2
		if _selected >= _buttons.size():
			_selected = _buttons.size() - 1
	if Input.is_action_just_pressed("ui_accept"):
		match _selected:
			0:
				get_tree().change_scene("res://world/game_world.tscn")
			1:
				get_tree().quit()
			2:
				get_tree().change_scene("res://menu/high_scores_menu.tscn")
			3:
				get_tree().change_scene("res://menu/settings_menu.tscn")
		
