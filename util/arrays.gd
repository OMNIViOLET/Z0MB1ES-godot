extends Node


func init2D(width: int, height: int, default) -> Array:
	var out = Array()
	for i in range(0, height):
		var row = Array()
		for j in range(0, width):
			row.append(default)
		out.append(row)
	return out
