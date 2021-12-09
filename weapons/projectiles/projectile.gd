extends Area2D
class_name Projectile

export(float) var lifetime = 0.0

var player = 0
var traj = Vector2.ZERO
var world = null
var exists = false


func _ready():
	exists = true


func _process(delta):
	rotation = traj.angle() + PI
	lifetime -= delta
	if lifetime < 0.0 and not is_queued_for_deletion():
		exists = false
		queue_free()


func _physics_process(delta):
	position += traj * delta
