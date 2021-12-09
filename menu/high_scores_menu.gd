extends Node2D
class_name HighScoresMenu


func _ready():
	HighScores.load_scores()
	
	var loc = Vector2(490.0, 210.0)
	var line = 40.0
	var size = 6.0
	
	for i in HighScores.MAX_SCORES:
		if HighScores.high_scores[i].score <= 0:
			continue
			
		# Rank
		var text = DynamicText.new()
		text._create_text_shapes()
		text.position = loc + Vector2(-50.0, (float(i) * line))
		text.size = size
		text.justify = DynamicText.Justify.RIGHT
		text.set_score(i + 1)
		text.modulate = Color.red
		add_child(text)
		
		# Name
		var text2 = DynamicText.new()
		text2._create_text_shapes()
		text2.position = loc + Vector2(0.0, (float(i) * line))
		text2.size = size
		text2.justify = DynamicText.Justify.LEFT
		text2.text = HighScores.high_scores[i].player_name
		text2.modulate = Color.white
		add_child(text2)
		
		# Score
		var text3 = DynamicText.new()
		text3._create_text_shapes()
		text3.position = loc + Vector2(420.0, (float(i) * line))
		text3.size = size
		text3.justify = DynamicText.Justify.RIGHT
		text3.set_score(HighScores.high_scores[i].score)
		text3.modulate = Color.white
		add_child(text3)


func _process(delta):
	if Input.is_action_just_pressed("ok") or Input.is_action_just_pressed("cancel"):
		_exit()


func _exit():
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		get_tree().change_scene("res://menu/main_menu_mobile.tscn")
	else:
		get_tree().change_scene("res://menu/main_menu.tscn")
