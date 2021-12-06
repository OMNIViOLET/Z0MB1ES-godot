extends Node

const SCORE_FILE = "user://high_scores.txt"
const MAX_SCORES = 10

var high_scores = []


func _init():
	for i in MAX_SCORES:
		high_scores.append(HighScore.new())


func _ready():
	load_scores()


func add_score(player_name: String, score: int):
	var high = MAX_SCORES - 1
	for i in range(MAX_SCORES - 1, -1, -1):
		if score < high_scores[i].score:
			break
		high = i
	for i in range(MAX_SCORES - 2, high - 1, -1):
		high_scores[i + 1].player_name = high_scores[i].player_name
		high_scores[i + 1].score = high_scores[i].score
	high_scores[high].player_name = player_name
	high_scores[high].score = score
	save_scores()


func load_scores():
	var i = 0
	
	var f = File.new()
	if f.file_exists(SCORE_FILE):
		f.open(SCORE_FILE, File.READ)
		while not f.eof_reached() and i < MAX_SCORES:
			var score = f.get_line()
			if score and not score.empty():
				var splits = score.split('~')
				var high_score = HighScore.new()
				high_score.player_name = splits[0]
				high_score.score = int(splits[1])
				high_scores[i] = high_score
				i += 1
		f.close()


func save_scores():
	var f = File.new()
	f.open(SCORE_FILE, File.WRITE)
	for i in MAX_SCORES:
		var high_score = high_scores[i] as HighScore
		var s = "%s~%d" % [ high_score.player_name, high_score.score ]
		f.store_line(s)
	f.close()


class HighScore:
	var player_name = ""
	var score = 0

