extends Node2D
class_name Laser


func rotate_lasers(frame: float, index: int, rot_base: float, offset: float):
	for i in get_child_count():
		var r = rot_base + cos(offset + float(index) + float(i) / 4.0 + frame) * 0.5
		var child = get_child(i) as Sprite
		child.rotation = r
