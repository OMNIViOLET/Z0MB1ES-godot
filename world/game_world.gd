extends Node2D
class_name GameWorld

var HERO = load("res://characters/hero.tscn")

var _hero = null

onready var _camera := $Camera2D
onready var _heroes := $Heroes

func _ready():
	$Managers/TimeManager.connect("beat", self, "_on_beat")

	Players.set_slot_device(0, 0, PlayerInfo.DeviceType.JOYPAD)

	_hero = HERO.instance() as Hero
	_hero.set_player(0)
	_hero.spawn_center()
	_heroes.add_child(_hero)


func _process(delta):
	_camera.position = _hero.position


func _on_beat(phase: int, beat: int):
	print("phase: ", phase, "/beat: ", beat)
