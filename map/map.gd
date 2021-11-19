extends Sprite
class_name Map

const MAX_FRAME = 20.0 * 6.28
const MAP_SCALE = 1.6
const MAP_SIZE = Vector2(1280.0, 720.0) * MAP_SCALE
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
const TEH_GAME = "TEH GAEM"
const IZ_ANGER = "IZ ANGRY!1"
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

export(NodePath) var time_manager_path

var GRASS_TEX = load("res://assets/gfx/grass.png")
var SKA_TEX = load("res://assets/gfx/ska.png")
var SPACE_TEX = load("res://assets/gfx/space.png")
var CONCRETE_TEX = load("res://assets/gfx/concrete.png")
var GRID_TEX = load("res://assets/gfx/grid.png")
var NEKO_TEX = load("res://assets/gfx/neko.png")
var FIRE_TEX = load("res://assets/gfx/fire.png")
var PSYCHO_NEKO_TEX = load("res://assets/gfx/psychoneko.png")

var _brite = 0.0
var _goal_brite = 1.0
var _frame = 0.0

onready var _space_overlay := $SpaceOverlay
onready var _jungle_overlay1 := $JungleOverlay1
onready var _jungle_overlay2 := $JungleOverlay2
onready var _text1 := $Text1
onready var _text2 := $Text2
onready var _time_manager := get_node(time_manager_path) as TimeManager
onready var _thresh := $Thresh


func _init():
	scale = Vector2(MAP_SCALE, MAP_SCALE)


func _ready():
	_space_overlay.visible = false
	_thresh.visible = false


func _process(delta):
	_update_frame_time(delta)
	_update_brite(delta)
	_setup_map()


func _update_frame_time(delta: float):
	_frame += delta
	if _frame > MAX_FRAME:
		_frame -= MAX_FRAME


func _update_brite(delta: float):
	if _brite > _goal_brite:
		_brite -= delta
		if _brite <= _goal_brite:
			_brite = _goal_brite

	if _brite < _goal_brite:
		_brite += delta
		if _brite >= _goal_brite:
			_brite = _goal_brite


func _setup_map():
	var a = 0.0
	
	_goal_brite = 1.0
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
	if _time_manager.get_track_left() < 8.0:
		_draw_map_trans(GRASS_TEX, SKA_TEX)
	else:
		_draw_map(GRASS_TEX)


func _setup_ska():
	if _time_manager.get_track_left() < 8.0:
		_draw_map_trans(SKA_TEX, SPACE_TEX)
	else:
		_draw_map(SKA_TEX)


func _setup_space():
	if _time_manager.get_track_left() < 8.0:
		_draw_map_trans(SPACE_TEX, CONCRETE_TEX)
	else:
		_draw_map(SPACE_TEX)
		_space_overlay.visible = true
		_space_overlay.rotation = _frame / 10.0
		_space_overlay.self_modulate.a = get_track_alpha()


func _setup_rock():
	_space_overlay.visible = false
	if _time_manager.get_track_left() < 8.0:
		_draw_map_trans(CONCRETE_TEX, GRID_TEX)
	else:
		_draw_map(CONCRETE_TEX)


func _setup_jungle():
	_jungle_overlay1.visible = true
	_jungle_overlay2.visible = true
	_draw_map(GRID_TEX)
	var a = get_track_alpha()
	_jungle_overlay1.rotation = _frame / 10.0
	_jungle_overlay1.self_modulate = Color(
		sin(1.0 + _frame) * 0.5 + 0.5,
		sin(1.0 + _frame + 1.0) * 0.5 + 0.5,
		sin(1.0 + _frame + 2.0) * 0.5 + 0.5,
		a
	)
	
	_jungle_overlay2.rotation = _frame / -15.0
	_jungle_overlay2.self_modulate = Color(
		sin(2.0 + _frame) * 0.5 + 0.5,
		sin(2.0 + _frame + 1.0) * 0.5 + 0.5,
		sin(2.0 + _frame + 2.0) * 0.5 + 0.5,
		a
	)


func _setup_metal():
	var beat = _time_manager.get_beat()
	var octobeat = _time_manager.get_octobeat()

	_text1.visible = false
	_text2.visible = false
	if beat < 32 or (beat >= 64 and beat < 96):
		if (beat / 2) % 2 == 0:
			if octobeat % 2 == 0:
				_draw_map(NEKO_TEX)
			else:
				_text1.text = TEH_GAME
				_text2.text = IZ_ANGER
				_text1.self_modulate = Color.white
				_text2.self_modulate = Color.white
				_text1.visible = true
				_text2.visible = true
		else:
			_draw_map(FIRE_TEX)
	else:
		if octobeat % 2 == 0:
			_draw_map(PSYCHO_NEKO_TEX)
		else:
			_draw_map(CONCRETE_TEX)


func _setup_outtro_theme():
	if _time_manager.get_track_time() < 2.0:
		_draw_map_trans(CONCRETE_TEX, GRASS_TEX)
	else:
		_draw_map(GRASS_TEX)


func get_track_alpha() -> float:
	var a = _time_manager.get_track_time()
	if a > 1.0:
		a = 1.0
		if _time_manager.get_track_left() < 10.0:
			a = (_time_manager.get_track_left() - 8.0) / 2.0
	return a


func _draw_map(texture: Texture):
	_thresh.visible = false
	self.texture = texture
	self_modulate = Color(_brite, _brite, _brite, 1.0)


func _draw_map_trans(texture: Texture, target: Texture):
	var t = 1.0 - ((_time_manager.get_track_left() / 8.0) + 0.2)
	var r = (1.0 - t) * _brite

	texture = texture
	self_modulate = Color(r, r, r, 1.0)

	_thresh.texture = target
	var shader_material = _thresh.material as ShaderMaterial
	shader_material.set_shader_param("v", 1.0 - t)
	shader_material.set_shader_param("b", _brite)
	_thresh.visible = true
