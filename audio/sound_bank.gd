extends Node

var EXPLODE_FX = load("res://assets/sfx/fx/explode.wav")


func _ready():
	Events.connect("quitting", self, "_on_quitting")


func _process(delta):
	for i in get_child_count():
		var player = get_child(i) as AudioStreamPlayer
		if not player or player.is_queued_for_deletion():
			continue
		if not player.playing:
			player.queue_free()


func explode():
	play(EXPLODE_FX, -18.0)


func play(stream, db: float):	
	var player = AudioStreamPlayer.new()
	player.bus = "Sound"
	player.stream = stream
	player.volume_db = db
	player.play()
	add_child(player)


func _on_quitting():
	for i in get_child_count():
		var player = get_child(i) as AudioStreamPlayer
		if player:
			player.stop()
