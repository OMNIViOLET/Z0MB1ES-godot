extends Label
class_name IMAGWZIIText

const FLASH_RANGE_MIN = 0.4
const FLASH_RANGE_MAX = 1.0

export(bool) var flashing = false setget _set_flashing, _get_flashing

var _original_color = Color.white


func _ready():
	_original_color = modulate


func _process(_delta):
	if flashing:
		modulate = _get_random_color(FLASH_RANGE_MIN, FLASH_RANGE_MAX)


func _set_flashing(value: bool):
	if flashing == value:
		return
	
	flashing = value
	if flashing:
		_original_color = modulate
	else:
		modulate = _original_color


func _get_flashing() -> bool:
	return flashing


func _get_random_color(from: float, to: float) -> Color:
	randomize()
	return Color(
		rand_range(from, to),
		rand_range(from, to),
		rand_range(from, to),
		_original_color.a
	)
