extends Node2D
class_name GameWorld


func _ready():
	$Managers/TimeManager.connect("beat", self, "_on_beat")


func _on_beat(phase: int, beat: int):
	print("phase: ", phase, "/beat: ", beat)
