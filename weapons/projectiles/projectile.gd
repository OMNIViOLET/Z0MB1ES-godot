extends Area2D
class_name Projectile

export(float) var lifetime = 0.0

var player = 0
var traj = Vector2.ZERO
var world = null


func _process(delta):
	position += traj * delta
	rotation = traj.angle() + PI
	lifetime -= delta
	if lifetime < 0.0:
		queue_free()
