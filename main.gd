extends Node2D
class_name Main


func _ready():
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		get_tree().change_scene("res://menu/main_menu_mobile.tscn")
	else:
		get_tree().change_scene("res://menu/main_menu.tscn")
