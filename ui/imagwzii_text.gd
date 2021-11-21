extends Label
class_name IMAGWZIIText

export(float, 0.0, 1.0) var flash_range_min = 0.4
export(float, 0.0, 1.0) var flash_range_max = 1.0
export(bool) var flashing = false setget _set_flashing, _get_flashing

var _original_color = Color.white


func _ready():
	_original_color = modulate


func _process(_delta):
	if flashing:
		modulate = _get_random_color(flash_range_min, flash_range_max)


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
