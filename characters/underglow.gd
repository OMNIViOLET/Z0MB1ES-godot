extends Node2D
class_name Underglow

export(float) var size = 1.0
export(int) var player = 0

onready var _glow1 := $Glow1
onready var _glow2 := $Glow2
onready var _glow3 := $Glow3


func _ready():
	var c = Color.white
	match player:
		0:
			c = Color(0.2, 0.2, 1.0, 0.4)
		1:
			c = Color(1.0, 0.2, 0.2, 0.4)
		2:
			c = Color(1.0, 1.0, 0.2, 0.4)
		3:
			c = Color(0.2, 1.0, 0.2, 0.4)
	_glow1.modulate = c
	_glow2.modulate = c
	_glow3.modulate = c


func _process(delta):
	_glow1.scale = Vector2.ONE * (size + (0 * 0.04))
	_glow2.scale = Vector2.ONE * (size + (1 * 0.04))
	_glow3.scale = Vector2.ONE * (size + (2 * 0.04))
