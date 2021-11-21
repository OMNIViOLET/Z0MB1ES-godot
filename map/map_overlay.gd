extends Node2D
class_name MapOverlay

const DOWN = 1.57
const RIGHT = 0.0
const LEFT = 3.14
const UP = 4.71

const ZOMBIES = "Z0MB1ES!!1"
const PANIC = "PAN1C!!!!11"
const I = "I"
const MADE = "MAD3"
const A = "A"
const GAME = "GAEM"
const WITH = "W1TH"
const ZOM = "Z0M"
const BIES = "B1ES"
const INIT = "IN 1T!!!1"
const KARATE = "KARATE"
const PUNCH = "PUNCH!!1"
const DIE_IN = "D1E 1N"
const A_FIRE = "A F1RE!!1"
const MASSIVE = "MASS1VE"
const OUTRO = "OUTRO!!1"

enum LightMode {
	NONE,
	SLOW_WHITE,
	BLINK_WHITE,
	RAINBOW_BLINK,
	BLINK_BLUE,
	SLOW_RED,
	SLOW_GOO,
	BLINK_RED,
	SOFT_WHITE,
	SLOW_BLUE,
	RED_LASERS,
	BLUE_LASERS,
	RAINBOW_LASERS,
	GREEN_LASERS
}

enum TextLocation {
	TOP,
	BOTTOM,
	CENTER
}

export(NodePath) var map_path
export(NodePath) var time_manager_path

var _frame = 0.0
var _lasers = []
var _lights = []
var _laser_index = 0
var _light_index = 0
var _max_lights = 0
var _max_lasers = 0
var _fonts = {
	50: load("res://assets/font/imagwzii_50.fnt"),
	60: load("res://assets/font/imagwzii_60.fnt"),
	70: load("res://assets/font/imagwzii_70.fnt"),
	80: load("res://assets/font/imagwzii_80.fnt"),
	110: load("res://assets/font/imagwzii_110.fnt")
}

onready var _lasers_container := $Lasers
onready var _lights_container := $Lights
onready var _map := get_node(map_path) as Map
onready var _text1 := $TextContainer/VBoxContainer/Text1
onready var _text2 := $TextContainer/VBoxContainer/Text2
onready var _center_text := $TextContainer/CenterText
onready var _time_manager := get_node(time_manager_path) as TimeManager


func _ready():
	_load_lights()
	_load_lasers()


func _process(delta):
	_map.goal_brite = 1.0

	_update_frame_time(delta)
	_reset_lasers()
	_reset_lights()
	_reset_text()
	_setup_phase()
	
	_max_lights = max(_max_lights, _light_index)
	_max_lasers = max(_max_lasers, _laser_index)
	print("max lights: ", _max_lights)
	print("max lasers: ", _max_lasers)


func _update_frame_time(delta: float):
	_frame += delta
	if _frame > Map.MAX_FRAME:
		_frame -= Map.MAX_FRAME


func _setup_phase():
	match _time_manager.get_phase():
		TimeManager.Phase.INTRO_THEME:
			_setup_intro_theme()
		TimeManager.Phase.SKA:
			_setup_ska()
		TimeManager.Phase.SPACE:
			_setup_space()
		TimeManager.Phase.ROCK:
			_setup_rock()
		TimeManager.Phase.JUNGLE:
			_setup_jungle()
		TimeManager.Phase.METAL:
			_setup_metal()
		TimeManager.Phase.OUTTRO_THEME:
			_setup_outtro_theme()


func _setup_intro_theme():
	var beat = _time_manager.get_beat()

	if beat < 64:
		_draw_imagwzii(beat - 64)
	elif beat < 80:
		_draw_lights(LightMode.BLINK_RED)
		_draw_lights(LightMode.BLINK_WHITE)
		_draw_imagwzii(beat - 64)
	elif beat < 144:
		_draw_lights(LightMode.SLOW_RED)
		_draw_imagwzii(beat - 144)
	elif beat < 160:
		_draw_lights(LightMode.SOFT_WHITE)
		_draw_lights(LightMode.BLINK_WHITE)
		_draw_imagwzii(beat - 144)
		_draw_imagwzii(beat - 160)
	elif beat < 176:
		_draw_lights(LightMode.SOFT_WHITE)
		_draw_lights(LightMode.BLINK_BLUE)
		_draw_imagwzii(beat - 160)
		_draw_imagwzii(beat - 176)
	elif beat < 192:
		_draw_lights(LightMode.SOFT_WHITE)
		_draw_lights(LightMode.BLINK_RED)
		_draw_lights(LightMode.BLINK_BLUE)
		_draw_imagwzii(beat - 176)
	elif beat < 224:
		_draw_lights(LightMode.SOFT_WHITE)
		_draw_lights(LightMode.RAINBOW_BLINK)
		_draw_lights(LightMode.BLINK_RED)
		_draw_lights(LightMode.BLINK_BLUE)
		
		if beat >= 192:
			_draw_text(
				PANIC if beat % 2 == 0 else ZOMBIES, 
				50, 
				TextLocation.TOP, 
				Color.white, 
				true
			)
			_draw_text(
				ZOMBIES if beat % 2 == 0 else PANIC, 
				50, 
				TextLocation.BOTTOM,
				Color.white, 
				true
			)
	else:
		_draw_lights(LightMode.SLOW_BLUE)


func _setup_ska():
	var beat = _time_manager.get_beat()

	if beat < 16:
		pass
	elif beat < 96:
		_draw_lights(LightMode.SLOW_GOO)
	elif beat < 112:
		if ((beat - 96) / 2) % 2 == 0:
			_draw_lights(LightMode.RED_LASERS)
			_draw_lights(LightMode.BLUE_LASERS)
			
			_draw_text(
				KARATE if (_time_manager.get_quadbeat() / 2) % 2 == 0 else PUNCH,
				50,
				TextLocation.TOP,
				Color.white,
				true
			)
			_draw_text(
				PUNCH if (_time_manager.get_quadbeat() / 2) % 2 == 0 else KARATE,
				50,
				TextLocation.BOTTOM,
				Color.white,
				true
			)
		else:
			_draw_lights(LightMode.SLOW_RED)
	elif beat < 160:
			_draw_lights(LightMode.SLOW_GOO)
	else:
		if ((beat - 160) / 2) % 2 == 0:
			_draw_lights(LightMode.RED_LASERS)
			_draw_lights(LightMode.BLUE_LASERS)
			_draw_lights(LightMode.GREEN_LASERS)
			
			_draw_text(
				DIE_IN if (_time_manager.get_quadbeat() / 2) % 2 == 0 else A_FIRE,
				50,
				TextLocation.TOP,
				Color.white,
				true
			)
			_draw_text(
				A_FIRE if (_time_manager.get_quadbeat() / 2) % 2 == 0 else DIE_IN,
				50,
				TextLocation.BOTTOM,
				Color.white,
				true
			)
		else:
			_draw_lights(LightMode.SLOW_RED)


func _setup_space():
	_map.goal_brite = 0.5


func _setup_rock():
	var beat = _time_manager.get_beat()
	
	if beat < 64:
		pass
	elif beat < 128:
		_draw_lights(LightMode.SOFT_WHITE)
		
		_draw_text(
			PANIC if beat % 2 == 0 else ZOMBIES,
			50,
			TextLocation.TOP,
			Color.white,
			true
		)
		_draw_text(
			ZOMBIES if beat % 2 == 0 else PANIC,
			50,
			TextLocation.BOTTOM,
			Color.white,
			true
		)
	if beat < 192:
		pass
	elif beat < 256:
		_draw_lights(LightMode.SOFT_WHITE)

		_draw_text(
			PANIC if beat % 2 == 0 else ZOMBIES,
			50,
			TextLocation.TOP,
			Color.white,
			true
		)
		_draw_text(
			ZOMBIES if beat % 2 == 0 else PANIC,
			50,
			TextLocation.BOTTOM,
			Color.white,
			true
		)
	else:
		_draw_lights(LightMode.SOFT_WHITE)
		_draw_lights(LightMode.RAINBOW_BLINK)
		_draw_lights(LightMode.BLINK_RED)
		_draw_lights(LightMode.BLINK_BLUE)


func _setup_jungle():
	var beat = _time_manager.get_beat()
	
	if beat < 32:
		pass
	elif beat < 64:
		_draw_lights(LightMode.RED_LASERS)
	elif beat < 96:
		pass
	elif beat < 126:
		_draw_lights(LightMode.BLUE_LASERS)
	elif beat < 128:
		pass
	elif beat < 158:
		_draw_lights(LightMode.GREEN_LASERS)
	elif beat < 160:
		pass
	elif beat < 190:
		_draw_lights(LightMode.GREEN_LASERS)
		_draw_lights(LightMode.BLUE_LASERS)
		_draw_lights(LightMode.RED_LASERS)
	elif beat < 192:
		pass
	elif beat < 222:
		_draw_lights(LightMode.GREEN_LASERS)
		_draw_lights(LightMode.BLUE_LASERS)
		_draw_lights(LightMode.RED_LASERS)


func _setup_metal():
	var beat = _time_manager.get_beat()
	
	if beat < 32:
		if (beat / 2) % 2 == 0:
			_draw_lights(LightMode.RED_LASERS)
			_draw_lights(LightMode.GREEN_LASERS)
	elif beat < 64:
		_draw_lights(LightMode.RED_LASERS)
		_draw_lights(LightMode.GREEN_LASERS)
		_draw_lights(LightMode.BLUE_LASERS)
	elif beat < 96:
		if (beat / 2) % 2 == 0:
			_draw_lights(LightMode.RED_LASERS)
			_draw_lights(LightMode.GREEN_LASERS)
	else:
		_draw_lights(LightMode.RED_LASERS)
		_draw_lights(LightMode.GREEN_LASERS)
		_draw_lights(LightMode.BLUE_LASERS)


func _setup_outtro_theme():
	var beat = _time_manager.get_beat()
	
	if beat < 4:
		_draw_imagwzii(beat - 4)
	elif beat < 52:
		_draw_lights(LightMode.SOFT_WHITE)
		_draw_lights(LightMode.RAINBOW_BLINK)
		_draw_imagwzii(beat - 4)
		_draw_imagwzii(beat - 20)
		_draw_imagwzii(beat - 36)
	elif beat < 100:
		_draw_lights(LightMode.SOFT_WHITE)
		_draw_lights(LightMode.RAINBOW_BLINK)
		
		_draw_text(
			PANIC if beat % 2 == 0 else ZOMBIES,
			50,
			TextLocation.TOP,
			Color.white,
			true
		)
		_draw_text(
			ZOMBIES if beat % 2 == 0 else PANIC,
			50,
			TextLocation.BOTTOM,
			Color.white,
			true
		)
	elif beat < 196:
		_draw_lights(LightMode.SOFT_WHITE)
		_draw_lights(LightMode.RAINBOW_BLINK)
	elif beat < 212:
		_draw_lights(LightMode.SOFT_WHITE)
		_draw_lights(LightMode.RAINBOW_BLINK)
		_draw_lights(LightMode.BLINK_RED)
		_draw_lights(LightMode.BLINK_BLUE)
	elif beat < 220:
		_draw_lights(LightMode.SOFT_WHITE)
		_draw_lights(LightMode.RAINBOW_BLINK)
		_draw_lights(LightMode.BLUE_LASERS)
	elif beat < 228:
		_draw_lights(LightMode.SOFT_WHITE)
		_draw_lights(LightMode.RAINBOW_BLINK)
		_draw_lights(LightMode.RED_LASERS)
		_draw_lights(LightMode.BLINK_RED)
	else:
		match (beat % 3):
			0:
				_draw_lights(LightMode.GREEN_LASERS)
				_draw_lights(LightMode.BLINK_RED)
			1:
				_draw_lights(LightMode.RED_LASERS)
				_draw_lights(LightMode.BLINK_BLUE)
			2:
				_draw_lights(LightMode.BLUE_LASERS)
				_draw_lights(LightMode.BLINK_WHITE)
		
		_draw_text(
			MASSIVE if beat % 2 == 0 else OUTRO,
			50,
			TextLocation.TOP,
			Color.white,
			true
		)
		_draw_text(
			OUTRO if beat % 2 == 0 else MASSIVE,
			50,
			TextLocation.BOTTOM,
			Color.white,
			true
		)


func _draw_lights(mode: int):
	_map.goal_brite = 0.5
	
	match mode:
		LightMode.BLINK_BLUE:
			_draw_blink_lights(2, 1.0, Color(0.2, 0.2, 1.0, 0.125))
		LightMode.BLINK_RED:
			_draw_blink_lights(4, 2.0, Color(1.0, 0.2, 0.2, 0.125))
		LightMode.BLINK_WHITE:
			_draw_blink_lights(0, 0.0, Color(1.0, 1.0, 1.0, 0.125))
		LightMode.BLUE_LASERS:
			_draw_lasers(2, 4, 2.0, Color(0.1, 0.1, 1.0, 0.25))
		LightMode.GREEN_LASERS:
			_draw_lasers(0, 5, 1.0, Color(0.1, 1.0, 0.1, 0.25))
		LightMode.NONE:
			pass
		LightMode.RAINBOW_BLINK:
			_draw_blink_lights(0, 3.0, Color.white, true)
		LightMode.RAINBOW_LASERS:
			# Unused
			pass
		LightMode.RED_LASERS:
			_draw_lasers(2, 3, 0.0, Color(1.0, 0.1, 0.1, 0.25))
		LightMode.SLOW_BLUE:
			_draw_slow_lights(Color(0.35, 0.35, 1.0, 0.25))
		LightMode.SLOW_GOO:
			_draw_slow_lights(Color.white, true)
		LightMode.SLOW_RED:
			_draw_slow_lights(Color(1.0, 0.1, 0.1, 0.25))
		LightMode.SLOW_WHITE:
			_draw_slow_lights(Color(1.0, 1.0, 1.0, 0.25))
		LightMode.SOFT_WHITE:
			for i in range(1, 6):
				_draw_light(
					Vector2(i * Map.MAP_SIZE.x / 6.0, 0.0), 
					DOWN + cos(float(i) + _frame) * 0.5, 
					Color(1.0, 1.0, 1.0, 0.125)
				)
				_draw_light(
					Vector2(i * Map.MAP_SIZE.x / 6.0, Map.MAP_SIZE.y), 
					UP + cos(float(i) + _frame) * 0.5, 
					Color(1.0, 1.0, 1.0, 0.25)
				)
				_draw_light(
					Vector2(0.0, i * Map.MAP_SIZE.y / 6.0), 
					RIGHT + cos(float(i) + _frame) * 0.5, 
					Color(1.0, 1.0, 1.0, 0.125)
				)
				_draw_light(
					Vector2(Map.MAP_SIZE.x, i * Map.MAP_SIZE.y / 6.0), 
					LEFT + cos(float(i) + _frame) * 0.5, 
					Color(1.0, 1.0, 1.0, 0.25)
				)


func _draw_blink_lights(rate: int, offset: float, color: Color, rainbow: bool = false):
	var beat = _time_manager.get_octobeat() + rate
	for i in range(1, 6):
		if ((i % 2) * 2) == (beat % 4):
			if rainbow:
				color = Color(
					sin(float(i) + _frame) * 0.5 + 0.5,
					sin(float(i) + _frame + 1.0) * 0.5 + 0.5,
					sin(float(i) + _frame + 2.0) * 0.5 + 0.5,
					0.125
				)

			_draw_light(
				Vector2(float(i) * Map.MAP_SIZE.x / 6.0, 0.0), 
				DOWN + cos(float(i) + offset + _frame * 2.0) * 0.5, 
				color
			)
			_draw_light(
				Vector2(float(i) * Map.MAP_SIZE.x / 6.0, Map.MAP_SIZE.y), 
				UP + cos(float(i) + offset + _frame * 2.0) * 0.5, 
				color
			)
			_draw_light(
				Vector2(0.0, float(i) * Map.MAP_SIZE.y / 6.0), 
				RIGHT + cos(float(i) + offset + _frame * 2.0) * 0.5, 
				color
			)
			_draw_light(
				Vector2(Map.MAP_SIZE.x, float(i) * Map.MAP_SIZE.y / 6.0), 
				LEFT + cos(float(i) + offset + _frame * 2.0) * 0.5, 
				color
			)


func _draw_slow_lights(color: Color, goo: bool = false):
	for i in range(1, 6):
		if goo:
			color = Color(
				sin(float(i) + _frame) * 0.5 + 0.5,
				sin(float(i) + _frame + 1.0) * 0.5 + 0.5,
				sin(float(i) + _frame + 2.0) * 0.5 + 0.5,
				0.25
			)
			
		_draw_light(
			Vector2(float(i) * Map.MAP_SIZE.x / 6.0, 0.0), 
			DOWN + cos(float(i) + _frame) * 0.5, 
			color
		)
		_draw_light(
			Vector2(float(i) * Map.MAP_SIZE.x / 6.0, Map.MAP_SIZE.y), 
			UP + cos(float(i) + _frame) * 0.5, 
			color
		)
		_draw_light(
			Vector2(0.0, float(i) * Map.MAP_SIZE.y / 6.0), 
			RIGHT + cos(float(i) + _frame) * 0.5, 
			color
		)
		_draw_light(
			Vector2(Map.MAP_SIZE.x, float(i) * Map.MAP_SIZE.y / 6.0), 
			LEFT + cos(float(i) + _frame) * 0.5, 
			color
		)


func _draw_lasers(divisor: int, interval: int, offset: float, color: Color):
	var beat = _time_manager.get_quadbeat()
	if divisor > 0:
		beat /= divisor
		
	for i in range(1, 6):
		if (i % interval) == (beat % interval):
			_draw_laser(
				i,
				Vector2(float(i) * Map.MAP_SIZE.x / 6.0, 0.0),
				DOWN,
				offset,
				color
			)
			_draw_laser(
				i,
				Vector2(float(i) * Map.MAP_SIZE.x / 6.0, Map.MAP_SIZE.y),
				UP,
				offset,
				color
			)

	for i in range(1, 5):
		if (i % interval) == (beat % interval):
			_draw_laser(
				i,
				Vector2(0.0, float(i) * Map.MAP_SIZE.y / 5.0),
				RIGHT,
				offset,
				color
			)
			_draw_laser(
				i,
				Vector2(Map.MAP_SIZE.x, float(i) * Map.MAP_SIZE.y / 5.0),
				LEFT,
				offset,
				color
			)


func _draw_laser(index: int, pos: Vector2, rot_base: float, offset: float, color: Color):
	var laser = _lasers[_laser_index] as Laser
	laser.modulate = color
	laser.position = pos
	laser.rotate_lasers(_frame, index, rot_base, offset)
	laser.visible = true
	_laser_index += 1


func _draw_light(pos: Vector2, rot: float, color: Color):
	var light = _lights[_light_index] as Sprite
	light.modulate = color
	light.position = pos
	light.rotation = rot
	light.visible = true
	_light_index += 1


func _load_lights():
	_lights.clear()
	for i in _lights_container.get_child_count():
		_lights.append(_lights_container.get_child(i))


func _load_lasers():
	_lasers.clear()
	for i in _lasers_container.get_child_count():
		_lasers.append(_lasers_container.get_child(i))


func _reset_lights():
	_light_index = 0
	for light in _lights:
		light.visible = false


func _reset_lasers():
	_laser_index = 0
	for laser in _lasers:
		laser.visible = false


func _reset_text():
	_text1.text = ""
	_text2.text = ""
	_center_text.text = ""


func _draw_text(text: String, size: int, location: int, color: Color = Color.white, flashing: bool = false):
	var label: IMAGWZIIText = null
	match location:
		TextLocation.TOP:
			label = _text1
		TextLocation.BOTTOM:
			label = _text2
		TextLocation.CENTER:
			label = _center_text

	label.add_font_override("font", _fonts[size])
	label.text = text
	label.modulate = color
	label.modulate.a = 0.2
	label.flashing = flashing
	
	if location == TextLocation.CENTER:
		label.rect_position.y = (Map.MAP_SIZE.y - (size * 5.0)) * 0.5


func _draw_imagwzii(progress: int):
	var beat = progress + 64
	if beat == 63:
		_draw_text(I, 110, TextLocation.CENTER, Color.white, true)
	elif beat >= 64 and beat <= 66:
		_draw_text(MADE, 70, TextLocation.CENTER, Color.white, true)
	elif beat == 67:
		_draw_text(A, 70, TextLocation.CENTER, Color.white, true)
	elif beat >= 68 and beat <= 70:
		_draw_text(GAME, 80, TextLocation.CENTER, Color.white, true)
	elif beat == 71:
		_draw_text(WITH, 60, TextLocation.CENTER, Color.white, true)
	elif beat >= 72 and beat <= 73:
		_draw_text(ZOM, 70, TextLocation.CENTER, Color.white, true)
	elif beat >= 74 and beat <= 75:
		_draw_text(BIES, 60, TextLocation.CENTER, Color.white, true)
	elif beat >= 76 and beat <= 77:
		_draw_text(INIT, 50, TextLocation.CENTER, Color.white, true)
