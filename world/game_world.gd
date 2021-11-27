extends Node2D
class_name GameWorld

var HERO = load("res://characters/hero.tscn")

onready var _camera := $Camera2D
onready var _heroes := $Heroes

func _ready():
	$Managers/TimeManager.connect("beat", self, "_on_beat")
	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")

	for i in Players.active_players:
		var hero = HERO.instance() as Hero
		hero.set_player(i)
		hero.spawn_center()
		_heroes.add_child(hero)


func _process(delta):
	_camera.position = _heroes.get_child(0).position


func _on_beat(phase: int, beat: int):
	print("phase: ", phase, "/beat: ", beat)


func _on_joy_connection_changed(device: int, connected: bool):
	print("joy ", device, " ", "connected" if connected else "disconnected")
