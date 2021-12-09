class_name TextShape

const GLYPH_WIDTH = 5
const GLYPH_HEIGHT = 5

var width = 0

var _dot: Array


func render(canvas_item: Node2D, position: Vector2, size: float, color: Color):
	position.x += width * size
	for i in range(0, 5):
		for t in range(0, 5):
			if _dot[i][t]:
				var offset = Vector2(t * -size, i * size)
				var pos = (position + offset) - canvas_item.global_position
				var rect = Rect2(pos, Vector2(size, size))
				canvas_item.draw_rect(rect, color, true)


func get_size(scale: float) -> float:
	return (width + 1) * scale


func configure(src: Array):
	_dot = []
	for i in range(0, GLYPH_HEIGHT):
		var row = Array()
		for j in range(0, GLYPH_WIDTH):
			row.append(0)
		_dot.append(row)
			
	width = 0
	for i in src.size():
		var t = 0
		while src[i] > 0:
			_dot[i][t] = src[i] % 10 == 1
			src[i] /= 10
			t += 1
			if t > width:
				width = t

