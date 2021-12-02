tool
extends Node2D
class_name DynamicText

enum Justify {
	LEFT,
	RIGHT,
	CENTER
}

export(String) var text = "" setget _set_text, _get_text
export(float) var size = 1.0 setget _set_text_size, _get_text_size
export(Justify) var justify: int = Justify.LEFT setget _set_justify, _get_justify
export(bool) var flashing = false setget _set_flashing, _get_flashing
export(float) var flash_color_min = 0.5
export(float) var flash_color_max = 1.0
export(float) var flash_color_alpha = 1.0

var _shapes = []
var _shape_map = {}
var _width = 0


func _init():
	_create_text_shapes()


func _process(_delta):
	if flashing:
		update()


func _draw():
	var loc = global_position
	match justify:
		Justify.RIGHT:
			loc.x -= _width
		Justify.CENTER:
			loc.x -= _width * 0.5
	loc.y -= size * 2.5
	
	var shape_color = Color(
				rand_range(flash_color_min, flash_color_max),
				rand_range(flash_color_min, flash_color_max),
				rand_range(flash_color_min, flash_color_max),
				flash_color_alpha
			)
	
	for i in _shapes.size():
		var shape = _shapes[i] as TextShape
		if flashing:
			shape.render(self, loc, size, shape_color)
		else:
			shape.render(self, loc, size, Color.white)
		loc.x += shape.get_size(size)


func set_score(score: int):
	var _text = ""
	var t = score
	while t > 0:
		_text = _text.insert(0, str(t % 10))
		t /= 10
	text = _text


func _set_text(value: String):
	text = value
	_get_shapes()
	update()


func _get_text() -> String:
	return text


func _set_justify(value: int):
	justify = value
	update()


func _get_justify() -> int:
	return justify


func _set_flashing(value: bool):
	flashing = value
	update()


func _get_flashing() -> bool:
	return flashing


func _set_text_size(value: float):
	size = value
	_get_shapes()
	update()


func _get_text_size() -> float:
	return size


func _get_shapes():
	_shapes.clear()
	_width = 0

	if not text or text.empty():
		return

	for i in text.length():
		var c = text[i]
		var shape = _get_shape(c)
		_shapes.append(shape)
		_width += shape.get_size(size)


func _get_shape(character: String) -> TextShape:
	if _shape_map.has(character):
		return _shape_map[character] as TextShape
	return _shape_map['*'] as TextShape


func _add_shape(character: String, glyph: Array):
	var shape = TextShape.new()
	shape.configure(glyph)
	_shape_map[character] = shape


func _create_text_shapes():
	_shape_map.clear()

	# Lowercase
	_add_shape('a', [ 00000, 00000, 01110, 01010, 01111 ])
	_add_shape('b', [ 00100, 00100, 00111, 00101, 00111 ])
	_add_shape('c', [ 00000, 00000, 00111, 00100, 00111 ])
	_add_shape('d', [ 00001, 00001, 00111, 00101, 00111 ])
	_add_shape('e', [ 00000, 00110, 01111, 01000, 00110 ])
	_add_shape('f', [ 00001, 00010, 00111, 00010, 00010 ])
	_add_shape('g', [ 00111, 00101, 00111, 00001, 00110 ])
	_add_shape('h', [ 00100, 00100, 00110, 00101, 00101 ])
	_add_shape('i', [ 00001, 00000, 00001, 00001, 00001 ])
	_add_shape('j', [ 00001, 00000, 00001, 00001, 00010 ])
	_add_shape('k', [ 00100, 00100, 00111, 00110, 00101 ])
	_add_shape('l', [ 00001, 00001, 00001, 00001, 00001 ])
	_add_shape('m', [ 00000, 00000, 11110, 10101, 10101 ])
	_add_shape('n', [ 00000, 00000, 00110, 00101, 00101 ])
	_add_shape('o', [ 00000, 00000, 00111, 00101, 00111 ])
	_add_shape('p', [ 00000, 00110, 00101, 00110, 00100 ])
	_add_shape('q', [ 00000, 00011, 00101, 00011, 00001 ])
	_add_shape('r', [ 00000, 00000, 00011, 00010, 00010 ])
	_add_shape('s', [ 00011, 00100, 00010, 00001, 00110 ])
	_add_shape('t', [ 00000, 00010, 00111, 00010, 00010 ])
	_add_shape('u', [ 00000, 00000, 00101, 00101, 00011 ])
	_add_shape('v', [ 00000, 00000, 00101, 00101, 00010 ])
	_add_shape('w', [ 00000, 00000, 10101, 10101, 01010 ])
	_add_shape('x', [ 00000, 00000, 00101, 00010, 00101 ])
	_add_shape('y', [ 00000, 00000, 00101, 00011, 00111 ])
	_add_shape('z', [ 00000, 00111, 00010, 00100, 00111 ])

	# Uppercase
	_add_shape('A', [ 00111, 00101, 00111, 00101, 00101 ])
	_add_shape('B', [ 00111, 00101, 00110, 00101, 00111 ])
	_add_shape('C', [ 00111, 00100, 00100, 00100, 00111 ])
	_add_shape('D', [ 00110, 00101, 00101, 00101, 00110 ])
	_add_shape('E', [ 00111, 00100, 00110, 00100, 00111 ])
	_add_shape('F', [ 00111, 00100, 00110, 00100, 00100 ])
	_add_shape('G', [ 01111, 01000, 01011, 01001, 01111 ])
	_add_shape('H', [ 00101, 00101, 00111, 00101, 00101 ])
	_add_shape('I', [ 00111, 00010, 00010, 00010, 00111 ])
	_add_shape('J', [ 00001, 00001, 00001, 00001, 00110 ])
	_add_shape('K', [ 00101, 00101, 00110, 00101, 00101 ])
	_add_shape('L', [ 00100, 00100, 00100, 00100, 00111 ])
	_add_shape('M', [ 10001, 11011, 10101, 10001, 10001 ])
	_add_shape('N', [ 10001, 11001, 10101, 10011, 10001 ])
	_add_shape('O', [ 01110, 10001, 10001, 10001, 01110 ])
	_add_shape('P', [ 00110, 00101, 00110, 00100, 00100 ])
	_add_shape('Q', [ 01110, 10001, 10101, 10011, 01111 ])
	_add_shape('R', [ 01110, 01001, 01110, 01010, 01001 ])
	_add_shape('S', [ 00111, 01000, 00110, 00001, 01110 ])
	_add_shape('T', [ 00111, 00010, 00010, 00010, 00010 ])
	_add_shape('U', [ 00101, 00101, 00101, 00101, 00111 ])
	_add_shape('V', [ 10001, 10001, 01010, 01010, 00100 ])
	_add_shape('W', [ 10001, 10101, 10101, 10101, 01010 ])
	_add_shape('X', [ 10001, 01010, 00100, 01010, 10001 ])
	_add_shape('Y', [ 10001, 01010, 00100, 00100, 00100 ])
	_add_shape('Z', [ 11111, 00010, 00100, 01000, 11111 ])

	# Numbers
	_add_shape('0', [ 01110, 10011, 10101, 11001, 01110 ])
	_add_shape('1', [ 00010, 00110, 00010, 00010, 00111 ])
	_add_shape('2', [ 00110, 00001, 00010, 00100, 00111 ])
	_add_shape('3', [ 01110, 00001, 00110, 00001, 01110 ])
	_add_shape('4', [ 00010, 01010, 01111, 00010, 00010 ])
	_add_shape('5', [ 00111, 00100, 00110, 00001, 00110 ])
	_add_shape('6', [ 00011, 00100, 00111, 00101, 00111 ])
	_add_shape('7', [ 01111, 00001, 00010, 00100, 00100 ])
	_add_shape('8', [ 00110, 01001, 00110, 01001, 00110 ])
	_add_shape('9', [ 00110, 01001, 00111, 00001, 00001 ])

	# Punctuation
	_add_shape('.', [ 00000, 00000, 00000, 00000, 00001 ])
	_add_shape('\'', [ 00001, 00001, 00000, 00000, 00000 ])
	_add_shape('"', [ 00101, 00101, 00000, 00000, 00000 ])
	_add_shape('!', [ 00001, 00001, 00001, 00000, 00001 ])
	_add_shape('?', [ 00111, 00001, 00010, 00000, 00010 ])
	_add_shape(',', [ 00000, 00000, 00000, 00001, 00011 ])
	_add_shape('-', [ 00000, 00000, 00111, 00000, 00000 ])
	_add_shape('+', [ 00000, 00010, 00111, 00010, 00000 ])
	_add_shape('#', [ 01010, 11111, 01010, 11111, 01010 ])
	_add_shape(' ', [ 00000, 00000, 00000, 00000, 00000 ])
	_add_shape(':', [ 00000, 00010, 00000, 00010, 00000 ])
	_add_shape('*', [ 10101, 01110, 11111, 01110, 10101 ])
	_add_shape('(', [ 00001, 00010, 00010, 00010, 00001 ])
	_add_shape(')', [ 00010, 00001, 00001, 00001, 00010 ])
	_add_shape('=', [ 00000, 11111, 00000, 11111, 00000 ])
	
