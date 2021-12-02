extends DynamicText
class_name FPS


func _process(delta):
	text = str(Engine.get_frames_per_second())
